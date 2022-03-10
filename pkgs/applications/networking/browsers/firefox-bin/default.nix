{ lib, stdenv, fetchurl, config, wrapGAppsHook
, alsa-lib
, atk
, cairo
, curl
, cups
, dbus-glib
, dbus
, fontconfig
, freetype
, gdk-pixbuf
, glib
, glibc
, gtk2
, gtk3
, libkrb5
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
, libXrandr
, libXt
, libXtst
, libcanberra
, libnotify
, adwaita-icon-theme
, libGLU, libGL
, nspr
, nss
, pango
, pipewire
, pciutils
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
, runtimeShell
, mesa # firefox wants gbm for drm+dmabuf
, systemLocale ? config.i18n.defaultLocale or "en_US"
}:

let

  inherit (generated) version sources;

  mozillaPlatforms = {
    i686-linux = "linux-i686";
    x86_64-linux = "linux-x86_64";
  };

  arch = mozillaPlatforms.${stdenv.hostPlatform.system};

  isPrefixOf = prefix: string:
    builtins.substring 0 (builtins.stringLength prefix) string == prefix;

  sourceMatches = locale: source:
      (isPrefixOf source.locale locale) && source.arch == arch;

  policies = {
    DisableAppUpdate = true;
  } // config.firefox.policies or {};

  policiesJson = writeText "firefox-policies.json" (builtins.toJSON { inherit policies; });

  defaultSource = lib.findFirst (sourceMatches "en-US") {} sources;

  mozLocale =
    if systemLocale == "ca_ES@valencia"
    then "ca-valencia"
    else lib.replaceStrings ["_"] ["-"] systemLocale;

  source = lib.findFirst (sourceMatches mozLocale) defaultSource sources;

  pname = "firefox-${channel}-bin-unwrapped";

in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl { inherit (source) url sha256; };

  libPath = lib.makeLibraryPath
    [ stdenv.cc.cc
      alsa-lib
      atk
      cairo
      curl
      cups
      dbus-glib
      dbus
      fontconfig
      freetype
      gdk-pixbuf
      glib
      glibc
      gtk2
      gtk3
      libkrb5
      mesa
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
      libXrandr
      libXt
      libXtst
      libcanberra
      libnotify
      libGLU libGL
      nspr
      nss
      pango
      pipewire
      pciutils
      libheimdal
      libpulseaudio
      systemd
      ffmpeg
    ] + ":" + lib.makeSearchPathOutput "lib" "lib64" [
      stdenv.cc.cc
    ];

  inherit gtk3;

  buildInputs = [ wrapGAppsHook gtk3 adwaita-icon-theme ];

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

  passthru.applicationName = "firefox";
  passthru.libName = "firefox-bin-${version}";
  passthru.execdir = "/bin";
  passthru.ffmpegSupport = true;
  passthru.gssSupport = true;
  # update with:
  # $ nix-shell maintainers/scripts/update.nix --argstr package firefox-bin-unwrapped
  passthru.updateScript = import ./update.nix {
    inherit pname channel writeScript xidel coreutils gnused gnugrep gnupg curl runtimeShell;
    baseUrl =
      if channel == "devedition"
        then "http://archive.mozilla.org/pub/devedition/releases/"
        else "http://archive.mozilla.org/pub/firefox/releases/";
  };
  meta = with lib; {
    description = "Mozilla Firefox, free web browser (binary package)";
    homepage = "http://www.mozilla.org/firefox/";
    license = licenses.mpl20;
    platforms = builtins.attrNames mozillaPlatforms;
    hydraPlatforms = [];
    maintainers = with maintainers; [ taku0 lovesegfault ];
  };
}
