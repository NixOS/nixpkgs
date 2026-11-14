require_relative 'lib/lolcommits/version'

Gem::Specification.new do |s|
  s.name    = Lolcommits::GEM_NAME.dup
  s.version = Lolcommits::VERSION.dup

  s.authors = [ 'Matthew Rothenberg', 'Matthew Hutchinson' ]
  s.email   = [ 'mrothenberg@gmail.com', 'matt@hiddenloop.com' ]
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
    'allowed_push_host' => 'https://rubygems.org',
    'rubygems_mfa_required' => 'true'
  }

  s.files = Dir["lib/**/*", "vendor/ext/**/*", "bin/lolcommits", "LICENSE", "README.md", ".rubocop.yml"]
  s.executables = 'lolcommits'
  s.require_paths = [ 'lib' ]

  # non-gem dependencies
  s.required_ruby_version = '>= 3.1'
  s.requirements << 'imagemagick'
  s.requirements << 'a webcam'

  # core
  s.add_dependency('base64')
  s.add_dependency('git', '~> 2.3.3')
  s.add_dependency('launchy', '~> 3.0.1')
  s.add_dependency('logger')
  s.add_dependency('mercurial-ruby', '~> 0.7.12')
  s.add_dependency('mini_magick', '~> 5.0.1')
  s.add_dependency('open4', '~> 1.3.4')
  s.add_dependency('optparse-plus', '~> 3.0.1')
  s.add_dependency('ostruct')

  # included plugins
  s.add_dependency('lolcommits-loltext', '~> 0.5.0')

  # development & test gems
  s.add_development_dependency('aruba')
  s.add_development_dependency('debug')
  s.add_development_dependency('ffaker')
  s.add_development_dependency('minitest')
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
end
