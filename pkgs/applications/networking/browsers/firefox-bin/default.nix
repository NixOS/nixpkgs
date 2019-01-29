{ lib, stdenv, fetchurl, config, wrapGAppsHook
, alsaLib
, atk
, cairo
, curl
, cups
, dbus-glib
, dbus
, fontconfig
, freetype
, gconf
, gdk_pixbuf
, glib
, glibc
, gtk2
, gtk3
, kerberos
, libX11
, libXScrnSaver
, libxcb
, libXcomposite
, libXcursor
, libXdamage
, libXext
, libXfixes
, libXi
, libXinerama
, libXrender
, libXt
, libcanberra-gtk2
, libgnome
, libgnomeui
, libnotify
, defaultIconTheme
, libGLU_combined
, nspr
, nss
, pango
, libheimdal
, libpulseaudio
, systemd
, channel
, generated
, writeScript
, writeText
, xidel
, coreutils
, gnused
, gnugrep
, gnupg
, ffmpeg
}:

let

  inherit (generated) version sources;

  mozillaPlatforms = {
    "i686-linux" = "linux-i686";
    "x86_64-linux" = "linux-x86_64";
  };

  arch = mozillaPlatforms.${stdenv.hostPlatform.system};

  isPrefixOf = prefix: string:
    builtins.substring 0 (builtins.stringLength prefix) string == prefix;

  sourceMatches = locale: source:
      (isPrefixOf source.locale locale) && source.arch == arch;

  systemLocale = config.i18n.defaultLocale or "en-US";

  policies = {
    DisableAppUpdate = true;
  };

  policiesJson = writeText "no-update-firefox-policy.json" (builtins.toJSON { inherit policies; });

  defaultSource = stdenv.lib.findFirst (sourceMatches "en-US") {} sources;

  source = stdenv.lib.findFirst (sourceMatches systemLocale) defaultSource sources;

  name = "firefox-${channel}-bin-unwrapped-${version}";

in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl { inherit (source) url sha512; };

  phases = [ "unpackPhase" "patchPhase" "installPhase" "fixupPhase" ];

  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.cc.cc
      alsaLib
      (lib.getDev alsaLib)
      atk
      cairo
      curl
      cups
      dbus-glib
      dbus
      fontconfig
      freetype
      gconf
      gdk_pixbuf
      glib
      glibc
      gtk2
      gtk3
      kerberos
      libX11
      libXScrnSaver
      libXcomposite
      libXcursor
      libxcb
      libXdamage
      libXext
      libXfixes
      libXi
      libXinerama
      libXrender
      libXt
      libcanberra-gtk2
      libgnome
      libgnomeui
      libnotify
      libGLU_combined
      nspr
      nss
      pango
      libheimdal
      libpulseaudio
      (lib.getDev libpulseaudio)
      systemd
      ffmpeg
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
    # Don't download updates from Mozilla directly
    echo 'pref("app.update.auto", "false");' >> defaults/pref/channel-prefs.js
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

      # See: https://github.com/mozilla/policy-templates/blob/master/README.md
      mkdir -p "$out/lib/firefox-bin-${version}/distribution";
      ln -s ${policiesJson} "$out/lib/firefox-bin-${version}/distribution/policies.json";
    '';

  passthru.execdir = "/bin";
  passthru.ffmpegSupport = true;
  passthru.gssSupport = true;
  # update with:
  # $ nix-shell maintainers/scripts/update.nix --argstr package firefox-bin-unwrapped
  passthru.updateScript = import ./update.nix {
    inherit stdenv name channel writeScript xidel coreutils gnused gnugrep gnupg curl;
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
    platforms = builtins.attrNames mozillaPlatforms;
    maintainers = with maintainers; [ garbas ];
  };
}
