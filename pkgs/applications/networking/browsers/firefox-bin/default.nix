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
, libXcomposite
, libXdamage
, libXext
, libXfixes
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

assert stdenv.isLinux;

# imports `version` and `sources`
with (import ./sources.nix);

let
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
    inherit (source) sha1;
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
      libXcomposite
      libXdamage
      libXext
      libXfixes
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
