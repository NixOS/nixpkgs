alias __source_distinct__ source
def source(url)
  @loaded ||= {}
  unless @loaded[url]
    @loaded[url] = true
    __source_distinct__(url) end end

source 'https://rubygems.org'

ruby '>= 2.3.0'

group :default do
  gem 'oauth', '>= 0.5.1'
  gem 'json_pure', '~> 1.8'
  gem 'addressable', '>= 2.5.2', '< 2.6'
  gem 'diva', '>= 0.3.2', '< 2.0'
  gem 'memoist', '>= 0.16', '< 0.17'
  gem 'ruby-hmac', '~> 0.4'
  gem 'typed-array', '~> 0.1'
  gem 'delayer', '~> 0.0'
  gem 'pluggaloid', '>= 1.1.1', '< 2.0'
  gem 'delayer-deferred', '>= 2.0', '< 3.0'
  gem 'twitter-text', '>= 2.1.0'
end

group :test do
  gem 'test-unit', '~> 3.0'
  gem 'rake', '~> 10.1'
  gem 'watch', '~> 0.1'
  gem 'mocha', '~> 0.14'
  gem 'webmock', '~> 1.17'
  gem 'ruby-prof'
end


group :plugin do
  Dir.glob(File.expand_path(File.join(__dir__, 'core/plugin/*/Gemfile'))){ |path|
    eval File.open(path).read
  }
  Dir.glob(File.join(File.expand_path(ENV['MIKUTTER_CONFROOT'] || '~/.mikutter'), 'plugin/*/Gemfile')){ |path|
    eval File.open(path).read
  }
end
