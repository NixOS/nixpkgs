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
    version = "2020.3.1.25"; # "Android Studio Arctic Fox (2020.3.1)"
    sha256Hash = "10gpwb130bzp6a9g958cjqcb2gsm0vdgm08nm5xy45xdh54nxjfg";
  };
  betaVersion = {
    version = "2021.1.1.14"; # "Android Studio Bumblebee (2021.1.1) Beta 1"
    sha256Hash = "1j1fxl4vzq3bln2z9ycxn9imjgy55yd1nbl7ycmsi90bdp96pzj0";
  };
  latestVersion = { # canary & dev
    version = "2021.2.1.2"; # "Android Studio Chipmunk (2021.2.1) Canary 2"
    sha256Hash = "0xvn9zgn4cc9lhjynhiavmvx8bdzg4kcllmhg7xv18kp6wz4lh6z";
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
