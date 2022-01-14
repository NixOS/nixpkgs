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
, mesa
, systemLocale ? config.i18n.defaultLocale or "en_US"
}:

let

  inherit (generated) version sources;

  waterfoxPlatforms = {
    x86_64-linux = "linux-x86_64";
  };

  arch = waterfoxPlatforms.${stdenv.hostPlatform.system};

  isPrefixOf = prefix: string:
    builtins.substring 0 (builtins.stringLength prefix) string == prefix;

  sourceMatches = locale: source:
      (isPrefixOf source.locale locale) && source.arch == arch;

  policies = {
    DisableAppUpdate = true;
  } // config.waterfox.policies or {};

  policiesJson = writeText "waterfox-policies.json" (builtins.toJSON { inherit policies; });

  defaultSource = lib.findFirst (sourceMatches "en-US") {} sources;

  mozLocale =
    if systemLocale == "ca_ES@valencia"
    then "ca-valencia"
    else lib.replaceStrings ["_"] ["-"] systemLocale;

  source = lib.findFirst (sourceMatches mozLocale) defaultSource sources;

  pname = "waterfox-bin-unwrapped";

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
    # Don't download updates from Waterfox directly
    echo 'pref("app.update.auto", "false");' >> defaults/pref/channel-prefs.js
  '';

  installPhase =
    ''
      mkdir -p "$prefix/usr/lib/waterfox-bin-${version}"
      cp -r * "$prefix/usr/lib/waterfox-bin-${version}"

      mkdir -p "$out/bin"
      ln -s "$prefix/usr/lib/waterfox-bin-${version}/waterfox" "$out/bin/"

      for executable in \
        waterfox waterfox-bin plugin-container \
        updater crashreporter webapprt-stub
      do
        if [ -e "$out/usr/lib/waterfox-bin-${version}/$executable" ]; then
          patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
            "$out/usr/lib/waterfox-bin-${version}/$executable"
        fi
      done

      find . -executable -type f -exec \
        patchelf --set-rpath "$libPath" \
          "$out/usr/lib/waterfox-bin-${version}/{}" \;

      # wrapWaterfox expects "$out/lib" instead of "$out/usr/lib"
      ln -s "$out/usr/lib" "$out/lib"

      gappsWrapperArgs+=(--argv0 "$out/bin/.waterfox-wrapped")

      # See: https://github.com/mozilla/policy-templates/blob/master/README.md
      mkdir -p "$out/lib/waterfox-bin-${version}/distribution";
      ln -s ${policiesJson} "$out/lib/waterfox-bin-${version}/distribution/policies.json";
    '';

  passthru.execdir = "/bin";
  passthru.ffmpegSupport = true;
  passthru.gssSupport = true;
  # update with:
  # $ nix-shell maintainers/scripts/update.nix --argstr package firefox-bin-unwrapped
  passthru.updateScript = import ./update.nix {
    inherit pname writeScript xidel coreutils gnused gnugrep gnupg curl runtimeShell;
    baseUrl = "https://github.com/WaterfoxCo/Waterfox/archive/refs/tags/";
  };
  meta = with lib; {
    description = "Waterfox, striking the perfect balance between privacy and usability. (binary package)";
    homepage = "http://www.waterfox.net";
    license = licenses.mpl20;
    platforms = builtins.attrNames waterfoxPlatforms;
    hydraPlatforms = [];
    maintainers = with maintainers; [ jcdickinson ];
  };
}
