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
    version = "3.6.0.7"; # "Android Studio 3.6 Canary 7"
    build = "192.5807797";
    sha256Hash = "1l47miiyd8z7v0hbvda06953pp9ilyrsma83gxqx35ghnc0n7g81";
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
