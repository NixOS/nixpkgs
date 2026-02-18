# frozen_string_literal: true

#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See COPYRIGHT and LICENSE files for more details.
#++

source "https://rubygems.org"

# TODO: Once packager.io and heroku buildpacks support bundler 2.4.22,
# then we can use the new bundler syntax `ruby file: '.ruby-version'`.
# https://github.com/heroku/heroku-buildpack-ruby/issues/1408#issuecomment-1841596215

ruby File.read(File.expand_path(".ruby-version", __dir__)).strip

gem "actionpack-xml_parser", "~> 2.0.0"
gem "activemodel-serializers-xml", "~> 1.0.1"
gem "activerecord-import", "~> 2.2.0"
gem "activerecord-session_store", "~> 2.2.0"
gem "ox"
gem "rails", "~> 8.0.4"
gem "responders", "~> 3.2"

gem "ffi", "~> 1.15"

gem "connection_pool", "~> 2.5.5"

gem "rdoc", ">= 2.4.2"

gem "doorkeeper", "~> 5.8.0"
# Maintain our own omniauth due to relative URL root issues
# see upstream PR: https://github.com/omniauth/omniauth/pull/903
gem "omniauth", git: "https://github.com/opf/omniauth", ref: "7eb21563ba047ef86d71f099975587b5ec88f9c9"
gem "request_store", "~> 1.7.0"

gem "warden", "~> 1.2"
gem "warden-basic_auth", "~> 0.2.1"

gem "pagy"
gem "will_paginate", "~> 4.0.0"

gem "friendly_id", "~> 5.6.0"

gem "scimitar", "~> 2.13"

gem "acts_as_list", "~> 1.2.6"
gem "acts_as_tree", "~> 2.9.0"
gem "awesome_nested_set", "~> 3.9.0"
gem "closure_tree", "~> 9.3.0"
gem "rubytree", "~> 2.1.0"

gem "addressable", "~> 2.8.0"

# Remove whitespace from model input
gem "auto_strip_attributes", "~> 2.5"

# Provide timezone info for TZInfo used by AR
gem "tzinfo-data", "~> 1.2025.1"

# to generate html-diffs (e.g. for wiki comparison)
gem "htmldiff"

# Generate url slugs with #to_url and other string niceties
gem "stringex", "~> 2.8.5"

# CommonMark markdown parser with GFM extension
gem "commonmarker", "~> 2.6.0"

# HTML pipeline for transformations on text formatter output
# such as sanitization or additional features
gem "html-pipeline", "~> 2.14.0"
# Tasklist parsing and renderer
gem "deckar01-task_list", "~> 2.3.1"
# Requires escape-utils for faster escaping
gem "escape_utils", "~> 1.3"
# Syntax highlighting used in html-pipeline with rouge
gem "rouge", "~> 4.7.0"
# HTML sanitization used for html-pipeline
gem "sanitize", "~> 7.0.0"
# HTML autolinking for mails and urls (replaces autolink)
gem "rinku", "~> 2.0.4", require: %w[rinku rails_rinku]
# Version parsing with semver
gem "semantic", "~> 1.6.1"

# generates SVG Graphs
# used for statistics on svn repositories
gem "svg-graph", "~> 2.2.0"

gem "date_validator", "~> 0.12.0"
gem "email_validator", "~> 2.2.3"
gem "json_schemer", "~> 2.5.0"
gem "ruby-duration", "~> 3.2.0"

gem "mail", "2.9.0"

gem "csv", "~> 3.3"

# provide compatible filesystem information for available storage
gem "sys-filesystem", "~> 1.5.0", require: false

gem "bcrypt", "~> 3.1.6"

gem "multi_json", "~> 1.19.0"
gem "oj", "~> 3.16.12"

gem "daemons"
gem "good_job", "~> 4.12.0" # update should be done manually in sync with saas-openproject version.

gem "rack-protection", "~> 3.2.0"

# Rack::Attack is a rack middleware to protect your web app from bad clients.
# It allows whitelisting, blacklisting, throttling, and tracking based
# on arbitrary properties of the request.
# https://github.com/kickstarter/rack-attack
gem "rack-attack", "~> 6.8.0"

# Browser detection for incompatibility checks
gem "browser", "~> 6.2.0"

# Providing health checks
gem "okcomputer", "~> 1.19.1"

# Lograge to provide sane and non-verbose logging
gem "lograge", "~> 0.14.0"

# Structured warnings to selectively disable them in production
gem "structured_warnings", "~> 0.5.0"

# catch exceptions and send them to any airbrake compatible backend
# don't require by default, instead load on-demand when actually configured
gem "airbrake", "~> 13.0.0", require: false

gem "markly", "~> 0.15" # another markdown parser like commonmarker, but with AST support used in PDF export
gem "md_to_pdf", git: "https://github.com/opf/md-to-pdf", ref: "6c565541bfa390c58d90d49aa9b487777704fc66"
gem "prawn", "~> 2.4"
gem "ttfunk", "~> 1.7.0" # remove after https://github.com/prawnpdf/prawn/issues/1346 resolved.

# prawn implicitly depends on matrix gem no longer in ruby core with 3.1
gem "matrix", "~> 0.4.3"

gem "mcp", "~> 0.4.0"

gem "meta-tags", "~> 2.22.2"

gem "paper_trail", "~> 17.0.0"

gem "op-clamav-client", "~> 3.4", require: "clamav"

# Global ID for polymorphic associations
gem "globalid", "~> 1.3"

# Recurring meeting events definition
gem "ice_cube", "~> 0.17.0"

group :production do
  # we use dalli as standard memcache client
  # requires memcached 1.4+
  gem "dalli", "~> 3.2.0"
  gem "redis", "~> 5.4.0"
end

gem "i18n-js", "~> 4.2.4"
gem "rails-i18n", "~> 8.1.0"

gem "sprockets", "~> 3.7.2" # lock sprockets below 4.0
gem "sprockets-rails", "~> 3.5.1"

gem "puma", "~> 7.1"
gem "puma-plugin-statsd", "~> 2.7"
gem "rack-timeout", "~> 0.7.0", require: "rack/timeout/base"

gem "nokogiri", "~> 1.19.0"

gem "carrierwave", "~> 1.3.4"
gem "carrierwave_direct", "~> 2.1.0"
gem "fog-aws"

gem "aws-sdk-core", "~> 3.241"
# File upload via fog + screenshots on travis
gem "aws-sdk-s3", "~> 1.211"

gem "openproject-token", "~> 8.6.0"

gem "plaintext", "~> 0.3.7"

gem "ruby-progressbar", "~> 1.13.0", require: false

gem "mini_magick", "~> 5.3.0", require: false

gem "validate_url"

# Storages support code
gem "dry-container"
gem "dry-monads"
gem "dry-validation"

# ActiveRecord extension which adds typecasting to store accessors
gem "store_attribute", "~> 2.0"

# Appsignal integration
gem "appsignal", "~> 4.7", require: false

# Yabeda integration
gem "yabeda-activerecord"
gem "yabeda-prometheus-mmap", require: false
gem "yabeda-puma-plugin"
gem "yabeda-rails"

# opentelemetry
gem "opentelemetry-exporter-otlp", "~> 0.31.0", require: false
gem "opentelemetry-instrumentation-all", "~> 0.89.0", require: false
gem "opentelemetry-sdk", "~> 1.10", require: false

gem "view_component", "~> 4.2.0"
# Lookbook
gem "lookbook", "2.3.14"

gem "inline_svg", "~> 1.10.0"

# Require factory_bot for usage with openproject plugins testing
gem "factory_bot", "~> 6.5.6", require: false
# require factory_bot_rails for convenience in core development
gem "factory_bot_rails", "~> 6.5.0", require: false

gem "turbo_power", "~> 0.7.0"
gem "turbo-rails", "~> 2.0.20"

# There is a problem with version 1.4.0. Do not update until you're sure there is no infinite hang
# happenning in failing tests when WebMock or VCR stub cannot be found.
gem "httpx", "~> 1.6.3"

# Brings actual deep-freezing to most ruby objects
gem "ice_nine"

group :test do
  gem "launchy", "~> 3.1.0"
  gem "rack-test", "~> 2.2.0"
  gem "shoulda-context", "~> 2.0"

  # Test prof provides factories from code
  # and other niceties
  gem "test-prof", "~> 1.4.0"
  gem "turbo_tests", github: "opf/turbo_tests", ref: "with-patches"

  gem "rack_session_access"
  gem "rspec", "~> 3.13.2"
  # also add to development group, so 'spec' rake task gets loaded
  gem "rspec-rails", "~> 8.0.0", group: :development

  # Retry failures within the same environment
  gem "retriable", "~> 3.1.1"
  gem "rspec-retry", "~> 0.6.1"

  # Accessibility tests
  gem "axe-core-rspec"

  # Modify ENV
  gem "climate_control"

  # XML comparison tests
  gem "compare-xml", "~> 0.66", require: false

  # PDF Export tests
  gem "pdf-inspector", "~> 1.2"

  # brings back testing for 'assigns' and 'assert_template' extracted in rails 5
  gem "rails-controller-testing", "~> 1.0.2"

  gem "capybara", "~> 3.40.0"
  gem "capybara_accessible_selectors", git: "https://github.com/citizensadvice/capybara_accessible_selectors", tag: "v0.15.0"
  gem "capybara-screenshot", "~> 1.0.17"
  gem "cuprite", "~> 0.17.0"
  gem "rspec-wait"
  gem "selenium-devtools"
  gem "selenium-webdriver", "~> 4.38"

  gem "fuubar", "~> 2.5.0", require: false
  gem "timecop", "~> 0.9.0"

  # Record your test suite's HTTP interactions and replay them during future test runs for fast, deterministic, accurate tests.
  gem "vcr"
  # Mock backend requests (for ruby tests)
  gem "webmock", "~> 3.26", require: false

  # Mock selenium requests through proxy (for feature tests)
  gem "puffing-billy", "~> 4.0.0"
  gem "table_print", "~> 1.5.6"

  gem "equivalent-xml", "~> 0.6"
  gem "json_spec", "~> 1.1.4"
  gem "shoulda-matchers", "~> 7.0", require: nil

  gem "parallel_tests", "~> 4.0"
end

group :ldap do
  gem "net-ldap", "~> 0.20.0"
end

group :development do
  gem "listen", "~> 3.9.0" # Use for event-based reloaders

  gem "letter_opener_web"

  gem "spring"
  gem "spring-commands-rspec"
  gem "spring-commands-rubocop"

  gem "colored2"

  # git hooks manager
  gem "lefthook", require: false
end

group :development, :test do
  gem "dotenv-rails"

  # Tracing and profiling gems
  gem "flamegraph", require: false
  gem "rack-mini-profiler", require: false
  gem "ruby-prof", require: false
  gem "stackprof", require: false
  gem "vernier", require: false

  # Output a stack trace anytime, useful when a process is stuck
  gem "rbtrace"

  # REPL with debug commands, Debug changed to byebug due to the issue below
  # https://github.com/puma/puma/issues/2835#issuecomment-2302133927
  gem "byebug"

  gem "pry-byebug", "~> 3.11.0", platforms: [:mri]
  gem "pry-rails", "~> 0.3.6"
  gem "pry-rescue", "~> 1.6.0"

  # ruby linting
  gem "rubocop", require: false
  gem "rubocop-capybara", require: false
  gem "rubocop-factory_bot", require: false
  gem "rubocop-openproject", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", "~> 2.34.2"
  gem "rubocop-rspec", require: false
  gem "rubocop-rspec_rails", require: false

  # erb linting
  gem "erb_lint", require: false
  gem "erblint-github", require: false

  # Brakeman scanner
  gem "brakeman", "~> 7.1.1"

  # i18n-tasks helps find and manage missing and unused translations.
  gem "i18n-tasks", "~> 1.1.0", require: false

  # Active Record Doctor helps to keep the database in good shape.
  gem "active_record_doctor", "~> 2.0.1"
end

gem "bootsnap", "~> 1.20.0", require: false

# API gems
gem "grape", "~> 2.4.0"
gem "grape_logging", "~> 3.0.0"
gem "roar", "~> 1.2.0"

# CORS for API
gem "rack-cors", "~> 2.0.2"

# Gmail API
gem "google-apis-gmail_v1", require: false
gem "googleauth", require: false

# Required for contracts
gem "disposable", "~> 0.6.2"

# Used for formula evaluation of calculated values
gem "dentaku", "~> 3.5"

# Used for more powerful counter caches
gem "counter_culture", "~> 3.11"

group :postgres do
  gem "pg", "~> 1.6.2"
end

# Support application loading when no database exists yet.
gem "activerecord-nulldb-adapter", "~> 1.2.2"

# Have application level locks on the database to have a mutex shared between workers/hosts.
# We e.g. employ this to safeguard the creation of journals.
gem "with_advisory_lock", "~> 7.0.2"

# Load Gemfile.modules explicitly to allow dependabot to work
eval_gemfile "./Gemfile.modules"

# Load Gemfile.local, Gemfile.plugins and custom Gemfiles
gemfiles = Dir.glob File.expand_path("{Gemfile.plugins,Gemfile.local}", __dir__)
gemfiles << ENV["CUSTOM_PLUGIN_GEMFILE"] unless ENV["CUSTOM_PLUGIN_GEMFILE"].nil?
gemfiles.each do |file|
  # We use send to allow dependabot to function
  # don't use eval_gemfile(file) here as it will break dependabot!
  send(:eval_gemfile, file) if File.readable?(file)
end

gem "openproject-octicons", "~>19.32.0"
gem "openproject-octicons_helper", "~>19.32.0"
gem "openproject-primer_view_components", "~>0.80.2"
