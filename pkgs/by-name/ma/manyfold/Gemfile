source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: ".ruby-version"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 8.0.0"
# Use Puma as the app server
gem "puma", "~> 7.1"
# Deliver assets with Propshaft
gem "propshaft", "~> 1.3"
# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"
gem "cssbundling-rails", "~> 1.4"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.14"
# Use Redis adapter to run Action Cable in production
gem "redis", "~> 5.4"
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

gem "dotenv-rails", "~> 3.1", group: :development
gem "acts-as-taggable-on", "~> 13.0"

gem "ffi-libarchive", "~> 1.1"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", "~> 1.18", require: false

# Database adapters
gem "activerecord-enhancedsqlite3-adapter", "~> 0.8"
group :production do
  gem "mysql2", "~> 0.5"
  gem "pg", "~> 1.6"
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails"
  gem "standard", "~> 1.51"
  gem "factory_bot"
  gem "faker", "~> 3.5"
  gem "guard", "~> 2.19"
  gem "guard-rspec", "~> 4.7"
  gem "database_cleaner-active_record", "~> 2.2"
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-rspec_rails", require: false
  gem "rubocop-factory_bot", require: false
  gem "rubocop-capybara", require: false
  gem "rubocop-i18n", require: false
  gem "rubocop-performance", "~> 1.23", require: false
  gem "rubocop-pundit", github: "manyfold3d/rubocop-pundit", require: false
  gem "rubyzip", "~> 2.4"
  gem "i18n-tasks", "~> 1.0"
  gem "simplecov", "~> 0.22", require: false
  gem "simplecov-cobertura", require: false
  gem "with_model", "~> 2.2"
  gem "vcr", "~> 6.3"

  # system tests and custom screenshots
  gem "capybara"
  gem "capybara-screenshot", github: "el-cms/capybara-screenshot", branch: "custom-prefixes"
  gem "selenium-webdriver"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", "~> 4.1"
  gem "scout_apm"
  gem "listen", "~> 3.9"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem "cocooned", "~> 2.5"

gem "public_suffix", "~> 6.0"

gem "activerecord-nulldb-adapter", "~> 1.1"

gem "memoist", "~> 0.16"
gem "stopwords-filter2", require: "stopwords"

gem "devise", "~> 4.9"

gem "data_migrate", "~> 11.3"

gem "rails-settings-cached", "~> 2.9"

gem "kaminari", "~> 1.2"

gem "lograge", "~> 0.14"

gem "acts_as_favoritor", "~> 6.0"

gem "sqlite3_ar_regexp", "~> 3.0"

gem "mittsu", "~> 0.5"
gem "mittsu-mesh_analysis"
gem "mittsu-3mf"

gem "rails-controller-testing", "~> 1.0", group: :test

gem "pundit", "~> 2.5"

gem "spdx", "~> 4.1"
gem "rack-contrib", "~> 2.5"

gem "rails-i18n", "~> 8.0"

gem "erb_lint", "~> 0.9", group: :development, require: false

gem "i18n-js", "~> 4.2"

gem "translation", "~> 1.41", group: :development

gem "string-similarity", "~> 2.1"

gem "rolify", "~> 6.0"

gem "letter_opener", "~> 1.10", group: :development

gem "sidekiq", "~> 8.0"

# gem "sidekiq-failures", "~> 1.0"
gem "activejob-status", "~> 1.0"

gem "brakeman", "~> 7.1"

gem "i18n_data", "~> 1.1"
gem "bullet", "~> 8.1", group: :development

gem "logstash-event", "~> 1.2"

gem "climate_control", "~> 1.2", group: :test

gem "sys-filesystem", "~> 1.5"
gem "shrine", "~> 3.6"
gem "tus-server", "~> 2.3"
gem "shrine-tus", "~> 2.1"

gem "aws-sdk-s3", "< 1.204"

gem "better_content_security_policy", "~> 0.1"

gem "devise_zxcvbn", "~> 6.0"

gem "federails", git: "https://gitlab.com/experimentslabs/federails.git", branch: "main"
gem "federails-moderation", "~> 0.3"
gem "caber", github: "manyfold3d/caber"
gem "fasp_client", "~> 0.6"

gem "nanoid", "~> 2.0"

gem "kramdown", "~> 2.5"

gem "omniauth", "~> 2.1"
gem "omniauth-rails_csrf_protection", "~> 1.0"
gem "omniauth_openid_connect", "~> 0.8"

gem "sidekiq-cron", "~> 2.3"

group :development, :production do
  gem "sys-cpu", "~> 1.1"
  gem "get_process_mem", "~> 1.0"
  gem "rails_performance", "~> 1.6"
  gem "redis-namespace"
end

gem "pghero", "~> 3.7"
gem "pg_query", "~> 6.1"

gem "to_regexp", "~> 0.2"

gem "activejob-uniqueness", "~> 0.4", require: "active_job/uniqueness/sidekiq_patch"

gem "job-iteration", "~> 1.11"
gem "rswag", "~> 2.17"
gem "warning", "~> 1.5"

gem "rack-cors", "~> 3.0"

gem "doorkeeper", "~> 5.8"

gem "kramdown-parser-gfm", "~> 1.1"

gem "doorkeeper-i18n", "~> 5.2"

gem "phlex-rails", "~> 2.3"

gem "turbo-rails", "~> 2.0.20"

gem "stimulus-rails", "~> 1.3.4"

gem "scoped_search", "~> 4.3"

gem "altcha-rails", "~> 0.0.6"

gem "reverse_markdown", "~> 3.0"

gem "graphlient", "~> 0.8.0"

gem "webmock", "~> 3.26", group: :test

gem "image_processing"

gem "csv", "~> 3.3"

gem "arel_extensions", "~> 2.3"

gem "assimp-ffi", git: "https://github.com/Kerilk/assimp-ruby.git"
