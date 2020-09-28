source 'https://rubygems.org'

gem 'rails', '~> 6.0.3.1'

gem 'bootsnap', '~> 1.4.6'

# Improves copy-on-write performance for MRI
gem 'nakayoshi_fork', '~> 0.0.4'

# Responders respond_to and respond_with
gem 'responders', '~> 3.0'

gem 'sprockets', '~> 3.7.0'

# Default values for AR models
gem 'default_value_for', '~> 3.3.0'

# Supported DBs
gem 'pg', '~> 1.1'

gem 'rugged', '~> 0.28'
gem 'grape-path-helpers', '~> 1.3'

gem 'faraday', '~> 1.0'
gem 'marginalia', '~> 1.9.0'

# Authentication libraries
gem 'devise', '~> 4.6'
gem 'doorkeeper', '~> 5.3.0'
gem 'doorkeeper-openid_connect', '~> 1.7.4'
gem 'omniauth', '~> 1.8'
gem 'omniauth-auth0', '~> 2.0.0'
gem 'omniauth-azure-oauth2', '~> 0.0.9'
gem 'omniauth-cas3', '~> 1.1.4'
gem 'omniauth-facebook', '~> 4.0.0'
gem 'omniauth-github', '~> 1.4'
gem 'omniauth-gitlab', '~> 1.0.2'
gem 'omniauth-google-oauth2', '~> 0.6.0'
gem 'omniauth-kerberos', '~> 0.3.0', group: :kerberos
gem 'omniauth-oauth2-generic', '~> 0.2.2'
gem 'omniauth-saml', '~> 1.10'
gem 'omniauth-shibboleth', '~> 1.3.0'
gem 'omniauth-twitter', '~> 1.4'
gem 'omniauth_crowd', '~> 2.4.0'
gem 'omniauth-authentiq', '~> 0.3.3'
gem 'omniauth_openid_connect', '~> 0.3.5'
gem 'omniauth-salesforce', '~> 1.0.5'
gem 'omniauth-atlassian-oauth2', '~> 0.2.0'
gem 'rack-oauth2', '~> 1.9.3'
gem 'jwt', '~> 2.1.0'

# Kerberos authentication. EE-only
gem 'gssapi', group: :kerberos

# Spam and anti-bot protection
gem 'recaptcha', '~> 4.11', require: 'recaptcha/rails'
gem 'akismet', '~> 3.0'
gem 'invisible_captcha', '~> 0.12.1'

# Two-factor authentication
gem 'devise-two-factor', '~> 3.1.0'
gem 'rqrcode-rails3', '~> 0.1.7'
gem 'attr_encrypted', '~> 3.1.0'
gem 'u2f', '~> 0.2.1'

# GitLab Pages
gem 'validates_hostname', '~> 1.0.10'
gem 'rubyzip', '~> 2.0.0', require: 'zip'
# GitLab Pages letsencrypt support
gem 'acme-client', '~> 2.0', '>= 2.0.6'

# Browser detection
gem 'browser', '~> 4.2'

# GPG
gem 'gpgme', '~> 2.0.19'

# LDAP Auth
# GitLab fork with several improvements to original library. For full list of changes
# see https://github.com/intridea/omniauth-ldap/compare/master...gitlabhq:master
gem 'gitlab_omniauth-ldap', '~> 2.1.1', require: 'omniauth-ldap'
gem 'net-ldap'

# API
# Locked at Grape v1.4.0 until https://github.com/ruby-grape/grape/pull/2088 is merged
# Remove config/initializers/grape_patch.rb
gem 'grape', '= 1.4.0'
gem 'grape-entity', '~> 0.7.1'
gem 'rack-cors', '~> 1.0.6', require: 'rack/cors'

# GraphQL API
gem 'graphql', '~> 1.11.4'
# NOTE: graphiql-rails v1.5+ doesn't work: https://gitlab.com/gitlab-org/gitlab/issues/31771
# TODO: remove app/views/graphiql/rails/editors/show.html.erb when https://github.com/rmosolgo/graphiql-rails/pull/71 is released:
# https://gitlab.com/gitlab-org/gitlab/issues/31747
gem 'graphiql-rails', '~> 1.4.10'
gem 'apollo_upload_server', '~> 2.0.2'
gem 'graphql-docs', '~> 1.6.0', group: [:development, :test]

# Disable strong_params so that Mash does not respond to :permitted?
gem 'hashie-forbidden_attributes'

# Pagination
gem 'kaminari', '~> 1.0'

# HAML
gem 'hamlit', '~> 2.11.0'

# Files attachments
gem 'carrierwave', '~> 1.3'
gem 'mini_magick'

# for backups
gem 'fog-aws', '~> 3.5'
# Locked until fog-google resolves https://github.com/fog/fog-google/issues/421.
# Also see config/initializers/fog_core_patch.rb.
gem 'fog-core', '= 2.1.0'
gem 'fog-google', '~> 1.10'
gem 'fog-local', '~> 0.6'
gem 'fog-openstack', '~> 1.0'
gem 'fog-rackspace', '~> 0.1.1'
gem 'fog-aliyun', '~> 0.3'
gem 'gitlab-fog-azure-rm', '~> 1.0', require: false

# for Google storage
gem 'google-api-client', '~> 0.33'

# for aws storage
gem 'unf', '~> 0.1.4'

# Seed data
gem 'seed-fu', '~> 2.3.7'

# Search
gem 'elasticsearch-model', '~> 6.1'
gem 'elasticsearch-rails', '~> 6.1', require: 'elasticsearch/rails/instrumentation'
gem 'elasticsearch-api',   '~> 6.8.2'
gem 'aws-sdk-core', '~> 3'
gem 'aws-sdk-cloudformation', '~> 1'
gem 'aws-sdk-s3', '~> 1'
gem 'faraday_middleware-aws-sigv4', '~>0.3.0'

# Markdown and HTML processing
gem 'html-pipeline', '~> 2.12'
gem 'deckar01-task_list', '2.3.1'
gem 'gitlab-markup', '~> 1.7.1'
gem 'github-markup', '~> 1.7.0', require: 'github/markup'
gem 'commonmarker', '~> 0.20'
gem 'kramdown', '~> 2.3.0'
gem 'RedCloth', '~> 4.3.2'
gem 'rdoc', '~> 6.1.2'
gem 'org-ruby', '~> 0.9.12'
gem 'creole', '~> 0.5.0'
gem 'wikicloth', '0.8.1'
gem 'asciidoctor', '~> 2.0.10'
gem 'asciidoctor-include-ext', '~> 0.3.1', require: false
gem 'asciidoctor-plantuml', '~> 0.0.12'
gem 'rouge', '~> 3.21.0'
gem 'truncato', '~> 0.7.11'
gem 'bootstrap_form', '~> 4.2.0'
gem 'nokogiri', '~> 1.10.9'
gem 'escape_utils', '~> 1.1'

# Calendar rendering
gem 'icalendar'

# Diffs
gem 'diffy', '~> 3.3'
gem 'diff_match_patch', '~> 0.1.0'

# Application server
gem 'rack', '~> 2.0.9'
# https://github.com/sharpstone/rack-timeout/blob/master/README.md#rails-apps-manually
gem 'rack-timeout', '~> 0.5.1', require: 'rack/timeout/base'

group :unicorn do
  gem 'unicorn', '~> 5.5'
  gem 'unicorn-worker-killer', '~> 0.4.4'
end

group :puma do
  gem 'gitlab-puma', '~> 4.3.3.gitlab.2', require: false
  gem 'gitlab-puma_worker_killer', '~> 0.1.1.gitlab.1', require: false
end

# State machine
gem 'state_machines-activerecord', '~> 0.6.0'

# Issue tags
gem 'acts-as-taggable-on', '~> 6.0'

# Background jobs
gem 'sidekiq', '~> 5.2.7'
gem 'sidekiq-cron', '~> 1.0'
gem 'redis-namespace', '~> 1.7.0'
gem 'gitlab-sidekiq-fetcher', '0.5.2', require: 'sidekiq-reliable-fetch'

# Cron Parser
gem 'fugit', '~> 1.2.1'

# HTTP requests
gem 'httparty', '~> 0.16.4'

# Colored output to console
gem 'rainbow', '~> 3.0'

# Progress bar
gem 'ruby-progressbar'

# GitLab settings
gem 'settingslogic', '~> 2.0.9'

# Linear-time regex library for untrusted regular expressions
gem 're2', '~> 1.2.0'

# Misc

gem 'version_sorter', '~> 2.2.4'

# Export Ruby Regex to Javascript
gem 'js_regex', '~> 3.4'

# User agent parsing
gem 'device_detector'

# Redis
gem 'redis', '~> 4.0'
gem 'connection_pool', '~> 2.0'

# Redis session store
gem 'redis-rails', '~> 5.0.2'

# Discord integration
gem 'discordrb-webhooks-blackst0ne', '~> 3.3', require: false

# HipChat integration
gem 'hipchat', '~> 1.5.0'

# Jira integration
gem 'jira-ruby', '~> 2.0.0'
gem 'atlassian-jwt', '~> 0.2.0'

# Flowdock integration
gem 'flowdock', '~> 0.7'

# Slack integration
gem 'slack-messenger', '~> 2.3.3'

# Hangouts Chat integration
gem 'hangouts-chat', '~> 0.0.5'

# Asana integration
gem 'asana', '0.10.2'

# FogBugz integration
gem 'ruby-fogbugz', '~> 0.2.1'

# Kubernetes integration
gem 'kubeclient', '~> 4.6.0'

# Sanitize user input
gem 'sanitize', '~> 5.2.1'
gem 'babosa', '~> 1.0.2'

# Sanitizes SVG input
gem 'loofah', '~> 2.2'

# Working with license
gem 'licensee', '~> 8.9'

# Ace editor
gem 'ace-rails-ap', '~> 4.1.0'

# Detect and convert string character encoding
gem 'charlock_holmes', '~> 0.7.5'

# Detect mime content type from content
gem 'mimemagic', '~> 0.3.2'

# Faster blank
gem 'fast_blank'

# Parse time & duration
gem 'gitlab-chronic', '~> 0.10.5'
gem 'gitlab_chronic_duration', '~> 0.10.6.2'

gem 'webpack-rails', '~> 0.9.10'
gem 'rack-proxy', '~> 0.6.0'

gem 'sassc-rails', '~> 2.1.0'
gem 'uglifier', '~> 2.7.2'

gem 'addressable', '~> 2.7'
gem 'font-awesome-rails', '~> 4.7'
gem 'gemojione', '~> 3.3'
gem 'gon', '~> 6.2'
gem 'request_store', '~> 1.5'
gem 'base32', '~> 0.3.0'

gem "gitlab-license", "~> 1.0"

# Protect against bruteforcing
gem 'rack-attack', '~> 6.3.0'

# Sentry integration
gem 'sentry-raven', '~> 3.0'

gem 'premailer-rails', '~> 1.10.3'

# LabKit: Tracing and Correlation
gem 'gitlab-labkit', '0.12.1'

# I18n
gem 'ruby_parser', '~> 3.8', require: false
gem 'rails-i18n', '~> 6.0'
gem 'gettext_i18n_rails', '~> 1.8.0'
gem 'gettext_i18n_rails_js', '~> 1.3'
gem 'gettext', '~> 3.3', require: false, group: :development

gem 'batch-loader', '~> 1.4.0'

# Perf bar
gem 'peek', '~> 1.1'

# Snowplow events tracking
gem 'snowplow-tracker', '~> 0.6.1'

# Metrics
group :metrics do
  gem 'method_source', '~> 1.0', require: false

  # Prometheus
  gem 'prometheus-client-mmap', '~> 0.11.0'
  gem 'raindrops', '~> 0.18'
end

group :development do
  gem 'brakeman', '~> 4.2', require: false
  gem 'danger', '~> 8.0', require: false

  gem 'letter_opener_web', '~> 1.3.4'

  # Better errors handler
  gem 'better_errors', '~> 2.7.1'

  # thin instead webrick
  gem 'thin', '~> 1.7.0'
end

group :development, :test do
  gem 'bullet', '~> 6.1.0'
  gem 'pry-byebug', '~> 3.9.0', platform: :mri
  gem 'pry-rails', '~> 0.3.9'

  gem 'awesome_print', require: false

  gem 'database_cleaner', '~> 1.7.0'
  gem 'factory_bot_rails', '~> 5.1.0'
  gem 'rspec-rails', '~> 4.0.0'

  # Prevent occasions where minitest is not bundled in packaged versions of ruby (see #3826)
  gem 'minitest', '~> 5.11.0'

  # Generate Fake data
  gem 'ffaker', '~> 2.10'

  gem 'spring', '~> 2.0.0'
  gem 'spring-commands-rspec', '~> 1.0.4'

  gem 'gitlab-styles', '~> 4.3.0', require: false
  # Pin these dependencies, otherwise a new rule could break the CI pipelines
  gem 'rubocop', '~> 0.82.0'
  gem 'rubocop-performance', '~> 1.5.2'
  gem 'rubocop-rspec', '~> 1.37.0'

  gem 'scss_lint', '~> 0.56.0', require: false
  gem 'haml_lint', '~> 0.34.0', require: false
  gem 'simplecov', '~> 0.18.5', require: false
  gem 'simplecov-cobertura', '~> 1.3.1', require: false
  gem 'bundler-audit', '~> 0.6.1', require: false

  gem 'benchmark-ips', '~> 2.3.0', require: false

  gem 'knapsack', '~> 1.17'

  gem 'simple_po_parser', '~> 1.1.2', require: false

  gem 'timecop', '~> 0.9.1'

  gem 'png_quantizator', '~> 0.2.1', require: false

  gem 'parallel', '~> 1.19', require: false

  gem 'rblineprof', '~> 0.3.6', platform: :mri, require: false
end

# Gems required in omnibus-gitlab pipeline
group :development, :test, :omnibus do
  gem 'license_finder', '~> 5.4', require: false
end

group :test do
  gem 'fuubar', '~> 2.2.0'
  gem 'rspec-retry', '~> 0.6.1'
  gem 'rspec_profiling', '~> 0.0.5'
  gem 'rspec-parameterized', require: false

  gem 'capybara', '~> 3.33.0'
  gem 'capybara-screenshot', '~> 1.0.22'
  gem 'selenium-webdriver', '~> 3.142'

  gem 'shoulda-matchers', '~> 4.0.1', require: false
  gem 'email_spec', '~> 2.2.0'
  gem 'webmock', '~> 3.5.1'
  gem 'rails-controller-testing'
  gem 'concurrent-ruby', '~> 1.1'
  gem 'test-prof', '~> 0.12.0'
  gem 'rspec_junit_formatter'
  gem 'guard-rspec'

  # Moved in `test` because https://gitlab.com/gitlab-org/gitlab/-/issues/217527
  gem 'derailed_benchmarks', require: false
end

gem 'octokit', '~> 4.15'

# https://gitlab.com/gitlab-org/gitlab/issues/207207
gem 'gitlab-mail_room', '~> 0.0.6', require: 'mail_room'

gem 'email_reply_trimmer', '~> 0.1'
gem 'html2text'

gem 'ruby-prof', '~> 1.3.0'
gem 'stackprof', '~> 0.2.15', require: false
gem 'rbtrace', '~> 0.4', require: false
gem 'memory_profiler', '~> 0.9', require: false
gem 'benchmark-memory', '~> 0.1', require: false
gem 'activerecord-explain-analyze', '~> 0.1', require: false

# OAuth
gem 'oauth2', '~> 1.4'

# Health check
gem 'health_check', '~> 3.0'

# System information
gem 'vmstat', '~> 2.3.0'
gem 'sys-filesystem', '~> 1.1.6'

# NTP client
gem 'net-ntp'

# SSH host key support
gem 'net-ssh', '~> 6.0'
gem 'sshkey', '~> 2.0'

# Required for ED25519 SSH host key support
group :ed25519 do
  gem 'ed25519', '~> 1.2'
  gem 'bcrypt_pbkdf', '~> 1.0'
end

# Gitaly GRPC protocol definitions
gem 'gitaly', '~> 13.3.0-rc1'

gem 'grpc', '~> 1.30.2'

gem 'google-protobuf', '~> 3.12'

gem 'toml-rb', '~> 1.0.0'

# Feature toggles
gem 'flipper', '~> 0.17.1'
gem 'flipper-active_record', '~> 0.17.1'
gem 'flipper-active_support_cache_store', '~> 0.17.1'
gem 'unleash', '~> 0.1.5'

# Structured logging
gem 'lograge', '~> 0.5'
gem 'grape_logging', '~> 1.7'

# DNS Lookup
gem 'gitlab-net-dns', '~> 0.9.1'

# Countries list
gem 'countries', '~> 3.0'

gem 'retriable', '~> 3.1.2'

# LRU cache
gem 'lru_redux'

gem 'erubi', '~> 1.9.0'

# Locked as long as quoted-printable encoding issues are not resolved
# Monkey-patched in `config/initializers/mail_encoding_patch.rb`
# See https://gitlab.com/gitlab-org/gitlab/issues/197386
gem 'mail', '= 2.7.1'

# File encryption
gem 'lockbox', '~> 0.3.3'

# Email validation
gem 'valid_email', '~> 0.1'

# JSON
gem 'json', '~> 2.3.0'
gem 'json-schema', '~> 2.8.0'
gem 'json_schemer', '~> 0.2.12'
gem 'oj', '~> 3.10.6'
gem 'multi_json', '~> 1.14.1'
gem 'yajl-ruby', '~> 1.4.1', require: 'yajl'

gem 'webauthn', '~> 2.3'
