require "open-uri"

version = if ARGV.empty?
            "latest"
          else
            ARGV[0]
          end

base_path = "http://archive.mozilla.org/pub/thunderbird/releases"

Source = Struct.new(:hash, :arch, :locale, :filename)

sources = open("#{base_path}/#{version}/SHA1SUMS") do |input|
  input.readlines
end.select do |line|
  /\/thunderbird-.*\.tar\.bz2$/ === line && !(/source/ === line)
end.map do |line|
  hash, name = line.chomp.split(/ +/)
  Source.new(hash, *(name.split("/")))
end.sort_by do |source|
  [source.locale, source.arch]
end

real_version = sources[0].filename.match(/thunderbird-([0-9.]*)\.tar\.bz2/)[1]

arches = ["linux-i686", "linux-x86_64"]

puts(<<"EOH")
# This file is generated from generate_nix.rb. DO NOT EDIT.
# Execute the following command in a temporary directory to update the file.
#
# ruby generate_source.rb > source.nix

{
  version = "#{real_version}";
  sources = [
EOH

sources.each do |source|
  puts(%Q|    { locale = "#{source.locale}"; arch = "#{source.arch}"; sha1 = "#{source.hash}"; }|)
end

puts(<<'EOF')
  ];
}
EOF
