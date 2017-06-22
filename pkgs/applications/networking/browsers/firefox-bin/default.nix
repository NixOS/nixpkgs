{ stdenv, fetchurl, config, wrapGAppsHook
, alsaLib
, atk
, cairo
, curl
, cups
, dbus_glib
, dbus_libs
, fontconfig
, freetype
, gconf
, gdk_pixbuf
, glib
, glibc
, gst-plugins-base
, gstreamer
, gtk2
, gtk3
, libX11
, libXScrnSaver
, libxcb
, libXcomposite
, libXdamage
, libXext
, libXfixes
, libXinerama
, libXrender
, libXt
, libcanberra_gtk2
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
, channel
, generated
, writeScript
, xidel
, coreutils
, gnused
, gnugrep
, gnupg
}:

assert stdenv.isLinux;

let

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

  name = "firefox-${channel}-bin-unwrapped-${version}";

in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl { inherit (source) url sha512; };

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.cc.cc
      alsaLib
      alsaLib.dev
      atk
      cairo
      curl
      cups
      dbus_glib
      dbus_libs
      fontconfig
      freetype
      gconf
      gdk_pixbuf
      glib
      glibc
      gst-plugins-base
      gstreamer
      gtk2
      gtk3
      libX11
      libXScrnSaver
      libXcomposite
      libxcb
      libXdamage
      libXext
      libXfixes
      libXinerama
      libXrender
      libXt
      libcanberra_gtk2
      libgnome
      libgnomeui
      mesa
      nspr
      nss
      pango
      libheimdal
      libpulseaudio
      libpulseaudio.dev
      systemd
    ] + ":" + stdenv.lib.makeSearchPathOutput "lib" "lib64" [
      stdenv.cc.cc
    ];

  inherit gtk3;

  buildInputs = [ wrapGAppsHook gtk3 defaultIconTheme ];

  # "strip" after "patchelf" may break binaries.
  # See: https://github.com/NixOS/patchelf/issues/10
  dontStrip = true;
  dontPatchELF = true;

  patchPhase = ''
    sed -i -e '/^pref("app.update.channel",/d' defaults/pref/channel-prefs.js
    echo 'pref("app.update.channel", "non-existing-channel")' >> defaults/pref/channel-prefs.js
  '';

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

      gappsWrapperArgs+=(--argv0 "$out/bin/.firefox-wrapped")
    '';

  passthru.ffmpegSupport = true;
  passthru.updateScript = import ./update.nix {
    inherit name channel writeScript xidel coreutils gnused gnugrep gnupg curl;
    baseUrl =
      if channel == "devedition"
        then "http://archive.mozilla.org/pub/devedition/releases/"
        else "http://archive.mozilla.org/pub/firefox/releases/";
  };
  meta = with stdenv.lib; {
    description = "Mozilla Firefox, free web browser (binary package)";
    homepage = http://www.mozilla.org/firefox/;
    license = {
      free = false;
      url = http://www.mozilla.org/en-US/foundation/trademarks/policy/;
    };
    platforms = platforms.linux;
    maintainers = with maintainers; [ garbas ];
  };
}
