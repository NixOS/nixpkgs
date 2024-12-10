# frozen_string_literal: true

def next?
  File.basename(__FILE__) == "Gemfile.next"
end

source 'https://rubygems.org'

if ENV.fetch('BUNDLER_CHECKSUM_VERIFICATION_OPT_IN', 'false') != 'false' # this verification is still experimental
  $LOAD_PATH.unshift(File.expand_path("vendor/gems/bundler-checksum/lib", __dir__))
  require 'bundler-checksum'
  BundlerChecksum.patch!
end

# Please see https://docs.gitlab.com/ee/development/feature_categorization/#gemfile
ignore_feature_category = Module.new do
  def gem(*arguments, feature_category: nil, **keyword_arguments) # rubocop:disable Lint/UnusedMethodArgument
    super(*arguments, **keyword_arguments)
  end
end

extend ignore_feature_category

gem 'bundler-checksum', '~> 0.1.0', path: 'vendor/gems/bundler-checksum', require: false # rubocop:todo Gemfile/MissingFeatureCategory

# NOTE: When incrementing the major or minor version here, also increment activerecord_version
# in vendor/gems/attr_encrypted/attr_encrypted.gemspec until we resolve
# https://gitlab.com/gitlab-org/gitlab/-/issues/375713
#
# See https://docs.gitlab.com/ee/development/gemfile.html#upgrade-rails for guidelines when upgrading Rails

if next?
  gem 'rails', '~> 7.1.4', feature_category: :shared
else
  gem 'rails', '~> 7.0.8.4', feature_category: :shared
end

gem 'activerecord-gitlab', path: 'gems/activerecord-gitlab' # rubocop:todo Gemfile/MissingFeatureCategory

gem 'bootsnap', '~> 1.18.3', require: false # rubocop:todo Gemfile/MissingFeatureCategory

# Avoid the precompiled native gems because Omnibus needs to build this to ensure
# LD_LIBRARY_PATH is correct: https://gitlab.com/gitlab-org/omnibus-gitlab/-/merge_requests/7730
gem 'ffi', '~> 1.17', force_ruby_platform: true, feature_category: :shared

gem 'openssl', '~> 3.0' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'ipaddr', '~> 1.2.5' # rubocop:todo Gemfile/MissingFeatureCategory

gem 'gitlab-safe_request_store', path: 'gems/gitlab-safe_request_store' # rubocop:todo Gemfile/MissingFeatureCategory

# GitLab Monorepo Gems
group :monorepo do
  gem 'gitlab-utils', path: 'gems/gitlab-utils' # rubocop:todo Gemfile/MissingFeatureCategory
end

gem 'gitlab-backup-cli', path: 'gems/gitlab-backup-cli', require: 'gitlab/backup/cli', feature_category: :backup_restore

gem 'gitlab-secret_detection', path: 'gems/gitlab-secret_detection', feature_category: :secret_detection

# Responders respond_to and respond_with
gem 'responders', '~> 3.0' # rubocop:todo Gemfile/MissingFeatureCategory

gem 'sprockets', '~> 3.7.0' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'sprockets-rails', '~>  3.5.1' # rubocop:todo Gemfile/MissingFeatureCategory

gem 'view_component', '~> 3.20.0' # rubocop:todo Gemfile/MissingFeatureCategory

# Supported DBs
gem 'pg', '~> 1.5.6', feature_category: :database

gem 'neighbor', '~> 0.3.2', feature_category: :duo_chat

gem 'rugged', '~> 1.6' # rubocop:todo Gemfile/MissingFeatureCategory

gem 'faraday', '~> 2', feature_category: :shared
gem 'faraday-retry', '~> 2', feature_category: :shared
# Logger is a dependency of Faraday, but Logger 1.6.0 does not work with Chef.
gem 'logger', '~> 1.5.3' # rubocop:todo Gemfile/MissingFeatureCategory

gem 'marginalia', '~> 1.11.1' # rubocop:todo Gemfile/MissingFeatureCategory

# Authorization
gem 'declarative_policy', '~> 1.1.0' # rubocop:todo Gemfile/MissingFeatureCategory

# For source code paths mapping
gem 'coverband', '6.1.4', require: false, feature_category: :shared

# Authentication libraries
gem 'devise', '~> 4.9.3', feature_category: :system_access
gem 'devise-pbkdf2-encryptable', '~> 0.0.0', path: 'vendor/gems/devise-pbkdf2-encryptable' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'bcrypt', '~> 3.1', '>= 3.1.14' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'doorkeeper', '~> 5.6', '>= 5.6.6' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'doorkeeper-openid_connect', '~> 1.8', '>= 1.8.7' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'doorkeeper-device_authorization_grant', '~> 1.0.0', feature_category: :system_access
gem 'rexml', '~> 3.3.2' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'ruby-saml', '~> 1.17.0', feature_category: :system_access
gem 'omniauth', '~> 2.1.0' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'omniauth-auth0', '~> 3.1' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'omniauth-azure-activedirectory-v2', '~> 2.0' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'omniauth-alicloud', '~> 3.0.0' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'omniauth-github', '2.0.1' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'omniauth-gitlab', '~> 4.0.0', path: 'vendor/gems/omniauth-gitlab' # See vendor/gems/omniauth-gitlab/README.md # rubocop:todo Gemfile/MissingFeatureCategory
gem 'omniauth-google-oauth2', '~> 1.1' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'omniauth-oauth2-generic', '~> 0.2.2' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'omniauth-saml', '~> 2.2.1', feature_category: :system_access
gem 'omniauth-shibboleth-redux', '~> 2.0', require: 'omniauth-shibboleth' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'omniauth_crowd', '~> 2.4.0', path: 'vendor/gems/omniauth_crowd' # See vendor/gems/omniauth_crowd/README.md # rubocop:todo Gemfile/MissingFeatureCategory
gem 'omniauth_openid_connect', '~> 0.8.0' # rubocop:todo Gemfile/MissingFeatureCategory
# Locked until Ruby 3.0 upgrade since upgrading will pull in an updated net-smtp gem.
# See https://docs.gitlab.com/ee/development/emails.html#rationale.
gem 'openid_connect', '~> 2.3.0' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'omniauth-salesforce', '~> 1.0.5', path: 'vendor/gems/omniauth-salesforce' # See gem README.md # rubocop:todo Gemfile/MissingFeatureCategory
gem 'omniauth-atlassian-oauth2', '~> 0.2.0' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'rack-oauth2', '~> 2.2.1' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'jwt', '~> 2.9.3' # rubocop:todo Gemfile/MissingFeatureCategory

# Kerberos authentication. EE-only
gem 'gssapi', '~> 1.3.1', group: :kerberos # rubocop:todo Gemfile/MissingFeatureCategory
gem 'timfel-krb5-auth', '~> 0.8', group: :kerberos # rubocop:todo Gemfile/MissingFeatureCategory

# Spam and anti-bot protection
gem 'recaptcha', '~> 5.12', require: 'recaptcha/rails' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'akismet', '~> 3.0' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'invisible_captcha', '~> 2.1.0' # rubocop:todo Gemfile/MissingFeatureCategory

# Two-factor authentication
gem 'devise-two-factor', '~> 4.1.1' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'rqrcode', '~> 2.2', feature_category: :system_access

gem 'attr_encrypted', '~> 3.2.4', path: 'vendor/gems/attr_encrypted' # rubocop:todo Gemfile/MissingFeatureCategory

# GitLab Pages
gem 'validates_hostname', '~> 1.0.13' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'rubyzip', '~> 2.3.2', require: 'zip' # rubocop:todo Gemfile/MissingFeatureCategory
# GitLab Pages letsencrypt support
gem 'acme-client', '~> 2.0.18' # rubocop:todo Gemfile/MissingFeatureCategory

# Browser detection
gem 'browser', '~> 5.3.1' # rubocop:todo Gemfile/MissingFeatureCategory

# OS detection for usage ping
gem 'ohai', '~> 18.1' # rubocop:todo Gemfile/MissingFeatureCategory

# GPG
gem 'gpgme', '~> 2.0.24', feature_category: :source_code_management

# LDAP Auth
# GitLab fork with several improvements to original library. For full list of changes
# see https://github.com/intridea/omniauth-ldap/compare/master...gitlabhq:master
gem 'gitlab_omniauth-ldap', '~> 2.2.0', require: 'omniauth-ldap' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'net-ldap', '~> 0.17.1' # rubocop:todo Gemfile/MissingFeatureCategory

# API
gem 'grape', '~> 2.0.0', feature_category: :api
gem 'grape-entity', '~> 1.0.1', feature_category: :api
gem 'grape-swagger', '~> 2.1.0', group: [:development, :test], feature_category: :api
gem 'grape-swagger-entity', '~> 0.5.1', group: [:development, :test], feature_category: :api
gem 'grape-path-helpers', '~> 2.0.1', feature_category: :api
gem 'rack-cors', '~> 2.0.1', require: 'rack/cors' # rubocop:todo Gemfile/MissingFeatureCategory

# GraphQL API
gem 'graphql', '~> 2.4.1', feature_category: :api
gem 'graphql-docs', '~> 5.0.0', group: [:development, :test], feature_category: :api
gem 'apollo_upload_server', '~> 2.1.6', feature_category: :api
gem 'graphlient', '~> 0.8.0', feature_category: :importers # Used by BulkImport feature (group::import)

# Cells
gem 'gitlab-topology-service-client', '~> 0.1',
  path: 'vendor/gems/gitlab-topology-service-client',
  feature_category: :cell

# Duo Workflow
gem 'gitlab-duo-workflow-service-client', '~> 0.1',
  path: 'vendor/gems/gitlab-duo-workflow-service-client',
  feature_category: :duo_workflow

# Generate Fake data
gem 'ffaker', '~> 2.23' # rubocop:todo Gemfile/MissingFeatureCategory

gem 'hashie', '~> 5.0.0' # rubocop:todo Gemfile/MissingFeatureCategory

# Pagination
gem 'kaminari', '~> 1.2.2' # rubocop:todo Gemfile/MissingFeatureCategory

# HAML
gem 'hamlit', '~> 2.15.0' # rubocop:todo Gemfile/MissingFeatureCategory

# Files attachments
gem 'carrierwave', '~> 1.3' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'mini_magick', '~> 4.12' # rubocop:todo Gemfile/MissingFeatureCategory

# for backups
gem 'fog-aws', '~> 3.26', feature_category: :shared
# Locked until fog-google resolves https://github.com/fog/fog-google/issues/421.
# Also see config/initializers/fog_core_patch.rb.
gem 'fog-core', '= 2.1.0' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'fog-google', '~> 1.24.1', require: 'fog/google' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'fog-local', '~> 0.8' # rubocop:todo Gemfile/MissingFeatureCategory
# NOTE:
# the fog-aliyun gem since v0.4 pulls in aliyun-sdk transitively, which monkey-patches
# the rest-client gem to drop the Content-Length header field for chunked transfers,
# which may have knock-on effects on other features using `RestClient`.
# We may want to update this dependency if this is ever addressed upstream, e.g. via
# https://github.com/aliyun/aliyun-oss-ruby-sdk/pull/93
gem 'fog-aliyun', '~> 0.4' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'gitlab-fog-azure-rm', '~> 2.1.0', require: 'fog/azurerm', feature_category: :shared

# for Google storage

# Need this specific version of google-apis-storage_v1 so that fog-google will utilize the updated list_objects with
# match_glob support in google-apis-core 0.11.1. Because of this we also have to bump google-cloud-storage to 1.45.0.
gem 'google-apis-storage_v1', '~> 0.29' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'google-cloud-storage', '~> 1.45.0' # rubocop:todo Gemfile/MissingFeatureCategory
# We need >= 0.11.1 because that's when match_glob support is added to list_objects
gem 'google-apis-core', '~> 0.11.0', '>= 0.11.1' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'google-apis-compute_v1', '~> 0.57.0' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'google-apis-container_v1', '~> 0.43.0' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'google-apis-container_v1beta1', '~> 0.43.0' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'google-apis-cloudbilling_v1', '~> 0.21.0' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'google-apis-cloudresourcemanager_v1', '~> 0.31.0' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'google-apis-iam_v1', '~> 0.36.0' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'google-apis-serviceusage_v1', '~> 0.28.0' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'google-apis-sqladmin_v1beta4', '~> 0.41.0' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'google-apis-androidpublisher_v3', '~> 0.34.0' # rubocop:todo Gemfile/MissingFeatureCategory

gem 'googleauth', '~> 1.8.1', feature_category: :shared
gem 'google-cloud-artifact_registry-v1', '~> 0.11.0', feature_category: :shared
gem 'google-cloud-compute-v1', '~> 2.6.0', feature_category: :shared

# Seed data
gem 'seed-fu', '~> 2.3.7' # rubocop:todo Gemfile/MissingFeatureCategory

# Search
gem 'elasticsearch-model', '~> 7.2', feature_category: :global_search
gem 'elasticsearch-rails', '~> 7.2', require: 'elasticsearch/rails/instrumentation', feature_category: :global_search
gem 'elasticsearch-api', '7.17.11', feature_category: :global_search
gem 'aws-sdk-core', '~> 3.211.0' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'aws-sdk-cloudformation', '~> 1' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'aws-sdk-s3', '~> 1.169.0' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'faraday-typhoeus', '~> 1.1', feature_category: :global_search
gem 'faraday_middleware-aws-sigv4', '~> 1.0.1', feature_category: :global_search
# Used with Elasticsearch to support http keep-alive connections
gem 'typhoeus', '~> 1.4.0', feature_category: :global_search

# Markdown and HTML processing
gem 'html-pipeline', '~> 2.14.3', feature_category: :markdown
gem 'deckar01-task_list', '2.3.4', feature_category: :markdown
gem 'gitlab-markup', '~> 1.9.0', require: 'github/markup', feature_category: :markdown
gem 'commonmarker', '~> 0.23.10', feature_category: :markdown
gem 'kramdown', '~> 2.4.0', feature_category: :markdown
gem 'RedCloth', '~> 4.3.3', feature_category: :markdown
gem 'org-ruby', '~> 0.9.12', feature_category: :markdown
gem 'creole', '~> 0.5.0', feature_category: :markdown
gem 'wikicloth', '0.8.1', feature_category: :markdown
gem 'asciidoctor', '~> 2.0.18', feature_category: :markdown
gem 'asciidoctor-include-ext', '~> 0.4.0', require: false, feature_category: :markdown
gem 'asciidoctor-plantuml', '~> 0.0.16', feature_category: :markdown
gem 'asciidoctor-kroki', '~> 0.10.0', require: false, feature_category: :markdown
gem 'rouge', '~> 4.4.0', feature_category: :shared
gem 'truncato', '~> 0.7.12', feature_category: :team_planning
gem 'nokogiri', '~> 1.16', feature_category: :shared
gem 'gitlab-glfm-markdown', '~> 0.0.21', feature_category: :markdown
gem 'tanuki_emoji', '~> 0.13', feature_category: :markdown
gem 'unicode-emoji', '~> 4.0', feature_category: :markdown

# Calendar rendering
gem 'icalendar', '~> 2.10.1', feature_category: :system_access

# Diffs
gem 'diffy', '~> 3.4' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'diff_match_patch', '~> 0.1.0', path: 'vendor/gems/diff_match_patch', feature_category: :team_planning

# Application server
gem 'rack', '~> 2.2.9' # rubocop:todo Gemfile/MissingFeatureCategory
# https://github.com/zombocom/rack-timeout/blob/master/README.md#rails-apps-manually
gem 'rack-timeout', '~> 0.7.0', require: 'rack/timeout/base' # rubocop:todo Gemfile/MissingFeatureCategory

group :puma do
  gem 'puma', '= 6.4.3', require: false, feature_category: :shared
  gem 'sd_notify', '~> 0.1.0', require: false # rubocop:todo Gemfile/MissingFeatureCategory
end

# State machine
gem 'state_machines-activerecord', '~> 0.8.0' # rubocop:todo Gemfile/MissingFeatureCategory

# Background jobs
gem 'sidekiq', path: 'vendor/gems/sidekiq-7.2.4', require: 'sidekiq', feature_category: :scalability
gem 'sidekiq-cron', '~> 1.12.0', feature_category: :scalability
gem 'gitlab-sidekiq-fetcher',
  path: 'vendor/gems/sidekiq-reliable-fetch',
  require: 'sidekiq-reliable-fetch',
  feature_category: :scalability

# Cron Parser
gem 'fugit', '~> 1.8.1' # rubocop:todo Gemfile/MissingFeatureCategory

# HTTP requests
gem 'httparty', '~> 0.21.0' # rubocop:todo Gemfile/MissingFeatureCategory

# Colored output to console
gem 'rainbow', '~> 3.0' # rubocop:todo Gemfile/MissingFeatureCategory

# Progress bar
gem 'ruby-progressbar', '~> 1.10' # rubocop:todo Gemfile/MissingFeatureCategory

# Linear-time regex library for untrusted regular expressions
gem 're2', '2.7.0' # rubocop:todo Gemfile/MissingFeatureCategory

# Misc

gem 'semver_dialects', '~> 3.0', feature_category: :software_composition_analysis
gem 'version_sorter', '~> 2.3' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'csv_builder', path: 'gems/csv_builder' # rubocop:todo Gemfile/MissingFeatureCategory

# Export Ruby Regex to Javascript
gem 'js_regex', '~> 3.8' # rubocop:todo Gemfile/MissingFeatureCategory

# User agent parsing
gem 'device_detector' # rubocop:todo Gemfile/MissingFeatureCategory

# Redis
gem 'redis-namespace', '~> 1.11.0', feature_category: :redis
gem 'redis', '~> 5.3.0', feature_category: :redis
gem 'redis-clustering', '~> 5.3.0', feature_category: :redis
gem 'connection_pool', '~> 2.4' # rubocop:todo Gemfile/MissingFeatureCategory

# Redis session store
gem 'redis-actionpack', '~> 5.4.0', feature_category: :redis

# Discord integration
gem 'discordrb-webhooks', '~> 3.5', require: false, feature_category: :integrations

# Jira integration
gem 'jira-ruby', '~> 2.3.0', feature_category: :integrations
gem 'atlassian-jwt', '~> 0.2.1', feature_category: :integrations

# Slack integration
gem 'slack-messenger', '~> 2.3.5', feature_category: :integrations

# FogBugz integration
gem 'ruby-fogbugz', '~> 0.3.0', feature_category: :importers

# Kubernetes integration
gem 'kubeclient', '~> 4.11.0' # rubocop:todo Gemfile/MissingFeatureCategory

# AI
gem 'ruby-openai', '~> 3.7' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'circuitbox', '2.0.0' # rubocop:todo Gemfile/MissingFeatureCategory

# Sanitize user input
gem 'sanitize', '~> 6.0.2' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'babosa', '~> 2.0' # rubocop:todo Gemfile/MissingFeatureCategory

# Sanitizes SVG input
gem 'loofah', '~> 2.22.0' # rubocop:todo Gemfile/MissingFeatureCategory

# Used to provide license templates
gem 'licensee', '~> 9.16' # rubocop:todo Gemfile/MissingFeatureCategory

# Detect and convert string character encoding
gem 'charlock_holmes', '~> 0.7.9', feature_category: :shared

# Detect mime content type from content
gem 'ruby-magic', '~> 0.6' # rubocop:todo Gemfile/MissingFeatureCategory

# Faster blank
gem 'fast_blank', '~> 1.0.1' # rubocop:todo Gemfile/MissingFeatureCategory

# Parse time & duration
gem 'gitlab-chronic', '~> 0.10.5' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'gitlab_chronic_duration', '~> 0.12' # rubocop:todo Gemfile/MissingFeatureCategory

gem 'rack-proxy', '~> 0.7.7' # rubocop:todo Gemfile/MissingFeatureCategory

gem 'cssbundling-rails', '1.4.1', feature_category: :shared
gem 'terser', '1.0.2' # rubocop:todo Gemfile/MissingFeatureCategory

gem 'click_house-client', path: 'gems/click_house-client', require: 'click_house/client' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'addressable', '~> 2.8' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'gon', '~> 6.4.0' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'request_store', '~> 1.5.1' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'base32', '~> 0.3.0' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'gitlab-license', '~> 2.5', feature_category: :shared

# Protect against bruteforcing
gem 'rack-attack', '~> 6.7.0' # rubocop:todo Gemfile/MissingFeatureCategory

# Sentry integration
gem 'sentry-ruby', '~> 5.21.0', feature_category: :observability
gem 'sentry-rails', '~> 5.21.0', feature_category: :observability
gem 'sentry-sidekiq', '~> 5.21.0', feature_category: :observability

# PostgreSQL query parsing
#
gem 'pg_query', '~> 5.1.0', feature_category: :database

gem 'gitlab-schema-validation', path: 'gems/gitlab-schema-validation' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'gitlab-http', path: 'gems/gitlab-http' # rubocop:todo Gemfile/MissingFeatureCategory

gem 'premailer-rails', '~> 1.12.0', feature_category: :notifications
gem 'gitlab-labkit', '~> 0.36.0', feature_category: :shared
gem 'thrift', '>= 0.16.0' # rubocop:todo Gemfile/MissingFeatureCategory

# I18n
gem 'rails-i18n', '~> 7.0', '>= 7.0.9', feature_category: :internationalization
gem 'gettext_i18n_rails', '~> 1.13.0', feature_category: :internationalization
gem 'gettext', '~> 3.4', '>= 3.4.9',
  require: false,
  group: [:development, :test],
  feature_category: :internationalization

gem 'batch-loader', '~> 2.0.5' # rubocop:todo Gemfile/MissingFeatureCategory

gem 'tty-prompt', '~> 0.23', require: false, feature_category: :shared

# Perf bar
gem 'peek', '~> 1.1' # rubocop:todo Gemfile/MissingFeatureCategory

# Google Cloud Profiler support
gem 'cloud_profiler_agent', '~> 0.0.0', path: 'vendor/gems/cloud_profiler_agent', require: false # rubocop:todo Gemfile/MissingFeatureCategory

# Snowplow events tracking
gem 'snowplow-tracker', '~> 0.8.0' # rubocop:todo Gemfile/MissingFeatureCategory

# Metrics
gem 'webrick', '~> 1.8.1', require: false # rubocop:todo Gemfile/MissingFeatureCategory
gem 'prometheus-client-mmap', '~> 1.1', '>= 1.1.1', require: 'prometheus/client' # rubocop:todo Gemfile/MissingFeatureCategory

# Event-driven reactor for Ruby
# Required manually in config/initializers/require_async_gem
gem 'async', '~> 2.12.1', require: false # rubocop:disable Gemfile/MissingFeatureCategory -- This is general utility gem

# Security report schemas used to validate CI job artifacts of security jobs
gem 'gitlab-security_report_schemas', '0.1.2.min15.0.0.max15.2.1', feature_category: :vulnerability_management

# OpenTelemetry
group :opentelemetry do
  # Core OpenTelemetry gems
  gem 'opentelemetry-sdk', feature_category: :observability
  gem 'opentelemetry-exporter-otlp', feature_category: :observability

  # OpenTelemetry gems selected from full set in `opentelemetry-instrumentation-all` metagem
  gem 'opentelemetry-instrumentation-active_support', feature_category: :observability
  gem 'opentelemetry-instrumentation-action_pack', feature_category: :observability
  gem 'opentelemetry-instrumentation-active_job', feature_category: :observability
  gem 'opentelemetry-instrumentation-active_record', feature_category: :observability
  gem 'opentelemetry-instrumentation-action_view', feature_category: :observability
  gem 'opentelemetry-instrumentation-aws_sdk', feature_category: :observability
  gem 'opentelemetry-instrumentation-http', feature_category: :observability
  gem 'opentelemetry-instrumentation-concurrent_ruby', feature_category: :observability
  gem 'opentelemetry-instrumentation-ethon', feature_category: :observability
  gem 'opentelemetry-instrumentation-excon', feature_category: :observability
  gem 'opentelemetry-instrumentation-faraday', feature_category: :observability
  gem 'opentelemetry-instrumentation-grape', feature_category: :observability
  gem 'opentelemetry-instrumentation-graphql', feature_category: :observability
  gem 'opentelemetry-instrumentation-http_client', feature_category: :observability
  gem 'opentelemetry-instrumentation-net_http', feature_category: :observability
  gem 'opentelemetry-instrumentation-pg', feature_category: :observability
  gem 'opentelemetry-instrumentation-rack', feature_category: :observability
  gem 'opentelemetry-instrumentation-rails', feature_category: :observability
  gem 'opentelemetry-instrumentation-rake', feature_category: :observability
  gem 'opentelemetry-instrumentation-redis', feature_category: :observability
  gem 'opentelemetry-instrumentation-sidekiq', feature_category: :observability
end

gem 'warning', '~> 1.3.0' # rubocop:todo Gemfile/MissingFeatureCategory

group :development do
  gem 'lefthook', '~> 1.7.0', require: false, feature_category: :tooling
  gem 'rubocop', feature_category: :tooling
  gem 'solargraph', '~> 0.47.2', require: false # rubocop:todo Gemfile/MissingFeatureCategory

  gem 'letter_opener_web', '~> 3.0.0' # rubocop:todo Gemfile/MissingFeatureCategory
  gem 'lookbook', '~> 2.3' # rubocop:todo Gemfile/MissingFeatureCategory

  # Better errors handler
  gem 'better_errors', '~> 2.10.1' # rubocop:todo Gemfile/MissingFeatureCategory

  gem 'sprite-factory', '~> 1.7' # rubocop:todo Gemfile/MissingFeatureCategory

  gem 'listen', '~> 3.7' # rubocop:todo Gemfile/MissingFeatureCategory

  gem 'ruby-lsp', "~> 0.19.0", require: false, feature_category: :tooling

  gem 'ruby-lsp-rails', "~> 0.3.6", feature_category: :tooling

  gem 'ruby-lsp-rspec', "~> 0.1.10", require: false, feature_category: :tooling

  gem 'gdk-toogle', '~> 0.9', '>= 0.9.5', require: 'toogle', feature_category: :tooling
end

group :development, :test do
  gem 'deprecation_toolkit', '~> 1.5.1', require: false # rubocop:todo Gemfile/MissingFeatureCategory
  gem 'bullet', '~> 7.1.2' # rubocop:todo Gemfile/MissingFeatureCategory
  gem 'parser', '= 3.3.6.0', feature_category: :shared
  gem 'pry-byebug' # rubocop:todo Gemfile/MissingFeatureCategory
  gem 'pry-rails', '~> 0.3.9' # rubocop:todo Gemfile/MissingFeatureCategory
  gem 'pry-shell', '~> 0.6.4' # rubocop:todo Gemfile/MissingFeatureCategory

  gem 'awesome_print', require: false # rubocop:todo Gemfile/MissingFeatureCategory

  gem 'database_cleaner-active_record', '~> 2.2.0', feature_category: :database
  gem 'rspec-rails', '~> 7.0.0', feature_category: :shared
  gem 'factory_bot_rails', '~> 6.4.3', feature_category: :tooling

  # Prevent occasions where minitest is not bundled in packaged versions of ruby (see #3826)
  gem 'minitest', '~> 5.11.0' # rubocop:todo Gemfile/MissingFeatureCategory

  gem 'spring', '~> 4.1.0' # rubocop:todo Gemfile/MissingFeatureCategory
  gem 'spring-commands-rspec', '~> 1.0.4' # rubocop:todo Gemfile/MissingFeatureCategory

  gem 'gitlab-styles', '~> 13.0.1', feature_category: :tooling
  gem 'haml_lint', '~> 0.58', feature_category: :tooling

  gem 'bundler-audit', '~> 0.9.1', require: false # rubocop:todo Gemfile/MissingFeatureCategory

  # Benchmarking & profiling
  gem 'benchmark-ips', '~> 2.11.0', require: false # rubocop:todo Gemfile/MissingFeatureCategory
  gem 'benchmark-memory', '~> 0.1', require: false # rubocop:todo Gemfile/MissingFeatureCategory

  # Profiling data from CI/CD pipelines
  gem 'influxdb-client', '~> 3.1', require: false, feature_category: :tooling

  gem 'knapsack', '~> 4.0.0', feature_category: :tooling
  gem 'crystalball', '~> 0.7.0', require: false, feature_category: :tooling
  gem 'test_file_finder', '~> 0.3.1', feature_category: :tooling

  gem 'simple_po_parser', '~> 1.1.6', require: false # rubocop:todo Gemfile/MissingFeatureCategory

  gem 'png_quantizator', '~> 0.2.1', require: false # rubocop:todo Gemfile/MissingFeatureCategory

  gem 'parallel', '~> 1.19', require: false # rubocop:todo Gemfile/MissingFeatureCategory

  gem 'sigdump', '~> 0.2.4', require: 'sigdump/setup' # rubocop:todo Gemfile/MissingFeatureCategory

  gem 'pact', '~> 1.64' # rubocop:todo Gemfile/MissingFeatureCategory

  # For now we only use vite in development / test, and not for production builds
  # See: https://gitlab.com/gitlab-org/frontend/rfcs/-/issues/106
  gem 'vite_rails', '~> 3.0.17', feature_category: :shared
  gem 'vite_ruby', '~> 3.8.0', feature_category: :shared

  gem 'gitlab-housekeeper', path: 'gems/gitlab-housekeeper', feature_category: :tooling
end

group :development, :test, :danger do
  gem 'gitlab-dangerfiles', '~> 4.8.0', require: false, feature_category: :tooling
end

group :development, :test, :coverage do
  gem 'simplecov', '~> 0.22', require: false, feature_category: :tooling
  gem 'simplecov-lcov', '~> 0.8.0', require: false, feature_category: :tooling
  gem 'simplecov-cobertura', '~> 2.1.0', require: false, feature_category: :tooling
  gem 'undercover', '~> 0.5.0', require: false, feature_category: :tooling
end

# Gems required in omnibus-gitlab pipeline
group :development, :test, :omnibus do
  gem 'license_finder', '~> 7.0', require: false # rubocop:todo Gemfile/MissingFeatureCategory
end

# Gems required in various pipelines
group :development, :test, :monorepo do
  gem 'gitlab-rspec', path: 'gems/gitlab-rspec' # rubocop:todo Gemfile/MissingFeatureCategory
  gem 'gitlab-rspec_flaky', path: 'gems/gitlab-rspec_flaky', feature_category: :tooling
end

group :test do
  gem 'fuubar', '~> 2.2.0' # rubocop:todo Gemfile/MissingFeatureCategory
  gem 'rspec-retry', '~> 0.6.2', feature_category: :tooling
  gem 'rspec_profiling', '~> 0.0.9', feature_category: :tooling
  gem 'rspec-benchmark', '~> 0.6.0', feature_category: :tooling
  gem 'rspec-parameterized', '~> 1.0', '>= 1.0.2', require: false, feature_category: :tooling
  gem 'os', '~> 1.1', '>= 1.1.4', feature_category: :tooling

  gem 'capybara', '~> 3.40', feature_category: :test_platform
  gem 'capybara-screenshot', '~> 1.0.26', feature_category: :test_platform
  gem 'selenium-webdriver', '~> 4.21', '>= 4.21.1', feature_category: :test_platform

  gem 'graphlyte', '~> 1.0.0' # rubocop:todo Gemfile/MissingFeatureCategory

  gem 'shoulda-matchers', '~> 5.1.0', require: false # rubocop:todo Gemfile/MissingFeatureCategory
  gem 'email_spec', '~> 2.2.0' # rubocop:todo Gemfile/MissingFeatureCategory
  gem 'webmock', '~> 3.24.0', feature_category: :shared
  gem 'rails-controller-testing' # rubocop:todo Gemfile/MissingFeatureCategory
  gem 'concurrent-ruby', '~> 1.1' # rubocop:todo Gemfile/MissingFeatureCategory
  gem 'test-prof', '~> 1.4.0', feature_category: :tooling
  gem 'rspec_junit_formatter' # rubocop:todo Gemfile/MissingFeatureCategory
  gem 'guard-rspec' # rubocop:todo Gemfile/MissingFeatureCategory
  gem 'axe-core-rspec', '~> 4.9.0', feature_category: :tooling

  # Moved in `test` because https://gitlab.com/gitlab-org/gitlab/-/issues/217527
  gem 'derailed_benchmarks', require: false # rubocop:todo Gemfile/MissingFeatureCategory

  gem 'gitlab_quality-test_tooling', '~> 2.1.0', require: false, feature_category: :tooling
end

gem 'octokit', '~> 9.0', feature_category: :importers
# Needed by octokit: https://github.com/octokit/octokit.rb/pull/1688
gem 'faraday-multipart', '~> 1.0', feature_category: :importers

gem 'gitlab-mail_room', '~> 0.0.24', require: 'mail_room', feature_category: :shared

gem 'email_reply_trimmer', '~> 0.1' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'html2text' # rubocop:todo Gemfile/MissingFeatureCategory

gem 'stackprof', '~> 0.2.26', require: false, feature_category: :shared
gem 'rbtrace', '~> 0.4', require: false # rubocop:todo Gemfile/MissingFeatureCategory
gem 'memory_profiler', '~> 1.0', require: false # rubocop:todo Gemfile/MissingFeatureCategory
gem 'activerecord-explain-analyze', '~> 0.1', require: false # rubocop:todo Gemfile/MissingFeatureCategory

# OAuth
gem 'oauth2', '~> 2.0' # rubocop:todo Gemfile/MissingFeatureCategory

# Health check
gem 'health_check', '~> 3.0' # rubocop:todo Gemfile/MissingFeatureCategory

# System information
gem 'vmstat', '~> 2.3.0' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'sys-filesystem', '~> 1.4.3' # rubocop:todo Gemfile/MissingFeatureCategory

# NTP client
gem 'net-ntp' # rubocop:todo Gemfile/MissingFeatureCategory

# SSH keys support
gem 'ssh_data', '~> 1.3' # rubocop:todo Gemfile/MissingFeatureCategory

# Spamcheck GRPC protocol definitions
gem 'spamcheck', '~> 1.3.0' # rubocop:todo Gemfile/MissingFeatureCategory

# Gitaly GRPC protocol definitions
gem 'gitaly', '~> 17.5.0.pre.rc1', feature_category: :gitaly

# KAS GRPC protocol definitions
gem 'gitlab-kas-grpc', '~> 17.5.0', feature_category: :deployment_management

# Lock the version before issues below are resolved:
# https://gitlab.com/gitlab-org/gitlab/-/issues/473169#note_2028352939
# Or we can upgrade to a more recent version as long as we can confirm
# that it doesn't have the same issues.
gem 'grpc', '= 1.63.0', feature_category: :shared

gem 'google-protobuf', '~> 3.25', '>= 3.25.3' # rubocop:todo Gemfile/MissingFeatureCategory

gem 'toml-rb', '~> 2.2.0' # rubocop:todo Gemfile/MissingFeatureCategory

# Feature toggles
gem 'flipper', '~> 0.26.2' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'flipper-active_record', '~> 0.26.2' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'flipper-active_support_cache_store', '~> 0.26.2' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'unleash', '~> 3.2.2' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'gitlab-experiment', '~> 0.9.1', feature_category: :shared

# Structured logging
gem 'lograge', '~> 0.5' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'grape_logging', '~> 1.8', '>= 1.8.4', feature_category: :api

# DNS Lookup
gem 'gitlab-net-dns', '~> 0.9.2' # rubocop:todo Gemfile/MissingFeatureCategory

# Countries list
gem 'countries', '~> 4.0.0' # rubocop:todo Gemfile/MissingFeatureCategory

gem 'retriable', '~> 3.1.2' # rubocop:todo Gemfile/MissingFeatureCategory

# LRU cache
gem 'lru_redux' # rubocop:todo Gemfile/MissingFeatureCategory

# Locked as long as quoted-printable encoding issues are not resolved
# Monkey-patched in `config/initializers/mail_encoding_patch.rb`
# See https://gitlab.com/gitlab-org/gitlab/issues/197386
#
# `config/initializers/mail_starttls_patch.rb` has also been patched to
# fix STARTTLS handling until https://github.com/mikel/mail/pull/1536 is
# released.
gem 'mail', '= 2.8.1' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'mail-smtp_pool', '~> 0.1.0', path: 'vendor/gems/mail-smtp_pool', require: false # rubocop:todo Gemfile/MissingFeatureCategory

gem 'microsoft_graph_mailer', '~> 0.1.0', path: 'vendor/gems/microsoft_graph_mailer' # rubocop:todo Gemfile/MissingFeatureCategory

# File encryption
gem 'lockbox', '~> 1.3.0' # rubocop:todo Gemfile/MissingFeatureCategory

# Email validation
gem 'valid_email', '~> 0.1' # rubocop:todo Gemfile/MissingFeatureCategory

# JSON
gem 'jsonb_accessor', '~> 1.3.10' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'json', '~> 2.7.2', feature_category: :shared
gem 'json_schemer', '~> 2.3.0', feature_category: :shared
gem 'oj', '~> 3.13.21' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'oj-introspect', '~> 0.7' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'multi_json', '~> 1.14.1' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'yajl-ruby', '~> 1.4.3', require: 'yajl' # rubocop:todo Gemfile/MissingFeatureCategory

gem 'webauthn', '~> 3.0' # rubocop:todo Gemfile/MissingFeatureCategory

# IPAddress utilities
gem 'ipaddress', '~> 0.8.3' # rubocop:todo Gemfile/MissingFeatureCategory

gem 'parslet', '~> 1.8' # rubocop:todo Gemfile/MissingFeatureCategory

gem 'ipynbdiff', path: 'gems/ipynbdiff', require: 'ipynb_diff' # rubocop:todo Gemfile/MissingFeatureCategory

gem 'ed25519', '~> 1.3.0' # rubocop:todo Gemfile/MissingFeatureCategory

# Error Tracking OpenAPI client
# See https://gitlab.com/gitlab-org/gitlab/-/blob/master/doc/development/rake_tasks.md#update-openapi-client-for-error-tracking-feature
gem 'error_tracking_open_api', path: 'gems/error_tracking_open_api' # rubocop:todo Gemfile/MissingFeatureCategory

# Vulnerability advisories
gem 'cvss-suite', '~> 3.0.1', require: 'cvss_suite' # rubocop:todo Gemfile/MissingFeatureCategory

# Work with RPM packages
gem 'arr-pm', '~> 0.0.12' # rubocop:todo Gemfile/MissingFeatureCategory

# Remote Development
gem 'devfile', '~> 0.1.0', feature_category: :workspaces

# Apple plist parsing
gem 'CFPropertyList', '~> 3.0.0' # rubocop:todo Gemfile/MissingFeatureCategory
gem 'app_store_connect' # rubocop:todo Gemfile/MissingFeatureCategory

# For phone verification
gem 'telesignenterprise', '~> 2.2' # rubocop:todo Gemfile/MissingFeatureCategory

# BufferedIO patch
# Updating this version will require updating scripts/allowed_warnings.txt
gem 'net-protocol', '~> 0.1.3' # rubocop:todo Gemfile/MissingFeatureCategory

# This is locked to 0.4.1 because we patch Net::HTTP#connect in
# gems/gitlab-http/lib/net_http/connect_patch.rb.
gem 'net-http', '= 0.4.1', feature_category: :shared

gem 'duo_api', '~> 1.3' # rubocop:todo Gemfile/MissingFeatureCategory

gem 'gitlab-sdk', '~> 0.3.0', feature_category: :application_instrumentation

gem 'openbao_client', path: 'gems/openbao_client' # rubocop:todo Gemfile/MissingFeatureCategory

gem 'paper_trail', '~> 15.0' # rubocop:todo Gemfile/MissingFeatureCategory

gem "i18n_data", "~> 0.13.1", feature_category: :system_access
