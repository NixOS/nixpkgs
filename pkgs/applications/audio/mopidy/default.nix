{
  lib,
  newScope,
  python,
  fetchpatch,
  gst_all_1,
  libsoup_3,
}:

# Create a custom scope so we are consistent in which python version is used
lib.makeScope newScope (
  self: with self; {
    inherit python;
    pythonPackages = python.pkgs;

    mopidy = callPackage ./mopidy.nix {

      # FIXME: remove when libsoup_3 gets a new release including this MR
      gst_all_1 = gst_all_1 // {
        gst-plugins-good = gst_all_1.gst-plugins-good.override {
          libsoup_3 = libsoup_3.overrideAttrs (old: {
            patches = old.patches or [ ] ++ [
              (fetchpatch {
                name = "gstreamer-deadlock-fix.patch";
                url = "https://gitlab.gnome.org/GNOME/libsoup/-/commit/2316e56a5502ac4c41ef4ff56a3266e680aca129.patch";
                hash = "sha256-6TOM6sygVPpBWjTNgFG37JFbJDl0t2f9Iwidvh/isa4=";
              })
            ];
          });
        };
      };

    };

    mopidy-bandcamp = callPackage ./bandcamp.nix { };

    mopidy-listenbrainz = callPackage ./listenbrainz.nix { };

    mopidy-iris = callPackage ./iris.nix { };

    mopidy-jellyfin = callPackage ./jellyfin.nix { };

    mopidy-local = callPackage ./local.nix { };

    mopidy-moped = callPackage ./moped.nix { };

    mopidy-mopify = callPackage ./mopify.nix { };

    mopidy-mpd = callPackage ./mpd.nix { };

    mopidy-mpris = callPackage ./mpris.nix { };

    mopidy-muse = callPackage ./muse.nix { };

    mopidy-musicbox-webclient = callPackage ./musicbox-webclient.nix { };

    mopidy-notify = callPackage ./notify.nix { };

    mopidy-podcast = callPackage ./podcast.nix { };

    mopidy-scrobbler = callPackage ./scrobbler.nix { };

    mopidy-somafm = callPackage ./somafm.nix { };

    mopidy-soundcloud = callPackage ./soundcloud.nix { };

    mopidy-spotify = callPackage ./spotify.nix { };

    mopidy-tidal = callPackage ./tidal.nix { };

    mopidy-tunein = callPackage ./tunein.nix { };

    mopidy-youtube = callPackage ./youtube.nix { };

    mopidy-ytmusic = callPackage ./ytmusic.nix { };

    mopidy-subidy = callPackage ./subidy.nix { };
  }
)
