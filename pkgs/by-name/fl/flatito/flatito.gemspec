# frozen_string_literal: true

require_relative "lib/flatito/version"

Gem::Specification.new do |spec|
  spec.name = "flatito"
  spec.version = Flatito::VERSION
  spec.authors = ["José Galisteo"]
  spec.email = ["ceritium@gmail.com"]

  spec.summary = "Grep for YAML and JSON files"
  spec.description = "A kind of grep for YAML and JSON files. It allows you to search for a key and get the value and the line number where it is located."

  spec.homepage = "https://github.com/ceritium/flatito"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "colorize"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
