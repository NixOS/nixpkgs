{ callPackage, makeFontsConf, gnome2, buildFHSUserEnv }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
    inherit buildFHSUserEnv;
  };
  stableVersion = {
    version = "2020.3.1.22"; # "Android Studio Arctic Fox (2020.3.1)"
    sha256Hash = "0xkjnhq1vvrglcbab90mx5xw1q82lkkvyp6y2ap5jypdfsc7pnsa";
  };
  betaVersion = {
    version = "2020.3.1.21"; # "Android Studio Arctic Fox (2020.3.1) RC 1"
    sha256Hash = "04k7c328bl8ixi8bvp2mm33q2hmv40yc9p5dff5cghyycarwpd3f";
  };
  latestVersion = { # canary & dev
    version = "2021.1.1.5"; # "Android Studio Bumblebee (2021.1.1) Canary 5"
    sha256Hash = "0fx6nnazg4548rhb11wzaccm5c2si57mj8qwyl5j17x4k5r3m7nh";
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
