{ stdenv
, fetchurl
, makeDesktopItem

# Common run-time dependencies
, zlib

# libxul run-time dependencies
, atk
, cairo
, dbus
, dbus_glib
, fontconfig
, freetype
, gdk_pixbuf
, glib
, gtk2
, libxcb
, libX11
, libXext
, libXrender
, libXt
, pango

, audioSupport ? mediaSupport
, pulseaudioSupport ? audioSupport
, libpulseaudio

# Media support (implies pulseaudio support)
, mediaSupport ? false
, gstreamer
, gst-plugins-base
, gst-plugins-good
, gst-ffmpeg
, gmp
, ffmpeg

# Pluggable transport dependencies
, python27
}:

with stdenv.lib;

let
  libPath = makeLibraryPath ([
    atk
    cairo
    dbus
    dbus_glib
    fontconfig
    freetype
    gdk_pixbuf
    glib
    gtk2
    libxcb
    libX11
    libXext
    libXrender
    libXt
    pango
    stdenv.cc.cc
    zlib
  ]
  ++ optionals pulseaudioSupport [ libpulseaudio ]
  ++ optionals mediaSupport [
    gstreamer
    gst-plugins-base
    gmp
    ffmpeg
  ]);

  gstPluginsPath = concatMapStringsSep ":" (x:
    "${x}/lib/gstreamer-0.10") [
      gstreamer
      gst-plugins-base
      gst-plugins-good
      gst-ffmpeg
    ];

  # Library search path for the fte transport
  fteLibPath = makeLibraryPath [ stdenv.cc.cc gmp ];

  # Upstream source
  version = "7.0.2";

  lang = "en-US";

  srcs = {
    "x86_64-linux" = fetchurl {
      urls = [
        "https://github.com/TheTorProject/gettorbrowser/releases/download/v${version}/tor-browser-linux64-${version}_${lang}.tar.xz"
        "https://dist.torproject.org/torbrowser/${version}/tor-browser-linux64-${version}_${lang}.tar.xz"
      ];
      sha256 = "0xdw8mvyxz9vaxikzsj4ygzp36m4jfhvhqfiyaiiywpf39rqpkqr";
    };

    "i686-linux" = fetchurl {
      urls = [
        "https://github.com/TheTorProject/gettorbrowser/releases/download/v${version}/tor-browser-linux32-${version}_${lang}.tar.xz"
        "https://dist.torproject.org/torbrowser/${version}/tor-browser-linux32-${version}_${lang}.tar.xz"
      ];
      sha256 = "0m522i8zih5sj18dyzk9im7gmpmrbf96657v38m3pxn4ci38b83z";
    };
  };
in

stdenv.mkDerivation rec {
  name = "tor-browser-bundle-bin-${version}";
  inherit version;

  src = srcs."${stdenv.system}" or (throw "unsupported system: ${stdenv.system}");

  preferLocalBuild = true;
  allowSubstitutes = false;

  desktopItem = makeDesktopItem {
    name = "torbrowser";
    exec = "tor-browser";
    icon = "torbrowser";
    desktopName = "Tor Browser";
    genericName = "Web Browser";
    comment = meta.description;
    categories = "Network;WebBrowser;Security;";
  };

  buildCommand = ''
    # For convenience ...
    TBB_IN_STORE=$out/share/tor-browser
    interp=$(< $NIX_CC/nix-support/dynamic-linker)

    # Unpack & enter
    mkdir -p "$TBB_IN_STORE"
    tar xf "${src}" -C "$TBB_IN_STORE" --strip-components=2
    pushd "$TBB_IN_STORE"

    # Set ELF interpreter
    for exe in firefox TorBrowser/Tor/tor ; do
      patchelf --set-interpreter "$interp" "$exe"
    done

    # The final libPath.  Note, we could split this into firefoxLibPath
    # and torLibPath for accuracy, but this is more convenient ...
    libPath=${libPath}:$TBB_IN_STORE:$TBB_IN_STORE/TorBrowser/Tor

    # Fixup paths to pluggable transports.
    sed -i TorBrowser/Data/Tor/torrc-defaults \
        -e "s,./TorBrowser,$TBB_IN_STORE/TorBrowser,g"

    # Fixup obfs transport.  Work around patchelf failing to set
    # interpreter for pre-compiled Go binaries by invoking the interpreter
    # directly.
    sed -i TorBrowser/Data/Tor/torrc-defaults \
        -e "s|\(ClientTransportPlugin obfs2,obfs3,obfs4,scramblesuit\) exec|\1 exec $interp|" \

    # Fixup fte transport
    #
    # Note: the script adds its dirname to search path automatically
    sed -i TorBrowser/Tor/PluggableTransports/fteproxy.bin \
        -e "s,/usr/bin/env python,${python27.interpreter},"

    patchelf --set-rpath "${fteLibPath}" TorBrowser/Tor/PluggableTransports/fte/cDFA.so

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

    // Always update via Nixpkgs
    lockPref("app.update.auto", false);
    lockPref("app.update.enabled", false);
    lockPref("extensions.update.autoUpdateDefault", false);
    lockPref("extensions.update.enabled", false);
    lockPref("extensions.torbutton.versioncheck_enabled", false);

    // User should never change these.  Locking prevents these
    // values from being written to prefs.js, avoiding Store
    // path capture.
    lockPref("extensions.torlauncher.torrc-defaults_path", "$TBB_IN_STORE/TorBrowser/Data/Tor/torrc-defaults");
    lockPref("extensions.torlauncher.tor_path", "$TBB_IN_STORE/TorBrowser/Tor/tor");

    // Reset pref that captures store paths.
    clearPref("extensions.xpiState");

    // Stop obnoxious first-run redirection.
    lockPref("noscript.firstRunRedirection", false);

    // Insist on using IPC for communicating with Tor
    //
    // Defaults to creating $TBB_HOME/TorBrowser/Data/Tor/{socks,control}.socket
    lockPref("extensions.torlauncher.control_port_use_ipc", true);
    lockPref("extensions.torlauncher.socks_port_use_ipc", true);
    EOF

    # Hard-code path to TBB fonts; see also FONTCONFIG_FILE in
    # the wrapper below.
    FONTCONFIG_FILE=$TBB_IN_STORE/TorBrowser/Data/fontconfig/fonts.conf
    sed -i "$FONTCONFIG_FILE" \
        -e "s,<dir>fonts</dir>,<dir>$TBB_IN_STORE/fonts</dir>,"

    # Move default extension overrides into distribution dir, to avoid
    # having to synchronize between local state and store.
    mv TorBrowser/Data/Browser/profile.default/preferences/extension-overrides.js defaults/pref/torbrowser.js

    # Hard-code paths to geoip data files.  TBB resolves the geoip files
    # relative to torrc-defaults_path but if we do not hard-code them
    # here, these paths end up being written to the torrc in the user's
    # state dir.
    cat >>TorBrowser/Data/Tor/torrc-defaults <<EOF
    GeoIPFile $TBB_IN_STORE/TorBrowser/Data/Tor/geoip
    GeoIPv6File $TBB_IN_STORE/TorBrowser/Data/Tor/geoip6
    EOF

    # Generate wrapper
    mkdir -p $out/bin
    cat > "$out/bin/tor-browser" << EOF
    #! ${stdenv.shell}
    set -o errexit -o nounset

    # Enter local state directory.
    REAL_HOME=\$HOME
    TBB_HOME=\''${TBB_HOME:-''${XDG_DATA_HOME:-\$REAL_HOME/.local/share}/tor-browser}
    HOME=\$TBB_HOME

    mkdir -p "\$HOME"
    cd "\$HOME"

    # Initialize empty TBB local state directory hierarchy.  We
    # intentionally mirror the layout that TBB would see if executed from
    # the unpacked bundle dir.
    mkdir -p "\$HOME/TorBrowser" "\$HOME/TorBrowser/Data"

    # Initialize the Tor data directory.
    mkdir -p "\$HOME/TorBrowser/Data/Tor"

    # TBB will fail if ownership is too permissive
    chmod 0700 "\$HOME/TorBrowser/Data/Tor"

    # Initialize the browser profile state.  Note that the only data
    # copied from the Store payload is the initial bookmark file, which is
    # never updated once created.  All other files under user's profile
    # dir are generated by TBB.
    mkdir -p "\$HOME/TorBrowser/Data/Browser/profile.default"
    cp -u --no-preserve=mode,owner "$TBB_IN_STORE/TorBrowser/Data/Browser/profile.default/bookmarks.html" \
      "\$HOME/TorBrowser/Data/Browser/profile.default/bookmarks.html"

    # Clear out some files that tend to capture store references but are
    # easily generated by firefox at startup.
    rm -f "\$HOME/TorBrowser/Data/Browser/profile.default"/{compatibility.ini,extensions.ini,extensions.json}

    # Ensure that we're always using the up-to-date extensions.
    ln -snf "$TBB_IN_STORE/TorBrowser/Data/Browser/profile.default/extensions" \
      "\$HOME/TorBrowser/Data/Browser/profile.default/extensions"

    ${optionalString pulseaudioSupport ''
      # Figure out some envvars for pulseaudio
      : "\''${XDG_RUNTIME_DIR:=/run/user/\$(id -u)}"
      : "\''${XDG_CONFIG_HOME:=\$REAL_HOME/.config}"
      : "\''${PULSE_SERVER:=\$XDG_RUNTIME_DIR/pulse/native}"
      : "\''${PULSE_COOKIE:=\$XDG_CONFIG_HOME/pulse/cookie}"
    ''}

    # Font cache files capture store paths; clear them out on the off
    # chance that TBB would continue using old font files.
    rm -rf "\$HOME/.cache/fontconfig"

    # Lift-off
    #
    # XAUTHORITY and DISPLAY are required for TBB to work at all.
    #
    # DBUS_SESSION_BUS_ADDRESS is inherited to avoid auto-launch; to
    # prevent that, set it to an empty/invalid value prior to running
    # tor-browser.
    #
    # PULSE_SERVER is necessary for audio playback.
    #
    # Setting FONTCONFIG_FILE is required to make fontconfig read the TBB
    # fonts.conf; upstream uses FONTCONFIG_PATH, but FC_DEBUG=1024
    # indicates the system fonts.conf being used instead.
    exec env -i \
      HOME="\$HOME" \
      XAUTHORITY="\$XAUTHORITY" \
      DISPLAY="\$DISPLAY" \
      DBUS_SESSION_BUS_ADDRESS="\$DBUS_SESSION_BUS_ADDRESS" \
      \
      PULSE_SERVER="\''${PULSE_SERVER:-}" \
      PULSE_COOKIE="\''${PULSE_COOKIE:-}" \
      \
      GST_PLUGIN_SYSTEM_PATH="${optionalString mediaSupport gstPluginsPath}" \
      GST_REGISTRY="/dev/null" \
      GST_REGISTRY_UPDATE="no" \
      \
      FONTCONFIG_FILE="$FONTCONFIG_FILE" \
      \
      LD_LIBRARY_PATH="$libPath" \
      \
      "$TBB_IN_STORE/firefox" \
        --class "Tor Browser" \
        -no-remote \
        -profile "\$HOME/TorBrowser/Data/Browser/profile.default" \
        "\''${@}"
    EOF
    chmod +x $out/bin/tor-browser

    # Easier access to docs
    mkdir -p $out/share/doc
    ln -s $TBB_IN_STORE/TorBrowser/Docs $out/share/doc/tor-browser

    # Install .desktop item
    mkdir -p $out/share/applications
    cp $desktopItem/share/applications"/"* $out/share/applications
    sed -i $out/share/applications/torbrowser.desktop \
        -e "s,Exec=.*,Exec=$out/bin/tor-browser,"

    # Install icons
    mkdir -p $out/share/pixmaps
    cp browser/icons/mozicon128.png $out/share/pixmaps/torbrowser.png

    # Check installed apps
    echo "Checking bundled Tor ..."
    LD_LIBRARY_PATH=$libPath $TBB_IN_STORE/TorBrowser/Tor/tor --version >/dev/null

    echo "Checking tor-browser wrapper ..."
    DISPLAY="" XAUTHORITY="" DBUS_SESSION_BUS_ADDRESS="" TBB_HOME=$(mktemp -d) \
      $out/bin/tor-browser --version >/dev/null
  '';

  meta = with stdenv.lib; {
    description = "Tor Browser Bundle";
    homepage = https://www.torproject.org/;
    platforms = attrNames srcs;
    maintainers = with maintainers; [ offline matejc doublec thoughtpolice joachifm ];
    hydraPlatforms = [];
    # MPL2.0+, GPL+, &c.  While it's not entirely clear whether
    # the compound is "libre" in a strict sense (some components place certain
    # restrictions on redistribution), it's free enough for our purposes.
    license = licenses.free;
  };
}
