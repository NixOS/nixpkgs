{ lib
, stdenv
, fetchurl
, makeDesktopItem
, copyDesktopItems
, makeWrapper
, writeText
, autoPatchelfHook
, wrapGAppsHook3
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

# Hardening
, graphene-hardened-malloc
# Whether to use graphene-hardened-malloc
, useHardenedMalloc ? null

# Whether to disable multiprocess support
, disableContentSandbox ? false

# Extra preferences
, extraPrefs ? ""
}:

lib.warnIf (useHardenedMalloc != null)
  "tor-browser: useHardenedMalloc is deprecated and enabling it can cause issues"

(let
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

  version = "13.5";

  sources = {
    x86_64-linux = fetchurl {
      urls = [
        "https://archive.torproject.org/tor-package-archive/torbrowser/${version}/tor-browser-linux-x86_64-${version}.tar.xz"
        "https://dist.torproject.org/torbrowser/${version}/tor-browser-linux-x86_64-${version}.tar.xz"
        "https://tor.eff.org/dist/torbrowser/${version}/tor-browser-linux-x86_64-${version}.tar.xz"
        "https://tor.calyxinstitute.org/dist/torbrowser/${version}/tor-browser-linux-x86_64-${version}.tar.xz"
      ];
      hash = "sha256-npqrGyCwqMeZ8JssR/EpvDClkLQ3K0xEfE19fHn+GDs=";
    };

    i686-linux = fetchurl {
      urls = [
        "https://archive.torproject.org/tor-package-archive/torbrowser/${version}/tor-browser-linux-i686-${version}.tar.xz"
        "https://dist.torproject.org/torbrowser/${version}/tor-browser-linux-i686-${version}.tar.xz"
        "https://tor.eff.org/dist/torbrowser/${version}/tor-browser-linux-i686-${version}.tar.xz"
        "https://tor.calyxinstitute.org/dist/torbrowser/${version}/tor-browser-linux-i686-${version}.tar.xz"
      ];
      hash = "sha256-qeXLBFhcCPDWRuCZiLL1wOY6BRWsk0h36jWe5U6eCJ8=";
    };
  };

  distributionIni = writeText "distribution.ini" (lib.generators.toINI {} {
    # Some light branding indicating this build uses our distro preferences
    Global = {
      id = "nixos";
      version = "1.0";
      about = "Tor Browser for NixOS";
    };
  });

  policiesJson = writeText "policies.json" (builtins.toJSON {
    policies.DisableAppUpdate = true;
  });
in
stdenv.mkDerivation rec {
  pname = "tor-browser";
  inherit version;

  src = sources.${stdenv.hostPlatform.system} or (throw "unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [ autoPatchelfHook copyDesktopItems makeWrapper wrapGAppsHook3 ];
  buildInputs = [
    gtk3
    alsa-lib
    dbus-glib
    libXtst
  ];

  preferLocalBuild = true;
  allowSubstitutes = false;

  desktopItems = [(makeDesktopItem {
    name = "torbrowser";
    exec = "tor-browser %U";
    icon = "tor-browser";
    desktopName = "Tor Browser";
    genericName = "Web Browser";
    comment = meta.description;
    categories = [ "Network" "WebBrowser" "Security" ];
  })];

  buildPhase = ''
    runHook preBuild

    # For convenience ...
    TBB_IN_STORE=$out/share/tor-browser
    interp=$(< $NIX_CC/nix-support/dynamic-linker)

    # Unpack & enter
    mkdir -p "$TBB_IN_STORE"
    tar xf "$src" -C "$TBB_IN_STORE" --strip-components=2
    pushd "$TBB_IN_STORE"

    # Set ELF interpreter
    for exe in firefox.real TorBrowser/Tor/tor ; do
      echo "Setting ELF interpreter on $exe ..." >&2
      patchelf --set-interpreter "$interp" "$exe"
    done

    # firefox is a wrapper that checks for a more recent libstdc++ & appends it to the ld path
    mv firefox.real firefox

    # store state at `~/.tor browser` instead of relative to executable
    touch "$TBB_IN_STORE/system-install"

    # The final libPath.  Note, we could split this into firefoxLibPath
    # and torLibPath for accuracy, but this is more convenient ...
    libPath=${libPath}:$TBB_IN_STORE:$TBB_IN_STORE/TorBrowser/Tor

    # apulse uses a non-standard library path.  For now special-case it.
    ${lib.optionalString (audioSupport && !pulseaudioSupport) ''
      libPath=${apulse}/lib/apulse:$libPath
    ''}

    # Fixup paths to pluggable transports.
    substituteInPlace TorBrowser/Data/Tor/torrc-defaults \
      --replace-fail './TorBrowser' "$TBB_IN_STORE/TorBrowser"

    # Fixup obfs transport.  Work around patchelf failing to set
    # interpreter for pre-compiled Go binaries by invoking the interpreter
    # directly.
    sed -i TorBrowser/Data/Tor/torrc-defaults \
        -e "s|\(ClientTransportPlugin meek_lite,obfs2,obfs3,obfs4,scramblesuit\) exec|\1 exec $interp|"

    # Similarly fixup snowflake
    sed -i TorBrowser/Data/Tor/torrc-defaults \
        -e "s|\(ClientTransportPlugin snowflake\) exec|\1 exec $interp|"

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

    // User should never change these.  Locking prevents these
    // values from being written to prefs.js, avoiding Store
    // path capture.
    lockPref("extensions.torlauncher.torrc-defaults_path", "$TBB_IN_STORE/TorBrowser/Data/Tor/torrc-defaults");
    lockPref("extensions.torlauncher.tor_path", "$TBB_IN_STORE/TorBrowser/Tor/tor");

    // Insist on using IPC for communicating with Tor
    //
    // Defaults to creating \$XDG_RUNTIME_DIR/Tor/{socks,control}.socket
    lockPref("extensions.torlauncher.control_port_use_ipc", true);
    lockPref("extensions.torlauncher.socks_port_use_ipc", true);

    // Optionally disable multiprocess support.  We always set this to ensure that
    // toggling the pref takes effect.
    lockPref("browser.tabs.remote.autostart.2", ${if disableContentSandbox then "false" else "true"});

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

    # FONTCONFIG_FILE is required to make fontconfig read the TBB
    # fonts.conf; upstream uses FONTCONFIG_PATH, but FC_DEBUG=1024
    # indicates the system fonts.conf being used instead.
    FONTCONFIG_FILE=$TBB_IN_STORE/fontconfig/fonts.conf
    substituteInPlace "$FONTCONFIG_FILE" \
      --replace-fail '<dir prefix="cwd">fonts</dir>' "<dir>$TBB_IN_STORE/fonts</dir>"

    # Hard-code paths to geoip data files.  TBB resolves the geoip files
    # relative to torrc-defaults_path but if we do not hard-code them
    # here, these paths end up being written to the torrc in the user's
    # state dir.
    cat >>TorBrowser/Data/Tor/torrc-defaults <<EOF
    GeoIPFile $TBB_IN_STORE/TorBrowser/Data/Tor/geoip
    GeoIPv6File $TBB_IN_STORE/TorBrowser/Data/Tor/geoip6
    EOF

    mkdir -p $out/bin

    makeWrapper "$TBB_IN_STORE/firefox" "$out/bin/tor-browser" \
      --prefix LD_PRELOAD : "${lib.optionalString (useHardenedMalloc == true)
        "${graphene-hardened-malloc}/lib/libhardened_malloc.so"}" \
      --prefix LD_LIBRARY_PATH : "$libPath" \
      --set FONTCONFIG_FILE "$FONTCONFIG_FILE" \
      --set-default MOZ_ENABLE_WAYLAND 1

    # Easier access to docs
    mkdir -p $out/share/doc
    ln -s $TBB_IN_STORE/TorBrowser/Docs $out/share/doc/tor-browser

    # Install icons
    for i in 16 32 48 64 128; do
      mkdir -p $out/share/icons/hicolor/''${i}x''${i}/apps/
      ln -s $out/share/tor-browser/browser/chrome/icons/default/default$i.png $out/share/icons/hicolor/''${i}x''${i}/apps/tor-browser.png
    done

    # Check installed apps
    echo "Checking bundled Tor ..."
    LD_LIBRARY_PATH=$libPath $TBB_IN_STORE/TorBrowser/Tor/tor --version >/dev/null

    echo "Checking tor-browser wrapper ..."
    $out/bin/tor-browser --version >/dev/null

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Install distribution customizations
    install -Dvm644 ${distributionIni} $out/share/tor-browser/distribution/distribution.ini
    install -Dvm644 ${policiesJson} $out/share/tor-browser/distribution/policies.json

    runHook postInstall
  '';

  passthru = {
    inherit sources;
    updateScript = callPackage ./update.nix {
      inherit pname version meta;
    };
  };

  meta = with lib; {
    description = "Privacy-focused browser routing traffic through the Tor network";
    mainProgram = "tor-browser";
    homepage = "https://www.torproject.org/";
    changelog = "https://gitweb.torproject.org/builders/tor-browser-build.git/plain/projects/tor-browser/Bundle-Data/Docs/ChangeLog.txt?h=maint-${version}";
    platforms = attrNames sources;
    maintainers = with maintainers; [ felschr panicgh joachifm hax404 ];
    # MPL2.0+, GPL+, &c.  While it's not entirely clear whether
    # the compound is "libre" in a strict sense (some components place certain
    # restrictions on redistribution), it's free enough for our purposes.
    license = with licenses; [ mpl20 lgpl21Plus lgpl3Plus free ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
})
