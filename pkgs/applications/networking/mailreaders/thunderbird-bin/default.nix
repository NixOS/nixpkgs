{ stdenv, fetchurl, config, makeWrapper
, gconf
, alsaLib
, at-spi2-atk
, atk
, cairo
, cups
, curl
, dbus-glib
, dbus_libs
, fontconfig
, freetype
, gdk_pixbuf
, glib
, glibc
, gst-plugins-base
, gstreamer
, gtk2
, gtk3
, kerberos
, libX11
, libXScrnSaver
, libXcomposite
, libXdamage
, libXext
, libXfixes
, libXinerama
, libXrender
, libXt
, libcanberra-gtk2
, libgnome
, libgnomeui
, defaultIconTheme
, mesa
, nspr
, nss
, pango
, writeScript
, xidel
, coreutils
, gnused
, gnugrep
, gnupg
}:

assert stdenv.isLinux;

# imports `version` and `sources`
with (import ./release_sources.nix);

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

  name = "thunderbird-bin-${version}";
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://download-installer.cdn.mozilla.net/pub/thunderbird/releases/${version}/${source.arch}/${source.locale}/thunderbird-${version}.tar.bz2";
    inherit (source) sha512;
  };

  phases = "unpackPhase installPhase";

  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.cc.cc
      gconf
      alsaLib
      at-spi2-atk
      atk
      cairo
      cups
      curl
      dbus-glib
      dbus_libs
      fontconfig
      freetype
      gdk_pixbuf
      glib
      glibc
      gst-plugins-base
      gstreamer
      gtk2
      gtk3
      kerberos
      libX11
      libXScrnSaver
      libXcomposite
      libXdamage
      libXext
      libXfixes
      libXinerama
      libXrender
      libXt
      libcanberra-gtk2
      libgnome
      libgnomeui
      mesa
      nspr
      nss
      pango
    ] + ":" + stdenv.lib.makeSearchPathOutput "lib" "lib64" [
      stdenv.cc.cc
    ];

  buildInputs = [ gtk3 defaultIconTheme ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase =
    ''
      mkdir -p "$prefix/usr/lib/thunderbird-bin-${version}"
      cp -r * "$prefix/usr/lib/thunderbird-bin-${version}"

      mkdir -p "$out/bin"
      ln -s "$prefix/usr/lib/thunderbird-bin-${version}/thunderbird" "$out/bin/"

      for executable in \
        thunderbird crashreporter thunderbird-bin plugin-container updater
      do
        patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          "$out/usr/lib/thunderbird-bin-${version}/$executable"
      done

      find . -executable -type f -exec \
        patchelf --set-rpath "$libPath" \
          "$out/usr/lib/thunderbird-bin-${version}/{}" \;

      # Create a desktop item.
      mkdir -p $out/share/applications
      cat > $out/share/applications/thunderbird.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Exec=$out/bin/thunderbird
      Icon=$out/usr/lib/thunderbird-bin-${version}/chrome/icons/default/default256.png
      Name=Thunderbird
      GenericName=Mail Reader
      Categories=Application;Network;
      EOF

      wrapProgram "$out/bin/thunderbird" \
        --argv0 "$out/bin/.thunderbird-wrapped" \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:" \
        --suffix XDG_DATA_DIRS : "$XDG_ICON_DIRS"
    '';

  passthru.updateScript = import ./../../browsers/firefox-bin/update.nix {
    inherit name writeScript xidel coreutils gnused gnugrep curl gnupg;
    baseName = "thunderbird";
    channel = "release";
    basePath = "pkgs/applications/networking/mailreaders/thunderbird-bin";
    baseUrl = "http://archive.mozilla.org/pub/thunderbird/releases/";
  };
  meta = with stdenv.lib; {
    description = "Mozilla Thunderbird, a full-featured email client (binary package)";
    homepage = http://www.mozilla.org/thunderbird/;
    license = {
      free = false;
      url = http://www.mozilla.org/en-US/foundation/trademarks/policy/;
    };
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
    platforms = platforms.linux;
  };
}
