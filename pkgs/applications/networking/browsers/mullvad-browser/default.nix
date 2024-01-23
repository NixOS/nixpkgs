{ lib
, stdenv
, fetchurl
, makeDesktopItem
, copyDesktopItems
, makeWrapper
, writeText
, wrapGAppsHook
, autoPatchelfHook
, callPackage

, atk
, cairo
, dbus
, dbus-glib
, fontconfig
, freetype
, gdk-pixbuf
, glib
, gtk3
, libxcb
, libX11
, libXext
, libXrender
, libXt
, libXtst
, mesa
, pango
, pciutils
, zlib

, libnotifySupport ? stdenv.isLinux
, libnotify

, waylandSupport ? stdenv.isLinux
, libxkbcommon
, libdrm
, libGL

, mediaSupport ? true
, ffmpeg

, audioSupport ? mediaSupport

, pipewireSupport ? audioSupport
, pipewire

, pulseaudioSupport ? audioSupport
, libpulseaudio
, apulse
, alsa-lib

, libvaSupport ? mediaSupport
, libva

# Extra preferences
, extraPrefs ? ""
}:

let
  libPath = lib.makeLibraryPath (
    [
      alsa-lib
      atk
      cairo
      dbus
      dbus-glib
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      libxcb
      libX11
      libXext
      libXrender
      libXt
      libXtst
      mesa # for libgbm
      pango
      pciutils
      stdenv.cc.cc
      stdenv.cc.libc
      zlib
    ] ++ lib.optionals libnotifySupport [ libnotify ]
      ++ lib.optionals waylandSupport [ libxkbcommon libdrm libGL ]
      ++ lib.optionals pipewireSupport [ pipewire ]
      ++ lib.optionals pulseaudioSupport [ libpulseaudio ]
      ++ lib.optionals libvaSupport [ libva ]
      ++ lib.optionals mediaSupport [ ffmpeg ]
  );

  version = "13.0.9";

  sources = {
    x86_64-linux = fetchurl {
      urls = [
        "https://cdn.mullvad.net/browser/${version}/mullvad-browser-linux-x86_64-${version}.tar.xz"
        "https://github.com/mullvad/mullvad-browser/releases/download/${version}/mullvad-browser-linux-x86_64-${version}.tar.xz"
        "https://archive.torproject.org/tor-package-archive/mullvadbrowser/${version}/mullvad-browser-linux-x86_64-${version}.tar.xz"
        "https://dist.torproject.org/mullvadbrowser/${version}/mullvad-browser-linux-x86_64-${version}.tar.xz"
        "https://tor.eff.org/dist/mullvadbrowser/${version}/mullvad-browser-linux-x86_64-${version}.tar.xz"
        "https://tor.calyxinstitute.org/dist/mullvadbrowser/${version}/mullvad-browser-linux-x86_64-${version}.tar.xz"
      ];
      hash = "sha256-TAtBlSkfpqsROq3bV9kwDYIJQAXSVkwxQwj3wIYEI7k=";
    };
  };

  distributionIni = writeText "distribution.ini" (lib.generators.toINI {} {
    # Some light branding indicating this build uses our distro preferences
    Global = {
      id = "nixos";
      version = "1.0";
      about = "Mullvad Browser for NixOS";
    };
  });

  policiesJson = writeText "policies.json" (builtins.toJSON {
    policies.DisableAppUpdate = true;
  });
in
stdenv.mkDerivation rec {
  pname = "mullvad-browser";
  inherit version;

  src = sources.${stdenv.hostPlatform.system} or (throw "unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [ copyDesktopItems makeWrapper wrapGAppsHook autoPatchelfHook ];
  buildInputs = [
    gtk3
    alsa-lib
    dbus-glib
    libXtst
  ];

  preferLocalBuild = true;
  allowSubstitutes = false;

  desktopItems = [(makeDesktopItem {
    name = "mullvad-browser";
    exec = "mullvad-browser %U";
    icon = "mullvad-browser";
    desktopName = "Mullvad Browser";
    genericName = "Web Browser";
    comment = meta.description;
    categories = [ "Network" "WebBrowser" "Security" ];
  })];

  buildPhase = ''
    runHook preBuild

    # For convenience ...
    MB_IN_STORE=$out/share/mullvad-browser

    # Unpack & enter
    mkdir -p "$MB_IN_STORE"
    tar xf "$src" -C "$MB_IN_STORE" --strip-components=2
    pushd "$MB_IN_STORE"

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "mullvadbrowser.real"

    # mullvadbrowser is a wrapper that checks for a more recent libstdc++ & appends it to the ld path
    mv mullvadbrowser.real mullvadbrowser

    # store state at `~/.mullvad` instead of relative to executable
    touch "$MB_IN_STORE/system-install"

    # Add bundled libraries to libPath.
    libPath=${libPath}:$MB_IN_STORE

    # apulse uses a non-standard library path.  For now special-case it.
    ${lib.optionalString (audioSupport && !pulseaudioSupport) ''
      libPath=${apulse}/lib/apulse:$libPath
    ''}

    # Prepare for autoconfig.
    #
    # See https://developer.mozilla.org/en-US/Firefox/Enterprise_deployment
    cat >defaults/pref/autoconfig.js <<EOF
    //
    pref("general.config.filename", "mozilla.cfg");
    pref("general.config.obscure_value", 0);
    EOF

    # Hard-coded Firefox preferences.
    cat >mozilla.cfg <<EOF
    // First line must be a comment

    // Reset pref that captures store paths.
    clearPref("extensions.xpiState");

    // Stop obnoxious first-run redirection.
    lockPref("noscript.firstRunRedirection", false);

    // Allow sandbox access to sound devices if using ALSA directly
    ${if (audioSupport && !pulseaudioSupport) then ''
      pref("security.sandbox.content.write_path_whitelist", "/dev/snd/");
    '' else ''
      clearPref("security.sandbox.content.write_path_whitelist");
    ''}

    ${lib.optionalString (extraPrefs != "") ''
      ${extraPrefs}
    ''}
    EOF

    # FONTCONFIG_FILE is required to make fontconfig read the MB
    # fonts.conf; upstream uses FONTCONFIG_PATH, but FC_DEBUG=1024
    # indicates the system fonts.conf being used instead.
    FONTCONFIG_FILE=$MB_IN_STORE/fontconfig/fonts.conf
    sed -i "$FONTCONFIG_FILE" \
      -e "s,<dir>fonts</dir>,<dir>$MB_IN_STORE/fonts</dir>,"

    mkdir -p $out/bin

    makeWrapper "$MB_IN_STORE/mullvadbrowser" "$out/bin/mullvad-browser" \
      --prefix LD_LIBRARY_PATH : "$libPath" \
      --set FONTCONFIG_FILE "$FONTCONFIG_FILE" \
      --set-default MOZ_ENABLE_WAYLAND 1

    # Easier access to docs
    mkdir -p $out/share/doc
    ln -s $MB_IN_STORE/Data/Docs $out/share/doc/mullvad-browser

    # Install icons
    for i in 16 32 48 64 128; do
      mkdir -p $out/share/icons/hicolor/''${i}x''${i}/apps/
      ln -s $out/share/mullvad-browser/browser/chrome/icons/default/default$i.png $out/share/icons/hicolor/''${i}x''${i}/apps/mullvad-browser.png
    done

    # Check installed apps
    echo "Checking mullvad-browser wrapper ..."
    $out/bin/mullvad-browser --version >/dev/null

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Install distribution customizations
    install -Dvm644 ${distributionIni} $out/share/mullvad-browser/distribution/distribution.ini
    install -Dvm644 ${policiesJson} $out/share/mullvad-browser/distribution/policies.json

    runHook postInstall
  '';

  passthru = {
    inherit sources;
    updateScript = callPackage ../tor-browser/update.nix {
      inherit pname version meta;
      baseUrl = "https://cdn.mullvad.net/browser/";
      name = "mullvad-browser";
    };
  };

  meta = with lib; {
    description = "Privacy-focused browser made in a collaboration between The Tor Project and Mullvad";
    homepage = "https://mullvad.net/en/browser";
    platforms = attrNames sources;
    maintainers = with maintainers; [ felschr panicgh ];
    # MPL2.0+, GPL+, &c.  While it's not entirely clear whether
    # the compound is "libre" in a strict sense (some components place certain
    # restrictions on redistribution), it's free enough for our purposes.
    license = with licenses; [ mpl20 lgpl21Plus lgpl3Plus free ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
