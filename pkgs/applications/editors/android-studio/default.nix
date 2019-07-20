{ callPackage, makeFontsConf, gnome2 }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
  stableVersion = {
    version = "3.4.2.0"; # "Android Studio 3.4.2"
    build = "183.5692245";
    sha256Hash = "090rc307mfm0yw4h592l9307lq4aas8zq0ci49csn6kxhds8rsrm";
  };
  betaVersion = {
    version = "3.5.0.18"; # "Android Studio 3.5 RC 1"
    build = "191.5717577";
    sha256Hash = "1p0w7xrfk33m1wvwnc3s3s7w9rm8wn9b3bjn566w2qpjv5ngdkn3";
  };
  latestVersion = { # canary & dev
    version = "3.6.0.3"; # "Android Studio 3.6 Canary 3"
    build = "191.5618338";
    sha256Hash = "0ryf61svn6ra8gh1rvfjqj3j282zmgcvkjvgfvql1wgkjlz21519";
  };
in rec {
  # Attributes are named by their corresponding release channels

  stable = mkStudio (stableVersion // {
    channel = "stable";
    pname = "android-studio";
  });

  beta = mkStudio (betaVersion // {
    channel = "beta";
    pname = "android-studio-beta";
  });

  dev = mkStudio (latestVersion // {
    channel = "dev";
    pname = "android-studio-dev";
  });

  canary = mkStudio (latestVersion // {
    channel = "canary";
    pname = "android-studio-canary";
  });
}
