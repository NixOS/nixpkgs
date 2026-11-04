source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: ".ruby-version"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "8.1.4"
# Use Puma as the app server
gem "puma", "~> 8.0"
# Bundle and deliver assets
gem "vite_rails", "~> 3.11"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.15"
# Use Redis adapter to run Action Cable in production
gem "redis", "~> 5.4"
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

gem "dotenv-rails", "~> 3.2", group: :development
gem "acts-as-taggable-on", "~> 13.0"

gem "ffi-libarchive", "~> 1.1"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", "~> 1.26", require: false

# Database adapters
# All are installed by default, but you can exclude ones you don't want with bundler.
# e.g. `bundle install --without="postgres mysql"` or `bundle config set without "postgres mysql"`
group :sqlite3 do
  gem "sqlite3", "~> 2.9"
  gem "sqlite3_ar_regexp", "~> 3.0"
end
group :mysql do
  gem "mysql2", "~> 0.5"
end
group :postgres do
  gem "pg", "~> 1.7"
  gem "pghero", "~> 4.0"
  gem "pg_query", "~> 6.2"
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :windows]
  gem "rspec-rails"
  gem "standard", "~> 1.57"
  gem "factory_bot"
  gem "faker", "~> 3.8"
  gem "guard", "~> 2.20"
  gem "guard-rspec", "~> 4.7"
  gem "database_cleaner-active_record", "~> 2.2"
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-rspec_rails", require: false
  gem "rubocop-factory_bot", require: false
  gem "rubocop-capybara", require: false
  gem "rubocop-i18n", require: false
  gem "rubocop-performance", "~> 1.26", require: false
  gem "rubocop-pundit", github: "manyfold3d/rubocop-pundit", require: false
  gem "rubyzip", "~> 2.4"
  gem "i18n-tasks", "~> 1.1"
  gem "simplecov", "~> 1.3", require: false
  gem "simplecov-cobertura", require: false
  gem "with_model", "~> 2.5"
  gem "vcr", "~> 6.4"

  # system tests and custom screenshots
  gem "capybara"
  gem "capybara-screenshot", github: "el-cms/capybara-screenshot", branch: "custom-prefixes"
  gem "selenium-webdriver"

  # Documentation
  gem "yard-activerecord", "~> 0.0.17"
  gem "yard-activesupport-concern", "~> 0.0.1"
  gem "yard-lint", "~> 1.12"
  gem "rubocop-yard", "~> 1.3"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", "~> 4.3"
  gem "scout_apm"
  gem "listen", "~> 3.10"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:windows, :jruby]

gem "cocooned", "~> 3.0"

gem "public_suffix", "~> 7.0"

gem "activerecord-nulldb-adapter", "~> 1.2"

gem "memo_wise", "~> 1.13"
gem "stopwords-filter2", require: "stopwords"

gem "devise", "~> 5.0"

gem "data_migrate", "~> 11.3"

gem "rails-settings-cached", "~> 2.10"

gem "pagy", "~> 43.8"

gem "lograge", "~> 0.15"

gem "acts_as_favoritor", "~> 6.0"

gem "mittsu", "~> 0.5"
gem "mittsu-mesh_analysis"
gem "mittsu-3mf"

gem "rails-controller-testing", "~> 1.0", group: :test

gem "pundit", "~> 2.5"

gem "spdx", "~> 4.1"
gem "rack-contrib", "~> 2.5"

gem "rails-i18n", "~> 8.0.0"

gem "erb_lint", "~> 0.9", group: :development, require: false

gem "i18n-js", "~> 4.2"

gem "translation", "~> 1.41", group: :development

gem "string-similarity", "~> 2.1"

gem "rolify", "~> 6.0"

gem "letter_opener", "~> 1.10", group: :development

gem "sidekiq", "~> 8.1"
gem "gitlab-sidekiq-fetcher", require: "sidekiq-reliable-fetch", git: "https://github.com/DocSpring/sidekiq-reliable-fetch.git"

# gem "sidekiq-failures", "~> 1.0"
gem "activejob-status", "~> 1.0"

gem "brakeman", "~> 8.1"

gem "i18n_data", "~> 1.1"
gem "bullet", "~> 8.3", group: :development

gem "logstash-event", "~> 1.2"

gem "climate_control", "~> 1.2", group: :test

gem "sys-filesystem", "~> 1.6"
gem "shrine", "~> 3.10"
gem "tus-server", "~> 2.3"
gem "shrine-tus", "~> 3.0"

gem "aws-sdk-s3", "< 1.234"

gem "better_content_security_policy", "~> 0.1"

gem "devise_zxcvbn", "~> 6.0"

gem "fedipub", "~> 0.10"
gem "fedipub-moderation", "~> 0.5"
gem "caber", github: "manyfold3d/caber"
gem "fasp_client", "~> 0.6"

gem "nanoid", "~> 2.0"

gem "kramdown", "~> 2.5"

gem "omniauth", "~> 2.1"
gem "omniauth_openid_connect", "~> 0.8"

gem "sidekiq-cron", "~> 2.4"

group :development, :production do
  gem "sys-cpu", "~> 1.3"
  gem "get_process_mem", "~> 1.0"
  gem "rails_performance", "~> 1.6"
  gem "redis-namespace"
end

gem "to_regexp", "~> 0.2"

gem "activejob-unique", "~> 0.5"

gem "job-iteration", "~> 1.15"
gem "rswag", "~> 2.17"
gem "warning", "~> 1.6"

gem "rack-cors", "~> 3.0"

gem "doorkeeper", "~> 5.9"

gem "kramdown-parser-gfm", "~> 1.1"

gem "doorkeeper-i18n", "~> 5.2"

gem "phlex-rails", "~> 2.4"

gem "turbo-rails", "~> 2.0.23"

gem "stimulus-rails", "~> 1.3.4"

gem "scoped_search", "~> 5.0"

gem "altcha-rails", "~> 0.1.0"

gem "reverse_markdown", "~> 3.0"

gem "graphlient", "~> 0.9.0"

gem "webmock", "~> 3.34", group: :test

gem "image_processing"
gem "mini_magick"

gem "csv", "~> 3.3"

gem "arel_extensions", "~> 2.5"

gem "assimp-ffi", git: "https://github.com/Kerilk/assimp-ruby.git"

gem "zaru", "~> 1.1"

# v3 causes us problems
gem "connection_pool", ">= 2.2.5", "< 4.0"

gem "noticed", "~> 3.1"

gem "devise_invitable", "~> 2.0"

gem "user_agent_parser", "~> 2.21"

gem "marcel", "~> 1.2"

gem "naturally", "~> 2.3"

gem "rouge", "~> 5.1"

gem "faraday-multipart", "~> 1.2"
