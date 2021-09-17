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
    version = "2020.3.1.24"; # "Android Studio Arctic Fox (2020.3.1)"
    sha256Hash = "0k8jcq8vpjayvwm9wqcrjhnp7dly0h4bb8nxspck5zmi8q2ar67l";
  };
  betaVersion = {
    version = "2020.3.1.21"; # "Android Studio Arctic Fox (2020.3.1) RC 1"
    sha256Hash = "04k7c328bl8ixi8bvp2mm33q2hmv40yc9p5dff5cghyycarwpd3f";
  };
  latestVersion = { # canary & dev
    version = "2021.1.1.12"; # "Android Studio Bumblebee (2021.1.1) Canary 12"
    sha256Hash = "1dyn9435s0xbxwj28b0cciz6ry58pgfgba4rbny3jszxi5j3j0r1";
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
