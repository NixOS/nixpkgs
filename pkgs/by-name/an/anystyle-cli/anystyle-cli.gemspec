# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'anystyle/cli/version'

Gem::Specification.new do |s|
  s.name         = 'anystyle-cli'
  s.version      = AnyStyle::CLI::VERSION.dup
  s.platform     = Gem::Platform::RUBY
  s.authors      = ['Sylvester Keil']
  s.email        = ['http://sylvester.keil.or.at']
  s.homepage     = 'http://anystyle.io'
  s.summary      = 'AnyStyle CLI'
  s.description  = 'A command line interface to the AnyStyle Parser and Finder.'
  s.license      = 'BSD-2-Clause'
  s.require_path = 'lib'
  s.bindir       = 'bin'
  s.executables  = ['anystyle']
  s.required_ruby_version = '>= 2.3'

  s.add_runtime_dependency('anystyle', '~>1.6')
  s.add_runtime_dependency('gli', '~>2.17')

  s.files = `git ls-files`.split("\n") - %w{
    .gitignore
    Gemfile
    anystyle-cli.gemspec
  }
end

# vim: syntax=ruby
