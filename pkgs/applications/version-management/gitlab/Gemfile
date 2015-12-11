source "https://rubygems.org"

def darwin_only(require_as)
  RUBY_PLATFORM.include?('darwin') && require_as
end

def linux_only(require_as)
  RUBY_PLATFORM.include?('linux') && require_as
end

gem 'rails', '4.1.12'

# Specify a sprockets version due to security issue
# See https://groups.google.com/forum/#!topic/rubyonrails-security/doAVp0YaTqY
gem 'sprockets', '~> 2.12.3'

# Default values for AR models
gem "default_value_for", "~> 3.0.0"

# Supported DBs
gem "mysql2", '~> 0.3.16', group: :mysql
gem "pg", '~> 0.18.2', group: :postgres

# Authentication libraries
gem "devise", '~> 3.5.2'
gem "devise-async", '~> 0.9.0'
gem 'omniauth', "~> 1.2.2"
gem 'omniauth-google-oauth2', '~> 0.2.5'
gem 'omniauth-twitter', '~> 1.0.1'
gem 'omniauth-github', '~> 1.1.1'
gem 'omniauth-shibboleth', '~> 1.1.1'
gem 'omniauth-kerberos', '~> 0.2.0', group: :kerberos
gem 'omniauth-gitlab', '~> 1.0.0'
gem 'omniauth-bitbucket', '~> 0.0.2'
gem 'omniauth-saml', '~> 1.4.0'
gem 'doorkeeper', '~> 2.1.3'
gem 'omniauth_crowd'
gem "rack-oauth2", "~> 1.0.5"

# Two-factor authentication
gem 'devise-two-factor', '~> 2.0.0'
gem 'rqrcode-rails3', '~> 0.1.7'
gem 'attr_encrypted', '~> 1.3.4'

# Browser detection
gem "browser", '~> 1.0.0'

# Extracting information from a git repository
# Provide access to Gitlab::Git library
gem "gitlab_git", '~> 7.2.15'

# LDAP Auth
# GitLab fork with several improvements to original library. For full list of changes
# see https://github.com/intridea/omniauth-ldap/compare/master...gitlabhq:master
gem 'gitlab_omniauth-ldap', '~> 1.2.1', require: "omniauth-ldap"

# Git Wiki
gem 'gollum-lib', '~> 4.0.2'

# Language detection
# GitLab fork of linguist does not require pygments/python dependency.
# New version of original gem also dropped pygments support but it has strict
# dependency to unstable rugged version. We have internal issue for replacing
# fork with original gem when we meet on same rugged version - https://dev.gitlab.org/gitlab/gitlabhq/issues/2052.
gem "gitlab-linguist", "~> 3.0.1", require: "linguist"

# API
gem "grape", "~> 0.6.1"
gem "grape-entity", "~> 0.4.2"
gem 'rack-cors', '~> 0.2.9', require: 'rack/cors'

# Format dates and times
# based on human-friendly examples
gem "stamp", '~> 0.5.0'

# Enumeration fields
gem 'enumerize', '~> 0.7.0'

# Pagination
gem "kaminari", "~> 0.15.1"

# HAML
gem "haml-rails", '~> 0.5.3'

# Files attachments
gem "carrierwave", '~> 0.9.0'

# Drag and Drop UI
gem 'dropzonejs-rails', '~> 0.7.1'

# for aws storage
gem "fog", "~> 1.25.0"
gem "unf", '~> 0.1.4'

# Authorization
gem "six", '~> 0.2.0'

# Seed data
gem "seed-fu", '~> 2.3.5'

# Markdown and HTML processing
gem 'html-pipeline', '~> 1.11.0'
gem 'task_list',     '~> 1.0.2', require: 'task_list/railtie'
gem 'github-markup', '~> 1.3.1'
gem 'redcarpet',     '~> 3.3.2'
gem 'RedCloth',      '~> 4.2.9'
gem 'rdoc',          '~>3.6'
gem 'org-ruby',      '~> 0.9.12'
gem 'creole',        '~>0.3.6'
gem 'wikicloth',     '0.8.1'
gem 'asciidoctor',   '~> 1.5.2'

# Diffs
gem 'diffy', '~> 3.0.3'

# Application server
group :unicorn do
  gem "unicorn", '~> 4.8.2'
  gem 'unicorn-worker-killer', '~> 0.4.2'
end

# State machine
gem "state_machine", '~> 1.2.0'
# Run events after state machine commits
gem 'after_commit_queue'

# Issue tags
gem 'acts-as-taggable-on', '~> 3.4'

# Background jobs
gem 'slim', '~> 2.0.2'
gem 'sinatra', '~> 1.4.4', require: nil
gem 'sidekiq', '3.3.0'
gem 'sidetiq', '~> 0.6.3'

# HTTP requests
gem "httparty", '~> 0.13.3'

# Colored output to console
gem "colored", '~> 1.2'
gem "colorize", '~> 0.5.8'

# GitLab settings
gem 'settingslogic', '~> 2.0.9'

# Misc

gem 'version_sorter', '~> 2.0.0'

# Cache
gem "redis-rails", '~> 4.0.0'

# Campfire integration
gem 'tinder', '~> 1.9.2'

# HipChat integration
gem 'hipchat', '~> 1.5.0'

# Flowdock integration
gem "gitlab-flowdock-git-hook", "~> 1.0.1"

# Gemnasium integration
gem "gemnasium-gitlab-service", "~> 0.2"

# Slack integration
gem "slack-notifier", "~> 1.0.0"

# Asana integration
gem 'asana', '~> 0.0.6'

# FogBugz integration
gem 'ruby-fogbugz', '~> 0.2.1'

# d3
gem 'd3_rails', '~> 3.5.5'

#cal-heatmap
gem "cal-heatmap-rails", "~> 0.0.1"

# underscore-rails
gem "underscore-rails", "~> 1.4.4"

# Sanitize user input
gem "sanitize", '~> 2.0'

# Protect against bruteforcing
gem "rack-attack", '~> 4.3.0'

# Ace editor
gem 'ace-rails-ap', '~> 2.0.1'

# Keyboard shortcuts
gem 'mousetrap-rails', '~> 1.4.6'

# Detect and convert string character encoding
gem 'charlock_holmes', '~> 0.6.9.4'

gem "sass-rails", '~> 4.0.5'
gem "coffee-rails", '~> 4.1.0'
gem "uglifier", '~> 2.3.2'
gem 'turbolinks', '~> 2.5.0'
gem 'jquery-turbolinks', '~> 2.0.1'

gem 'addressable',        '~> 2.3.8'
gem 'bootstrap-sass',     '~> 3.0'
gem 'font-awesome-rails', '~> 4.2'
gem 'gitlab_emoji',       '~> 0.1'
gem 'gon',                '~> 5.0.0'
gem 'jquery-atwho-rails', '~> 1.0.0'
gem 'jquery-rails',       '~> 3.1.3'
gem 'jquery-scrollto-rails', '~> 1.4.3'
gem 'jquery-ui-rails',    '~> 4.2.1'
gem 'nprogress-rails',    '~> 0.1.2.3'
gem 'raphael-rails',      '~> 2.1.2'
gem 'request_store',      '~> 1.2.0'
gem 'select2-rails',      '~> 3.5.9'
gem 'virtus',             '~> 1.0.1'

group :development do
  gem "foreman"
  gem 'brakeman', '3.0.1', require: false

  gem "annotate", "~> 2.6.0"
  gem "letter_opener", '~> 1.1.2'
  gem 'quiet_assets', '~> 1.0.2'
  gem 'rack-mini-profiler', '~> 0.9.0', require: false
  gem 'rerun', '~> 0.10.0'

  # Better errors handler
  gem 'better_errors', '~> 1.0.1'
  gem 'binding_of_caller', '~> 0.7.2'

  # Docs generator
  gem "sdoc", '~> 0.3.20'

  # thin instead webrick
  gem 'thin', '~> 1.6.1'
end

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'pry-rails'

  gem 'awesome_print', '~> 1.2.0'
  gem 'fuubar', '~> 2.0.0'

  gem 'database_cleaner', '~> 1.4.0'
  gem 'factory_girl_rails', '~> 4.3.0'
  gem 'rspec-rails',      '~> 3.3.0'
  gem 'spinach-rails', '~> 0.2.1'

  # Prevent occasions where minitest is not bundled in packaged versions of ruby (see #3826)
  gem 'minitest', '~> 5.7.0'

  # Generate Fake data
  gem 'ffaker', '~> 2.0.0'

  gem 'capybara',            '~> 2.4.0'
  gem 'capybara-screenshot', '~> 1.0.0'
  gem 'poltergeist',         '~> 1.6.0'

  gem 'teaspoon', '~> 1.0.0'
  gem 'teaspoon-jasmine', '~> 2.2.0'

  gem 'spring', '~> 1.3.6'
  gem 'spring-commands-rspec',    '~> 1.0.4'
  gem 'spring-commands-spinach',  '~> 1.0.0'
  gem 'spring-commands-teaspoon', '~> 0.0.2'

  gem 'rubocop',  '~> 0.28.0',  require: false
  gem 'coveralls',  '~> 0.8.2', require: false
  gem 'simplecov', '~> 0.10.0', require: false
end

group :test do
  gem 'shoulda-matchers', '~> 2.8.0', require: false
  gem 'email_spec', '~> 1.6.0'
  gem 'webmock', '~> 1.21.0'
  gem 'test_after_commit', '~> 0.2.2'
  gem 'sham_rack'
end

group :production do
  gem "gitlab_meta", '7.0'
end

gem "newrelic_rpm", '~> 3.9.4.245'
gem 'newrelic-grape'

gem 'octokit', '~> 3.7.0'

gem "mail_room", "~> 0.5.2"

gem 'email_reply_parser', '~> 0.5.8'

## CI
gem 'activerecord-deprecated_finders', '~> 1.0.3'
gem 'activerecord-session_store', '~> 0.1.0'
gem "nested_form", '~> 0.3.2'

# Scheduled
gem 'whenever', '~> 0.8.4', require: false

# OAuth
gem 'oauth2', '~> 1.0.0'

# Soft deletion
gem "paranoia", "~> 2.0"

group :development, :test do
  gem 'guard-rspec', '~> 4.2.0'

  gem 'rb-fsevent', require: darwin_only('rb-fsevent')
  gem 'growl',      require: darwin_only('growl')
  gem 'rb-inotify', require: linux_only('rb-inotify')
end
