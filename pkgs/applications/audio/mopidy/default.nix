{ lib, newScope, python }:

# Create a custom scope so we are consistent in which python version is used
lib.makeScope newScope (self: with self; {
  inherit python;
  pythonPackages = python.pkgs;

  mopidy = callPackage ./mopidy.nix { };

  mopidy-iris = callPackage ./iris.nix { };

  mopidy-jellyfin = callPackage ./jellyfin.nix { };

  mopidy-local = callPackage ./local.nix { };

  mopidy-moped = callPackage ./moped.nix { };

  mopidy-mopify = callPackage ./mopify.nix { };

  mopidy-mpd = callPackage ./mpd.nix { };

  mopidy-mpris = callPackage ./mpris.nix { };

  mopidy-muse = callPackage ./muse.nix { };

  mopidy-musicbox-webclient = callPackage ./musicbox-webclient.nix { };

  mopidy-podcast = callPackage ./podcast.nix { };

  mopidy-scrobbler = callPackage ./scrobbler.nix { };

  mopidy-somafm = callPackage ./somafm.nix { };

  mopidy-soundcloud = callPackage ./soundcloud.nix { };

  mopidy-tunein = callPackage ./tunein.nix { };

  mopidy-youtube = callPackage ./youtube.nix { };

  mopidy-ytmusic = callPackage ./ytmusic.nix { };

  mopidy-subidy = callPackage ./subidy.nix { };
})
