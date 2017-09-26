{ stdenv
, lib
, fetchurl
, fetchgit
, symlinkJoin

, tor
, tor-browser-unwrapped

# Wrapper runtime
, coreutils
, hicolor_icon_theme
, shared_mime_info
, noto-fonts
, noto-fonts-emoji

# Extensions, common
, unzip
, zip

# HTTPS Everywhere
, git
, libxml2 # xmllint
, python27
, python27Packages
, rsync

# Customization
, extraPrefs ? ""
}:

let
  tor-browser-build_src = fetchgit {
    url = "https://git.torproject.org/builders/tor-browser-build.git";
    rev = "refs/tags/tbb-7.5a5-build5";
    sha256 = "0j37mqldj33fnzghxifvy6v8vdwkcz0i4z81prww64md5s8qcsa9";
  };

  # Each extension drv produces an output comprising an unpacked .xpi
  # named after the extension uuid, as it would appear under
  # `firefox/extensions'.
  firefoxExtensions = {
    https-everywhere = stdenv.mkDerivation rec {
      name = "https-everywhere-${version}";
      version = "5.2.21";

      extid = "https-everywhere-eff@eff.org";

      src = fetchgit {
        url = "https://git.torproject.org/https-everywhere.git";
        rev = "refs/tags/${version}";
        sha256 = "0z9madihh4b4z4blvfmh6w1hsv8afyi0x7b243nciq9r4w55xgfa";
      };

      nativeBuildInputs = [
        git
        libxml2 # xmllint
        python27
        python27Packages.lxml
        rsync
        unzip
        zip
      ];

      unpackPhase = ''
        cp -dR --no-preserve=mode "$src" src
        cd src
      '';

      # Beware: the build expects translations/ to be non-empty (which it
      # will be with submodules initialized).
      buildPhase = ''
        $shell ./makexpi.sh ${version} --no-recurse
      '';

      installPhase = ''
        mkdir $out
        unzip -d "$out/$extid" "pkg/https-everywhere-$version-eff.xpi"
      '';

      meta = {
        homepage = https://gitweb.torproject.org/https-everywhere.git/;
      };
    };

    noscript = stdenv.mkDerivation rec {
      name = "noscript-${version}";
      version = "5.0.10";

      extid = "{73a6fe31-595d-460b-a920-fcc0f8843232}";

      src = fetchurl {
        url = "https://secure.informaction.com/download/releases/noscript-${version}.xpi";
        sha256 = "18k5karbaj5mhd9cyjbqgik6044bw88rjalkh6anjanxbn503j6g";
      };

      nativeBuildInputs = [ unzip ];

      unpackPhase = ":";

      installPhase = ''
        mkdir $out
        unzip -d "$out/$extid" "$src"
      '';
    };

    torbutton = stdenv.mkDerivation rec {
      name = "torbutton-${version}";
      version = "1.9.8.1";

      extid = "torbutton@torproject.org";

      src = fetchgit {
        url = "https://git.torproject.org/torbutton.git";
        rev = "refs/tags/${version}";
        sha256 = "1amp0c9ky0a7fsa0bcbi6n6ginw7s2g3an4rj7kvc1lxmrcsm65l";
      };

      nativeBuildInputs = [ unzip zip ];

      unpackPhase = ''
        cp -dR --no-preserve=mode "$src" src
        cd src
      '';

      buildPhase = ''
        $shell ./makexpi.sh
      '';

      installPhase = ''
        mkdir $out
        unzip -d "$out/$extid" "pkg/torbutton-$version.xpi"
      '';

      meta = {
        homepage = https://gitweb.torproject.org/torbutton.git/;
      };
    };

    tor-launcher = stdenv.mkDerivation rec {
      name = "tor-launcher-${version}";
      version = "0.2.12.3";

      extid = "tor-launcher@torproject.org";

      src = fetchgit {
        url = "https://git.torproject.org/tor-launcher.git";
        rev = "refs/tags/${version}";
        sha256 = "0126x48pjiy2zm4l8jzhk70w24hviaz560ffp4lb9x0ar615bc9q";
      };

      nativeBuildInputs = [ unzip zip ];

      unpackPhase = ''
        cp -dR --no-preserve=mode "$src" src
        cd src
      '';

      buildPhase = ''
        make package
      '';

      installPhase = ''
        mkdir $out
        unzip -d "$out/$extid" "pkg/tor-launcher-$version.xpi"
      '';

      meta = {
        homepage = https://gitweb.torproject.org/tor-launcher.git/;
      };
    };
  };

  extensionsEnv = symlinkJoin {
    name = "tor-browser-extensions";
    paths = with firefoxExtensions; [ https-everywhere noscript torbutton tor-launcher ];
  };

  fontsEnv = symlinkJoin {
    name = "tor-browser-fonts";
    paths = [ noto-fonts noto-fonts-emoji ];
  };

  fontsDir = "${fontsEnv}/share/fonts";
in
stdenv.mkDerivation rec {
  name = "tor-browser-bundle-${version}";
  version = tor-browser-unwrapped.version;

  buildInputs = [ tor-browser-unwrapped tor ];

  unpackPhase = ":";

  buildPhase = ":";

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

    // User customization
    ${extraPrefs}
    EOF

    # Preload extensions
    # XXX: the fact that ln -s env browser/extensions fails, symlinkJoin seems a little redundant ...
    ln -s -t browser/extensions ${extensionsEnv}"/"*

    # Copy bundle data
    bundlePlatform=linux
    bundleData=$TBBUILD/Bundle-Data

    mkdir -p $TBDATA_PATH
    cat \
      $bundleData/$bundlePlatform/Data/Tor/torrc-defaults \
      >> $TBDATA_PATH/torrc-defaults
    cat \
      $bundleData/$bundlePlatform/Data/Browser/profile.default/preferences/extension-overrides.js \
      >> defaults/pref/extension-overrides.js

    # Hard-code path to TBB fonts; xref: FONTCONFIG_FILE in the wrapper below
    sed $bundleData/$bundlePlatform/Data/fontconfig/fonts.conf \
        -e "s,<dir>fonts</dir>,<dir>${fontsDir}</dir>," \
        > $TBDATA_PATH/fonts.conf

    # Generate a suitable wrapper
    wrapper_PATH=${lib.makeBinPath [ coreutils ]}
    wrapper_XDG_DATA_DIRS=${lib.concatMapStringsSep ":" (x: "${x}/share") [
      hicolor_icon_theme
      shared_mime_info
    ]}

    mkdir -p $out/bin
    cat >$out/bin/tor-browser <<EOF
    #! ${stdenv.shell} -eu

    PATH=$wrapper_PATH

    readonly THE_HOME=\$HOME
    TBB_HOME=\''${TBB_HOME:-\''${XDG_DATA_HOME:-$HOME/.local/share}/tor-browser}
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
    # Parameters lacking a default value below are *required* (enforced by
    # -o nounset).
    exec env -i \
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
      \
      XDG_DATA_DIRS="$wrapper_XDG_DATA_DIRS" \
      \
      FONTCONFIG_FILE="$TBDATA_IN_STORE/fonts.conf" \
      \
      $self/firefox \
        -no-remote \
        -profile "\$HOME/TorBrowser/Data/Browser/profile.default" \
        "\$@"
    EOF
    chmod +x $out/bin/tor-browser
  '';

  meta = with stdenv.lib; {
    description = "An unofficial version of the tor browser bundle, built from source";
    homepage = https://torproject.org/;
    license = licenses.unfreeRedistributable; # TODO: check this
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [ ];
    maintainers = with maintainers; [ joachifm ];
  };
}
