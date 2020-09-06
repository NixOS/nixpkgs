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
    version = "4.0.1.0"; # "Android Studio 4.0.1"
    build = "193.6626763";
    sha256Hash = "15vm7fvi8c286wx9f28z6ysvm8wqqda759qql0zy9simwx22gy7j";
  };
  betaVersion = {
    version = "4.1.0.17"; # "Android Studio 4.1 RC 2"
    build = "201.6776251";
    sha256Hash = "sha256-3W+eUcffRk7lZxbvf3X/Np4hkwAUqU51sQ061XR7Ddc=";
  };
  latestVersion = { # canary & dev
    version = "4.2.0.9"; # "Android Studio 4.2 Canary 9"
    build = "202.6795674";
    sha256Hash = "sha256-IL7jdGC7X8mr5eyh8YqD6z9WF8MO5AtFXVaUEf+ThiY=";
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
