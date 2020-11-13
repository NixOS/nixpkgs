{ lib
, buildFHSUserEnv
, fetchurl
, writers
, tor-browser-bundle-bin

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

}:

let
  lang = "en-US";
  inherit (tor-browser-bundle-bin.meta.passthru) src srcs version;

  # Bootstrapping script
  tor-browser-bootstrap = writers.writeBash "tor-browser-bootstrap" ''
    set -o errexit -o pipefail

    if ! [[ -v XDG_DATA_HOME || -v HOME ]]; then
      echo "Could not determine tor-browser home!"
      exit 1
    fi

    TBB_HOME=''${XDG_DATA_HOME:-"$HOME/.local/share"}/tor-browser-mutable

    # Copy the runtime if not present
    if ! [[ -f "$TBB_HOME/start-tor-browser" ]]; then
      mkdir -p "$TBB_HOME"
      tar xf "${src}" --strip-components=2 -C "$TBB_HOME"
    fi

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
    ] ++ lib.optionals pulseaudioSupport [
      libpulseaudio
      apulse
    ]
    # Media support (implies audio support)
    ++ lib.optionals mediaSupport [
      ffmpeg_3
    ]);

  runScript = if runScript != null then runScript else tor-browser-bootstrap;

  meta = {
    description = "Tor Browser Bundle built by torproject.org (self updating version)";
    longDescription = ''
      Tor Browser Bundle is a bundle of the Tor daemon, Tor Browser (heavily patched version of
      Firefox), several essential extensions for Tor Browser, and some tools that glue those
      together with a convenient UI.

      `tor-browser-bundle-mutable` package is a wrapper for the official version built by torproject.org.
      It will install the tor-browser bundle in a local prefix on first run, and set up a FHS compatible environment,
      which allows the browser to work on nix based systems.
    '';
    homepage = "https://www.torproject.org/";
    changelog = "https://gitweb.torproject.org/builders/tor-browser-build.git/plain/projects/tor-browser/Bundle-Data/Docs/ChangeLog.txt?h=maint-${version}";
    platforms = lib.attrNames srcs;
    maintainers = with lib.maintainers; [ xaverdh ];
    hydraPlatforms = [];
    # MPL2.0+, GPL+, &c.  While it's not entirely clear whether
    # the compound is "libre" in a strict sense (some components place certain
    # restrictions on redistribution), it's free enough for our purposes.
    license = lib.licenses.free;
  };

}
