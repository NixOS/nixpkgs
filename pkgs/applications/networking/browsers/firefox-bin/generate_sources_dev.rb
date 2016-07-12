#!/usr/bin/env ruby
require "open-uri"

version =
  if ARGV.empty?
    $stderr.puts("Usage: ruby generate_sources_dev.rb <version> > dev_sources.nix")
    exit(-1)
  else
    ARGV[0]
  end

base_url = "http://download-installer.cdn.mozilla.net/pub/firefox/nightly/latest-mozilla-aurora"

arches = ["linux-i686", "linux-x86_64"]
locales = ["en-US"]
sources = []

Source = Struct.new(:hash, :arch, :locale, :filename)

locales.each do |locale|
  arches.each do |arch|
    basename = "firefox-#{version}.#{locale}.#{arch}"
    filename = basename + ".tar.bz2"
    sha512 = open("#{base_url}/#{basename}.checksums").each_line
      .find(filename).first
      .split(" ").first
    sources << Source.new(sha512, arch, locale, filename)
  end
end

sources = sources.sort_by do |source|
  [source.locale, source.arch]
end

puts(<<"EOH")
# This file is generated from generate_sources_dev.rb. DO NOT EDIT.
# Execute the following command to update the file.
#
# ruby generate_sources_dev.rb 49.0a2 > dev_sources.nix

{
  version = "#{version}";
  sources = [
EOH

sources.each do |source|
  puts(%Q|    { locale = "#{source.locale}"; arch = "#{source.arch}"; sha512 = "#{source.hash}"; }|)
end

puts(<<'EOF')
  ];
}
EOF
