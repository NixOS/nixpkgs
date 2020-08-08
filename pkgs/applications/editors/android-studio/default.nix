{ callPackage, makeFontsConf, gnome2 }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
  stableVersion = {
    version = "4.0.1.0"; # "Android Studio 4.0.1"
    build = "193.6626763";
    sha256Hash = "15vm7fvi8c286wx9f28z6ysvm8wqqda759qql0zy9simwx22gy7j";
  };
  betaVersion = {
    version = "4.1.0.15"; # "Android Studio 4.1 Beta 5"
    build = "201.6692364";
    sha256Hash = "16gn3yz6fld717slzhdpz49hpl4vi4bk0yda6z5gbnig1a6lh81q";
  };
  latestVersion = { # canary & dev
    version = "4.2.0.5"; # "Android Studio 4.2 Canary 5"
    build = "201.6682321";
    sha256Hash = "076q6d7kmi0wcsqak7n6ggp1qns4xj1134xcpdzb92qk3dmg3wrh";
  };
in {
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
