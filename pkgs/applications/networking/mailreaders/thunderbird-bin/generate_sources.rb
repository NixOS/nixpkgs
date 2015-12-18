version = if ARGV.empty?
            "latest"
          else
            ARGV[0]
          end

base_path = "archive.mozilla.org/pub/thunderbird/releases"

arches = ["linux-i686", "linux-x86_64"]

arches.each do |arch|
  system("wget", "--recursive", "--continue", "--no-parent", "--reject-regex", ".*\\?.*", "--reject", "xpi", "http://#{base_path}/#{version}/#{arch}/")
end

locales = Dir.glob("#{base_path}/#{version}/#{arches[0]}/*").map do |path|
  File.basename(path)
end.sort

locales.delete("index.html")
locales.delete("xpi")

# real version number, e.g. "30.0" instead of "latest".
real_version = Dir.glob("#{base_path}/#{version}/#{arches[0]}/#{locales[0]}/thunderbird-*")[0].match(/thunderbird-([0-9.]*)/)[1][0..-2]

locale_arch_path_tuples = locales.flat_map do |locale|
  arches.map do |arch|
    path = Dir.glob("#{base_path}/#{version}/#{arch}/#{locale}/thunderbird-*")[0]

    [locale, arch, path]
  end
end

paths = locale_arch_path_tuples.map do |tuple| tuple[2] end

hashes = IO.popen(["sha256sum", "--binary", *paths]) do |input|
  input.each_line.map do |line|
    $stderr.puts(line)

    line.match(/^[0-9a-f]*/)[0]
  end
end


puts(<<"EOH")
# This file is generated from generate_sources.rb. DO NOT EDIT.
# Execute the following command in a temporary directory to update the file.
#
# ruby generate_sources.rb > sources.nix

{
  version = "#{real_version}";
  sources = [
EOH

locale_arch_path_tuples.zip(hashes) do |tuple, hash|
  locale, arch, path = tuple

  puts(%Q|    { locale = "#{locale}"; arch = "#{arch}"; sha256 = "#{hash}"; }|)
end

puts(<<'EOF')
  ];
}
EOF
