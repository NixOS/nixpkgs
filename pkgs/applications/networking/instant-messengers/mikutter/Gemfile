alias __source_distinct__ source
def source(url)
  @loaded ||= {}
  unless @loaded[url]
    @loaded[url] = true
    __source_distinct__(url) end end

source 'https://rubygems.org'

ruby '>= 2.5.0'

group :default do
  gem 'addressable','>= 2.7.0', '< 2.8'
  gem 'delayer','>= 1.0.1', '< 1.1'
  gem 'delayer-deferred','>= 2.1.1', '< 2.2'
  gem 'diva','>= 1.0.1', '< 1.1'
  gem 'memoist','>= 0.16.2', '< 0.17'
  gem 'oauth','>= 0.5.4'
  gem 'pluggaloid','>= 1.2.0', '< 1.3'
  gem 'typed-array','>= 0.1.2', '< 0.2'
end

group :test do
  gem 'test-unit','>= 3.3.4', '< 4.0'
  gem 'rake','>= 13.0.1'
  gem 'mocha','>= 1.11.1'
  gem 'webmock','>= 3.7.6'
  gem 'ruby-prof','>= 1.1.0'
end


group :plugin do
  Dir.glob(File.expand_path(File.join(__dir__, 'plugin/*/Gemfile'))){ |path|
    eval File.open(path).read
  }
  Dir.glob(File.join(File.expand_path(ENV['MIKUTTER_CONFROOT'] || '~/.mikutter'), 'plugin/*/Gemfile')){ |path|
    eval File.open(path).read
  }
end
