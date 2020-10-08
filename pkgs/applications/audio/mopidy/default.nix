{ newScope, python }:

# Create a custom scope so we are consistent in which python version is used

let
  callPackage = newScope self;

  self = {

    inherit python;
    pythonPackages = python.pkgs;

    mopidy = callPackage ./mopidy.nix { };

    mopidy-gmusic = callPackage ./gmusic.nix { };

    mopidy-local-images = callPackage ./local-images.nix { };

    mopidy-local-sqlite = callPackage ./local-sqlite.nix { };

    mopidy-spotify = callPackage ./spotify.nix { };

    mopidy-moped = callPackage ./moped.nix { };

    mopidy-mopify = callPackage ./mopify.nix { };

    mopidy-mpd = callPackage ./mpd.nix { };

    mopidy-mpris = callPackage ./mpris.nix { };

    mopidy-somafm = callPackage ./somafm.nix { };

    mopidy-spotify-tunigo = callPackage ./spotify-tunigo.nix { };

    mopidy-youtube = callPackage ./youtube.nix { };

    mopidy-soundcloud = callPackage ./soundcloud.nix { };

    mopidy-musicbox-webclient = callPackage ./musicbox-webclient.nix { };

    mopidy-iris = callPackage ./iris.nix { };

    mopidy-tunein = callPackage ./tunein.nix { };

  };

in self
