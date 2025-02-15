# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lolcommits/version'

Gem::Specification.new do |s|
  s.name    = Lolcommits::GEM_NAME.dup
  s.version = Lolcommits::VERSION.dup

  s.authors = ['Matthew Rothenberg', 'Matthew Hutchinson']
  s.email   = ['mrothenberg@gmail.com', 'matt@hiddenloop.com']
  s.license = 'LGPL-3.0'
  s.summary = 'Capture webcam image on git commit for lulz.'

  s.description = <<-DESC
  lolcommits takes a snapshot with your webcam every time you git commit code,
  and archives a lolcat style image with it. It's selfies for software
  developers. `git blame` has never been so much fun.
  DESC

  s.metadata = {
    'homepage_uri' => 'https://lolcommits.github.io',
    'source_code_uri' => 'https://github.com/lolcommits/lolcommits',
    'changelog_uri' => 'https://github.com/lolcommits/lolcommits/blob/master/CHANGELOG.md',
    'bug_tracker_uri' => 'https://github.com/lolcommits/lolcommits/issues',
    'allowed_push_host' => 'https://rubygems.org'
  }

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,features}/*`.split("\n")
  s.executables   = 'lolcommits'
  s.require_paths = ['lib']

  # non-gem dependencies
  s.required_ruby_version = '>= 3.1'
  s.requirements << 'imagemagick'
  s.requirements << 'a webcam'

  # core
  s.add_runtime_dependency('optparse-plus', '~> 3.0.1')
  s.add_runtime_dependency('mercurial-ruby', '~> 0.7.12')
  s.add_runtime_dependency('mini_magick', '~> 5.0.1')
  s.add_runtime_dependency('launchy', '~> 3.0.1')
  s.add_runtime_dependency('open4', '~> 1.3.4')
  s.add_runtime_dependency('git', '~> 2.3.0')
  s.add_runtime_dependency('logger')
  s.add_runtime_dependency('ostruct')
  s.add_runtime_dependency('base64')

  # included plugins
  s.add_runtime_dependency('lolcommits-loltext', '~> 0.5.0')

  # development & test gems
  s.add_development_dependency('aruba')
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('debug')
  s.add_development_dependency('rubocop')
  s.add_development_dependency('minitest')
  s.add_development_dependency('ffaker')
end
