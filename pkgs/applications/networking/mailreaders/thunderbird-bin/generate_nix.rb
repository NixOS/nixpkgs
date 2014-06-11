version = if ARGV.empty?
            "latest"
          else
            ARGV[0]
          end

base_path = "download-installer.cdn.mozilla.net/pub/thunderbird/releases"

arches = ["linux-i686", "linux-x86_64"]

arches.each do |arch|
  system("wget", "--recursive", "--continue", "--no-parent", "--reject-regex", ".*\\?.*", "--reject", "xpi", "http://#{base_path}/#{version}/#{arch}/")
end

locales = Dir.glob("#{base_path}/#{version}/#{arches[0]}/*").map do |path|
  File.basename(path)
end

locales.delete("index.html")
locales.delete("xpi")

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
# This file is generated from generate_nix.rb
# Execute the following command in a temporary directory to update the file.
#
# ruby generate_nix.rb > default.nix

{ stdenv, fetchurl, config
, gconf
, alsaLib
, at_spi2_atk
, atk
, cairo
, cups
, curl
, dbus_glib
, dbus_libs
, fontconfig
, freetype
, gdk_pixbuf
, glib
, glibc
, gst_plugins_base
, gstreamer
, gtk
, kerberos
, libX11
, libXScrnSaver
, libXext
, libXinerama
, libXrender
, libXt
, libcanberra
, libgnome
, libgnomeui
, mesa
, nspr
, nss
, pango
}:

let
  version = "#{real_version}";
  sources = [
EOH

locale_arch_path_tuples.zip(hashes) do |tuple, hash|
  locale, arch, path = tuple

  puts(%Q|    { locale = "#{locale}"; arch = "#{arch}"; sha256 = "#{hash}"; }|)
end

puts(<<'EOF')
  ];

  arch = if stdenv.system == "i686-linux"
    then "linux-i686"
    else "linux-x86_64";

  isPrefixOf = prefix: string:
    builtins.substring 0 (builtins.stringLength prefix) string == prefix;

  sourceMatches = locale: source:
      (isPrefixOf source.locale locale) && source.arch == arch;

  systemLocale = config.i18n.defaultLocale or "en-US";

  defaultSource = stdenv.lib.findFirst (sourceMatches "en-US") {} sources;

  source = stdenv.lib.findFirst (sourceMatches systemLocale) defaultSource sources;

in

stdenv.mkDerivation {
  name = "thunderbird-bin-${version}";

  src = fetchurl {
    url = "http://download-installer.cdn.mozilla.net/pub/thunderbird/releases/${version}/${source.arch}/${source.locale}/thunderbird-${version}.tar.bz2";
    inherit (source) sha256;
  };

  phases = "unpackPhase installPhase";

  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.gcc.gcc
      gconf
      alsaLib
      at_spi2_atk
      atk
      cairo
      cups
      curl
      dbus_glib
      dbus_libs
      fontconfig
      freetype
      gdk_pixbuf
      glib
      glibc
      gst_plugins_base
      gstreamer
      gtk
      kerberos
      libX11
      libXScrnSaver
      libXext
      libXinerama
      libXrender
      libXt
      libcanberra
      libgnome
      libgnomeui
      mesa
      nspr
      nss
      pango
    ] + ":" + stdenv.lib.makeSearchPath "lib64" [
      stdenv.gcc.gcc
    ];

  installPhase =
    ''
      mkdir -p "$prefix/usr/lib/thunderbird-bin-${version}"
      cp -r * "$prefix/usr/lib/thunderbird-bin-${version}"

      mkdir -p "$out/bin"
      ln -s "$prefix/usr/lib/thunderbird-bin-${version}/thunderbird" "$out/bin/"

      for executable in \
        thunderbird mozilla-xremote-client thunderbird-bin plugin-container \
        updater
      do
        patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
          "$out/usr/lib/thunderbird-bin-${version}/$executable"
      done

      for executable in \
        thunderbird mozilla-xremote-client thunderbird-bin plugin-container \
        updater libxul.so
      do
        patchelf --set-rpath "$libPath" \
          "$out/usr/lib/thunderbird-bin-${version}/$executable"
      done

      # Create a desktop item.
      mkdir -p $out/share/applications
      cat > $out/share/applications/thunderbird.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Exec=$out/bin/thunderbird
      Icon=$out/lib/thunderbird-bin-${version}/chrome/icons/default/default256.png
      Name=Thunderbird
      GenericName=Mail Reader
      Categories=Application;Network;
      EOF
    '';

  meta = with stdenv.lib; {
    description = "Mozilla Thunderbird, a full-featured email client";
    homepage = http://www.mozilla.org/thunderbird/;
    license = {
      shortName = "unfree"; # not sure
      fullName = "unfree";
      url = http://www.mozilla.org/en-US/foundation/trademarks/policy/;
    };
    platforms = platforms.linux;
  };
}
EOF
