require 'rails-settings/setting_object'
require 'rails-settings/configuration'
require 'rails-settings/base'
require 'rails-settings/scopes'

ActiveRecord::Base.class_eval do
  def self.has_settings(options={}, &block)
    init(options)
  end

  def self.has_setting(key, options={})
    init(options[:settings])
    set key, options[:defaults]
  end

private
  def self.init(options = {})
    unless self.include? RailsSettings::Base
      self.class_attribute :default_settings, :setting_object_class_name
      self.default_settings = options[:defaults] || {}
      self.setting_object_class_name = options[:class_name] || 'RailsSettings::SettingObject'

      include RailsSettings::Base
      extend RailsSettings::Scopes
    end
  end

  def self.set(key, defaults={})
    raise ArgumentError.new("has_settings: Symbol expected, but got a #{key.class}") unless key.is_a?(Symbol)
    # raise ArgumentError.new("has_settings: Option :defaults expected, but got #{options.keys.join(', ')}") unless options.blank? || (options.keys == [:defaults])
    self.default_settings[key] = defaults.stringify_keys.freeze
  end
end

