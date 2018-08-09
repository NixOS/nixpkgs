{ stdenv
, fetchgit
, fetchurl
, symlinkJoin

, tor
, tor-browser-unwrapped

# Wrapper runtime
, coreutils
, hicolor-icon-theme
, shared-mime-info
, noto-fonts
, noto-fonts-emoji

# Audio support
, audioSupport ? mediaSupport
, apulse

# Media support (implies audio support)
, mediaSupport ? false
, gstreamer
, gst-plugins-base
, gst-plugins-good
, gst-ffmpeg
, gmp
, ffmpeg

# Extensions, common
, zip

# HTTPS Everywhere
, git
, libxml2 # xmllint
, python27
, python27Packages
, rsync

# Pluggable transports
, obfsproxy

# Customization
, extraPrefs ? ""
, extraExtensions ? [ ]
}:

with stdenv.lib;

let
  tor-browser-build_src = fetchgit {
    url = "https://git.torproject.org/builders/tor-browser-build.git";
    rev = "refs/tags/tbb-7.5a5-build5";
    sha256 = "0j37mqldj33fnzghxifvy6v8vdwkcz0i4z81prww64md5s8qcsa9";
  };

  firefoxExtensions = import ./extensions.nix {
    inherit stdenv fetchurl fetchgit zip
      git libxml2 python27 python27Packages rsync;
  };

  bundledExtensions = with firefoxExtensions; [
    https-everywhere
    noscript
    torbutton
    tor-launcher
  ] ++ extraExtensions;

  fontsEnv = symlinkJoin {
    name = "tor-browser-fonts";
    paths = [ noto-fonts noto-fonts-emoji ];
  };

  fontsDir = "${fontsEnv}/share/fonts";

  gstPluginsPath = concatMapStringsSep ":" (x:
    "${x}/lib/gstreamer-0.10") [
      gstreamer
      gst-plugins-base
      gst-plugins-good
      gst-ffmpeg
    ];

  gstLibPath = makeLibraryPath [
    gstreamer
    gst-plugins-base
    gmp
    ffmpeg
  ];
in
stdenv.mkDerivation rec {
  name = "tor-browser-bundle-${version}";
  version = tor-browser-unwrapped.version;

  buildInputs = [ tor-browser-unwrapped tor ];

  unpackPhase = ":";

  buildPhase = ":";

  # The following creates a customized firefox distribution.  For
  # simplicity, we copy the entire base firefox runtime, to work around
  # firefox's annoying insistence on resolving the installation directory
  # relative to the real firefox executable.  A little tacky and
  # inefficient but it works.
  installPhase = ''
    TBBUILD=${tor-browser-build_src}/projects/tor-browser
    TBDATA_PATH=TorBrowser-Data

    self=$out/lib/tor-browser
    mkdir -p $self && cd $self

    TBDATA_IN_STORE=$self/$TBDATA_PATH

    cp -dR ${tor-browser-unwrapped}/lib"/"*"/"* .
    chmod -R +w .

    # Prepare for autoconfig
    cat >defaults/pref/autoconfig.js <<EOF
    pref("general.config.filename", "mozilla.cfg");
    pref("general.config.obscure_value", 0);
    EOF

    # Hardcoded configuration
    cat >mozilla.cfg <<EOF
    // First line must be a comment

    // Always update via Nixpkgs
    lockPref("app.update.auto", false);
    lockPref("app.update.enabled", false);
    lockPref("extensions.update.autoUpdateDefault", false);
    lockPref("extensions.update.enabled", false);
    lockPref("extensions.torbutton.updateNeeded", false);
    lockPref("extensions.torbutton.versioncheck_enabled", false);

    // Where to find the Nixpkgs tor executable & config
    lockPref("extensions.torlauncher.tor_path", "${tor}/bin/tor");
    lockPref("extensions.torlauncher.torrc-defaults_path", "$TBDATA_IN_STORE/torrc-defaults");

    // Captures store paths
    clearPref("extensions.xpiState");
    clearPref("extensions.bootstrappedAddons");

    // Insist on using IPC for communicating with Tor
    lockPref("extensions.torlauncher.control_port_use_ipc", true);
    lockPref("extensions.torlauncher.socks_port_use_ipc", true);

    // Allow sandbox access to sound devices if using ALSA directly
    ${if audioSupport then ''
      pref("security.sandbox.content.write_path_whitelist", "/dev/snd/");
    '' else ''
      clearPref("security.sandbox.content.write_path_whitelist");
    ''}

    // User customization
    ${extraPrefs}
    EOF

    # Preload extensions
    find ${toString bundledExtensions} -name '*.xpi' -exec ln -s -t browser/extensions '{}' '+'

    # Copy bundle data
    bundlePlatform=linux
    bundleData=$TBBUILD/Bundle-Data

    mkdir -p $TBDATA_PATH
    cat \
      $bundleData/$bundlePlatform/Data/Tor/torrc-defaults \
      >> $TBDATA_PATH/torrc-defaults
    cat \
      $bundleData/$bundlePlatform/Data/Browser/profile.default/preferences/extension-overrides.js \
      $bundleData/PTConfigs/bridge_prefs.js \
      >> defaults/pref/extension-overrides.js

    # Configure geoip
    #
    # tor-launcher insists on resolving geoip data relative to torrc-defaults
    # (and passes them directly on the tor command-line).
    #
    # Write the paths into torrc-defaults anyway, otherwise they'll be
    # captured in the runtime torrc.
    ln -s -t $TBDATA_PATH ${tor.geoip}/share/tor/geoip{,6}
    cat >>$TBDATA_PATH/torrc-defaults <<EOF
    GeoIPFile $TBDATA_IN_STORE/geoip
    GeoIPv6File $TBDATA_IN_STORE/geoip6
    EOF

    # Configure pluggable transports
    cat >>$TBDATA_PATH/torrc-defaults <<EOF
    ClientTransportPlugin obfs2,obfs3 exec ${obfsproxy}/bin/obfsproxy managed
    EOF

    # Hard-code path to TBB fonts; xref: FONTCONFIG_FILE in the wrapper below
    sed $bundleData/$bundlePlatform/Data/fontconfig/fonts.conf \
        -e "s,<dir>fonts</dir>,<dir>${fontsDir}</dir>," \
        > $TBDATA_PATH/fonts.conf

    # Generate a suitable wrapper
    wrapper_PATH=${makeBinPath [ coreutils ]}
    wrapper_XDG_DATA_DIRS=${concatMapStringsSep ":" (x: "${x}/share") [
      hicolor-icon-theme
      shared-mime-info
    ]}

    ${optionalString audioSupport ''
      # apulse uses a non-standard library path ...
      wrapper_LD_LIBRARY_PATH=${apulse}/lib/apulse''${wrapper_LD_LIBRARY_PATH:+:$wrapper_LD_LIBRARY_PATH}
    ''}

    ${optionalString mediaSupport ''
      wrapper_LD_LIBRARY_PATH=${gstLibPath}''${wrapper_LD_LIBRARY_PATH:+:$wrapper_LD_LIBRARY_PATH}
    ''}

    mkdir -p $out/bin
    cat >$out/bin/tor-browser <<EOF
    #! ${stdenv.shell} -eu

    umask 077

    PATH=$wrapper_PATH

    readonly THE_HOME=\$HOME
    TBB_HOME=\''${TBB_HOME:-\''${XDG_DATA_HOME:-\$HOME/.local/share}/tor-browser}
    if [[ \''${TBB_HOME:0:1} != / ]] ; then
      TBB_HOME=\$PWD/\$TBB_HOME
    fi
    readonly TBB_HOME

    # Basic sanity check: never want to vomit directly onto user's homedir
    if [[ "\$TBB_HOME" = "\$THE_HOME" ]] ; then
      echo 'TBB_HOME=\$HOME; refusing to run' >&2
      exit 1
    fi

    mkdir -p "\$TBB_HOME"

    HOME=\$TBB_HOME
    cd "\$HOME"

    # Re-init XDG basedir envvars
    XDG_CACHE_HOME=\$HOME/.cache
    XDG_CONFIG_HOME=\$HOME/.config
    XDG_DATA_HOME=\$HOME/.local/share

    # Initialize empty TBB runtime state directory hierarchy.  Mirror the
    # layout used by the official TBB, to avoid the hassle of working
    # against the assumptions made by tor-launcher & co.
    mkdir -p "\$HOME/TorBrowser" "\$HOME/TorBrowser/Data"

    # Initialize the Tor data directory.
    mkdir -p "\$HOME/TorBrowser/Data/Tor"

    # TBB fails if ownership is too permissive
    chmod 0700 "\$HOME/TorBrowser/Data/Tor"

    # Initialize the browser profile state.  Expect TBB to generate all data.
    mkdir -p "\$HOME/TorBrowser/Data/Browser/profile.default"

    # Files that capture store paths; re-generated by firefox at startup
    rm -rf "\$HOME/TorBrowser/Data/Browser/profile.default"/{compatibility.ini,extensions.ini,extensions.json,startupCache}

    # Clear out fontconfig caches
    rm -f "\$HOME/.cache/fontconfig/"*.cache-*

    # Lift-off!
    #
    # TZ is set to avoid stat()ing /etc/localtime over and over ...
    #
    # DBUS_SESSION_BUS_ADDRESS is inherited to avoid auto-launching a new
    # dbus instance; to prevent using the session bus, set the envvar to
    # an empty/invalid value prior to running tor-browser.
    #
    # FONTCONFIG_FILE is required to make fontconfig read the TBB
    # fonts.conf; upstream uses FONTCONFIG_PATH, but FC_DEBUG=1024
    # indicates the system fonts.conf being used instead.
    #
    # HOME, TMPDIR, XDG_*_HOME are set as a form of soft confinement;
    # ideally, tor-browser should not write to any path outside TBB_HOME
    # and should run even under strict confinement to TBB_HOME.
    #
    # XDG_DATA_DIRS is set to prevent searching system directories for
    # mime and icon data.
    #
    # PULSE_{SERVER,COOKIE} is necessary for audio playback w/pulseaudio
    #
    # APULSE_PLAYBACK_DEVICE is for audio playback w/o pulseaudio (no capture yet)
    #
    # GST_PLUGIN_SYSTEM_PATH is for HD video playback
    #
    # GST_REGISTRY is set to devnull to minimize disk writes
    #
    # TOR_* is for using an external tor instance
    #
    # Parameters lacking a default value below are *required* (enforced by
    # -o nounset).
    exec env -i \
      LD_LIBRARY_PATH=$wrapper_LD_LIBRARY_PATH \
      \
      TZ=":" \
      \
      DISPLAY="\$DISPLAY" \
      XAUTHORITY="\$XAUTHORITY" \
      DBUS_SESSION_BUS_ADDRESS="\$DBUS_SESSION_BUS_ADDRESS" \
      \
      HOME="\$HOME" \
      TMPDIR="\$XDG_CACHE_HOME/tmp" \
      XDG_CONFIG_HOME="\$XDG_CONFIG_HOME" \
      XDG_DATA_HOME="\$XDG_DATA_HOME" \
      XDG_CACHE_HOME="\$XDG_CACHE_HOME" \
      XDG_RUNTIME_DIR="\$HOME/run" \
      \
      XDG_DATA_DIRS="$wrapper_XDG_DATA_DIRS" \
      \
      FONTCONFIG_FILE="$TBDATA_IN_STORE/fonts.conf" \
      \
      APULSE_PLAYBACK_DEVICE="\''${APULSE_PLAYBACK_DEVICE:-plug:dmix}" \
      \
      GST_PLUGIN_SYSTEM_PATH="${optionalString mediaSupport gstPluginsPath}" \
      GST_REGISTRY="/dev/null" \
      GST_REGISTRY_UPDATE="no" \
      \
      TOR_SKIP_LAUNCH="\''${TOR_SKIP_LAUNCH:-}" \
      TOR_CONTROL_PORT="\''${TOR_CONTROL_PORT:-}" \
      TOR_SOCKS_PORT="\''${TOR_SOCKS_PORT:-}" \
      \
      $self/firefox \
        -no-remote \
        -profile "\$HOME/TorBrowser/Data/Browser/profile.default" \
        "\$@"
    EOF
    chmod +x $out/bin/tor-browser

    echo "Syntax checking wrapper ..."
    bash -n $out/bin/tor-browser

    echo "Checking wrapper ..."
    DISPLAY="" XAUTHORITY="" DBUS_SESSION_BUS_ADDRESS="" TBB_HOME=$(mktemp -d) \
    $out/bin/tor-browser -version >/dev/null
  '';

  passthru.execdir = "/bin";
  meta = with stdenv.lib; {
    description = "An unofficial version of the tor browser bundle, built from source";
    homepage = https://torproject.org/;
    license = licenses.free;
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [ ];
    maintainers = with maintainers; [ joachifm ];
  };
}
