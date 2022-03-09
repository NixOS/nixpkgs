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
    version = "2021.1.1.21"; # "Android Studio Bumblebee (2021.1.1 Patch 1)"
    sha256Hash = "PeMJIILfaunTlpR4EV76qQlTlZDcWoKes61qe9W9oqQ=";
  };
  betaVersion = {
    version = "2021.2.1.8"; # "Android Studio Chipmunk (2021.2.1) Beta 1"
    sha256Hash = "bPfs4kw7czG9CbEgrzn0bQXdT03jyqPVqtaIuVBFSmc=";
  };
  latestVersion = { # canary & dev
    version = "2021.3.1.1"; # "Android Studio Dolphin (2021.3.1) Canary 1"
    sha256Hash = "W3pNQBM7WdDScQo5b8q5Va5NTgl73uZu0ks/zDMb4aA=";
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
