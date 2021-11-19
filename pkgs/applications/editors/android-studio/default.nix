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
    version = "2021.1.1.16"; # "Android Studio Bumblebee (2021.1.1) Beta 3"
    sha256Hash = "pgmBWzq/5RHJTc41kzB43tbsjvrWx9BJ7UKsR8AO0V4=";
  };
  latestVersion = { # canary & dev
    version = "2021.2.1.3"; # "Android Studio Chipmunk (2021.2.1) Canary 3"
    sha256Hash = "sha256-xIVdM28NDadvJklDIw71iJ7Z5GPVJ1ZDJ+t1y+bt8cE=";
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
