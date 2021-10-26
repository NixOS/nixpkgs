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
    version = "2021.1.1.14"; # "Android Studio Bumblebee (2021.1.1) Beta 1"
    sha256Hash = "1j1fxl4vzq3bln2z9ycxn9imjgy55yd1nbl7ycmsi90bdp96pzj0";
  };
  latestVersion = { # canary & dev
    version = "2021.2.1.1"; # "Android Studio Chipmunk (2021.2.1) Canary 1"
    sha256Hash = "1fn0jv6ybgdhgpwhamw16fjqbg2961ir9jhbjzanysi7y3935nbv";
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
