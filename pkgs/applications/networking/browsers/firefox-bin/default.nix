{ stdenv, fetchurl, config, makeWrapper
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
, gtk2
, gtk3
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
, defaultIconTheme
, mesa
, nspr
, nss
, pango
, libheimdal
, libpulseaudio
, systemd
, channel ? "stable"
}:

assert stdenv.isLinux;

let

  generated = if channel == "stable" then (import ./sources.nix)
         else if channel == "beta"   then (import ./beta_sources.nix)
         else if channel == "developer"   then { version = "48.0a2"; sources = [
            { locale = "en-US"; arch = "linux-i686"; sha512 = "3xa9lmq4phx7vfd74ha1bq108la96m4jyq11h2m070rbcjv5pg6ck2pxphr2im55lym7h6saw2l4lpzcr5xvnfmj1a7fdhszswjl3s4"; }
            { locale = "en-US"; arch = "linux-x86_64"; sha512 = "1vndwja68xbn3rfq15ffksagr7fm2ns84cib4bhx654425hp5ghfpiszl7qwyxg8s28srqdfsl9w8hp7qxsz5gmmiznf05zxfv487w7"; }
          ]; }
         else builtins.abort "Wrong channel! Channel must be one of `stable`, `beta` or `developer`";

  inherit (generated) version sources;

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
  name = "firefox-bin-unwrapped-${version}";

  src = fetchurl {
    url = if channel == "developer"
            then "http://download-installer.cdn.mozilla.net/pub/firefox/nightly/latest-mozilla-aurora/firefox-${version}.${source.locale}.${source.arch}.tar.bz2"
            else "http://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/${source.arch}/${source.locale}/firefox-${version}.tar.bz2";
    inherit (source) sha512;
  };

  phases = "unpackPhase installPhase";

  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.cc.cc
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
      gtk2
      gtk3
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
      libheimdal
      libpulseaudio
      systemd
    ] + ":" + stdenv.lib.makeSearchPathOutput "lib" "lib64" [
      stdenv.cc.cc
    ];

  buildInputs = [ makeWrapper gtk3 defaultIconTheme ];

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
        firefox firefox-bin plugin-container \
        updater crashreporter webapprt-stub
      do
        if [ -e "$out/usr/lib/firefox-bin-${version}/$executable" ]; then
          patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
            "$out/usr/lib/firefox-bin-${version}/$executable"
        fi
      done

      find . -executable -type f -exec \
        patchelf --set-rpath "$libPath" \
          "$out/usr/lib/firefox-bin-${version}/{}" \;

      # wrapFirefox expects "$out/lib" instead of "$out/usr/lib"
      ln -s "$out/usr/lib" "$out/lib"

      # Create a desktop item.
      mkdir -p $out/share/applications
      cat > $out/share/applications/firefox.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Exec=$out/bin/firefox
      Icon=$out/usr/lib/firefox-bin-${version}/browser/icons/mozicon128.png
      Name=Firefox
      GenericName=Web Browser
      Categories=Application;Network;
      EOF

      wrapProgram "$out/bin/firefox" \
        --argv0 "$out/bin/.firefox-wrapped" \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:" \
        --suffix XDG_DATA_DIRS : "$XDG_ICON_DIRS"
    '';

  meta = with stdenv.lib; {
    description = "Mozilla Firefox, free web browser (binary package)";
    homepage = http://www.mozilla.org/firefox/;
    license = {
      free = false;
      url = http://www.mozilla.org/en-US/foundation/trademarks/policy/;
    };
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ garbas ];
  };
}
