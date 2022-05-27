{ callPackage, makeFontsConf, gnome2, buildFHSUserEnv, tiling_wm ? false }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
    inherit buildFHSUserEnv;
    inherit tiling_wm;
  };
  stableVersion = {
    version = "2021.2.1.15"; # "Android Studio Chipmunk (2021.2.1) Patch 1"
    sha256Hash = "1gj50wqb9v23aajb0zysi1vmaz1p8g2a5xqn0mq22afxq3gy0600";
  };
  betaVersion = {
    version = "2021.3.1.10"; # "Android Studio Dolphin (2021.3.1) Beta 1"
    sha256Hash = "04d0vjw3icc60h1w58i71dicf905g17syz43sqbw6nd2ck5k139s";
  };
  latestVersion = { # canary & dev
    version = "2021.3.1.9"; # "Android Studio Dolphin (2021.3.1) Canary 9"
    sha256Hash = "0nx26xwy67mnbkz37m3nw354siv152sa6zx94pxrvbnxxgppigfb";
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
