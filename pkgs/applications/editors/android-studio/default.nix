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
    version = "3.6.0.12"; # "Android Studio 3.6 Canary 12"
    build = "192.5871855";
    sha256Hash = "0pxvpxqdxv37sl72p7gml70k6kl717k6avw9p0l00cys0zbvb3zq";
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
