{ callPackage, makeFontsConf, gnome2 }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
  stableVersion = {
    version = "3.5.0.21"; # "Android Studio 3.5"
    build = "191.5791312";
    sha256Hash = "0vvk2vhklxg9wfi4lv4sahs5ahhb1mki1msy3yixmr56vipgv52p";
  };
  betaVersion = stableVersion;
  latestVersion = { # canary & dev
    version = "3.6.0.11"; # "Android Studio 3.6 Canary 11"
    build = "192.5863777";
    sha256Hash = "1wz4vcdj4225vffsq0ji4zgg9qaqlfd21x7c6nczhqvydbyrjzg8";
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
