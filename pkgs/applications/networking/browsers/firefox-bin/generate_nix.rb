# TODO share code with thunderbird-bin/generate_nix.rb

version = if ARGV.empty?
            "latest"
          else
            ARGV[0]
          end

base_path = "download-installer.cdn.mozilla.net/pub/firefox/releases"

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
real_version = Dir.glob("#{base_path}/#{version}/#{arches[0]}/#{locales[0]}/firefox-*")[0].match(/firefox-([0-9.]*)/)[1][0..-2]

locale_arch_path_tuples = locales.flat_map do |locale|
  arches.map do |arch|
    path = Dir.glob("#{base_path}/#{version}/#{arch}/#{locale}/firefox-*")[0]

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
, alsaLib
, atk
, cairo
, cups
, dbus_glib
, dbus_libs
, fontconfig
, freetype
, gconf
, gdk_pixbuf
, glib
, glibc
, gst_plugins_base
, gstreamer
, gtk
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
, heimdal
, pulseaudio
, systemd
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
  name = "firefox-bin-${version}";

  src = fetchurl {
    url = "http://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/${source.arch}/${source.locale}/firefox-${version}.tar.bz2";
    inherit (source) sha256;
  };

  phases = "unpackPhase installPhase";

  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.gcc.gcc
      alsaLib
      atk
      cairo
      cups
      dbus_glib
      dbus_libs
      fontconfig
      freetype
      gconf
      gdk_pixbuf
      glib
      glibc
      gst_plugins_base
      gstreamer
      gtk
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
      heimdal
      pulseaudio
      systemd
    ] + ":" + stdenv.lib.makeSearchPath "lib64" [
      stdenv.gcc.gcc
    ];

  # "strip" after "patchelf" may break binaries.
  # See: https://github.com/NixOS/patchelf/issues/10
  dontStrip = 1;

  installPhase =
    ''
      mkdir -p "$prefix/usr/lib/firefox-bin-${version}"
      cp -r * "$prefix/usr/lib/firefox-bin-${version}"

      mkdir -p "$out/bin"
      ln -s "$prefix/usr/lib/firefox-bin-${version}/firefox" "$out/bin/"

      for executable in \
        firefox mozilla-xremote-client firefox-bin plugin-container \
        updater crashreporter webapprt-stub
      do
        patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
          "$out/usr/lib/firefox-bin-${version}/$executable"
      done

      for executable in \
        firefox mozilla-xremote-client firefox-bin plugin-container \
        updater crashreporter webapprt-stub libxul.so
      do
        patchelf --set-rpath "$libPath" \
          "$out/usr/lib/firefox-bin-${version}/$executable"
      done

      # Create a desktop item.
      mkdir -p $out/share/applications
      cat > $out/share/applications/firefox.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Exec=$out/bin/firefox
      Icon=$out/lib/firefox-bin-${version}/chrome/icons/default/default256.png
      Name=Firefox
      GenericName=Web Browser
      Categories=Application;Network;
      EOF
    '';

  meta = with stdenv.lib; {
    description = "Mozilla Firefox, free web browser";
    homepage = http://www.mozilla.org/firefox/;
    license = {
      shortName = "unfree"; # not sure
      fullName = "unfree";
      url = http://www.mozilla.org/en-US/foundation/trademarks/policy/;
    };
    platforms = platforms.linux;
  };
}
EOF
