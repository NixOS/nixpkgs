{ lib
, hostPlatform
, buildFHSUserEnv
, fetchurl
, writers
, writeText

# For XDG_DATA_DIRS
, gnome3 # .adwaita-icon-theme
, shared-mime-info
, glib
, gsettings-desktop-schemas
, gtk3


# override the bootstrapping script, useful for debugging
, runScript ? null

, audioSupport ? mediaSupport
, pulseaudioSupport ? false
# Media support (implies audio support)
, mediaSupport ? true

# Hardening
, graphene-hardened-malloc
# crashes with intel driver
, useHardenedMalloc ? false

# Extra preferences
, extraPrefs ? null
}:

let
  # Upstream source
  version = "10.0.2";

  lang = "en-US";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://dist.torproject.org/torbrowser/${version}/tor-browser-linux64-${version}_${lang}.tar.xz";
      sha256 = "sha256-JBJDMC44VSh1ekXPxsVvFk5nOB8Ro4UGtD32pG1weP8=";
    };

    i686-linux = fetchurl {
      url = "https://dist.torproject.org/torbrowser/${version}/tor-browser-linux32-${version}_${lang}.tar.xz";
      sha256 = "sha256-EanW2Q8TtCPY5FSp8zfgBXMte9+RfKE24fu8ROtArK0=";
    };
  };

  src = srcs.${hostPlatform.system} or (throw "unsupported system: ${hostPlatform.system}");

  # Bootstrapping script
  tor-browser-bootstrap = writers.writeBash "tor-browser-bootstrap" ''
    set -o errexit -o pipefail

    if ! [[ -v XDG_DATA_HOME || -v HOME ]]
    then
      echo "Could not determine tor-browser home!"
      exit 1
    fi

    TBB_HOME=''${XDG_DATA_HOME:-"$HOME/.local/share"}/tor-browser

    if ! [[ -f "$TBB_HOME/start-tor-browser" ]]
    then
      if [[ -d "$TBB_HOME/TorBrowser" ]]
      then
        # This is a old install from the previous nixpkgs wrapper, error out
        echo "Detected tor-browser installation from old nixpkgs, please back up your data and remove $TBB_HOME/TorBrowser manually."
        exit 2
      fi
      mkdir -p "$TBB_HOME"
      # Copy the runtime if not present
      tar xf "${src}" --strip-components=2 -C "$TBB_HOME"
    fi

    # Needed for using autoconfig
    # See https://developer.mozilla.org/en-US/Firefox/Enterprise_deployment
    cat >"$TBB_HOME/defaults/pref/autoconfig.js" <<EOF
    //
    pref("general.config.filename", "mozilla.cfg");
    pref("general.config.obscure_value", 0);
    EOF

    # Set up autoconfig prefs
    cat >"$TBB_HOME/mozilla.cfg" <<EOF
    // First line must be a comment
    // This is a generated file, do not edit by hand!
    EOF
    ${lib.optionalString (extraPrefs != null) ''
      cat ${extraPrefsFile} >> "$TBB_HOME/mozilla.cfg"
    ''}

    # Set up the environment
    ${lib.optionalString useHardenedMalloc ''
      export LD_PRELOAD="${graphene-hardened-malloc}/lib/libhardened_malloc.so"
    ''}

    XDG_DATA_DIRS=${lib.concatMapStringsSep ":" (x: "${x}/share") [
      gnome3.adwaita-icon-theme
      shared-mime-info
    ]}

    XDG_DATA_DIRS+=":"${lib.concatMapStringsSep ":" (x: "${x}/share/gsettings-schemas/${x.name}") [
      glib
      gsettings-desktop-schemas
      gtk3
    ]}

    exec -- "$TBB_HOME/start-tor-browser"

  '';

  extraPrefsFile = writeText "tor-browser-bundle-extraPrefs" extraPrefs;

in buildFHSUserEnv {
  name = "tor-browser";
  targetPkgs = (pkgs: with pkgs; [
      # libxul run-time dependencies
      zlib
      udev
      atk
      cairo
      dbus
      dbus-glib
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      xorg.libxcb
      xorg.libX11
      xorg.libXext
      xorg.libXrender
      xorg.libXt
      pango
    ]
    ++ lib.optionals pulseaudioSupport [
      libpulseaudio
      apulse
    ]
    # Media support (implies audio support)
    ++ lib.optionals mediaSupport [
      ffmpeg_3
    ]);
  runScript = if runScript != null then runScript else tor-browser-bootstrap;
  meta = {
    description = "Tor Browser Bundle built by torproject.org";
    longDescription = ''
      Tor Browser Bundle is a bundle of the Tor daemon, Tor Browser (heavily patched version of
      Firefox), several essential extensions for Tor Browser, and some tools that glue those
      together with a convenient UI.

      `tor-browser-bundle-bin` package is the official version built by torproject.org wrapped to work under nix.
    '';
    homepage = "https://www.torproject.org/";
    changelog = "https://gitweb.torproject.org/builders/tor-browser-build.git/plain/projects/tor-browser/Bundle-Data/Docs/ChangeLog.txt?h=maint-${version}";
    platforms = lib.attrNames srcs;
    maintainers = with lib.maintainers; [ offline matejc doublec thoughtpolice joachifm hax404 cap KarlJoad xaverdh ];
    hydraPlatforms = [];
    # MPL2.0+, GPL+, &c.  While it's not entirely clear whether
    # the compound is "libre" in a strict sense (some components place certain
    # restrictions on redistribution), it's free enough for our purposes.
    license = lib.licenses.free;
  };
}
