{ callPackage, makeFontsConf, buildFHSEnv, tiling_wm ? false }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit buildFHSEnv;
    inherit tiling_wm;
  };
  stableVersion = {
    version = "2024.1.1.11"; # "Android Studio Koala | 2024.1.1"
    sha256Hash = "sha256-2PqOz+QVtEUTNQkBUB4qD0KcoDPPGAUFSxyBbEpwRWU=";
  };
  betaVersion = {
    version = "2024.1.2.9"; # "Android Studio Koala Feature Drop | 2024.1.2 Beta 1"
    sha256Hash = "sha256-eTnpU9KrquW4nMRqde9PUmVQ05kf6kFy1yr+Ima9M50=";
  };
  latestVersion = {
    version = "2024.1.2.8"; # "Android Studio Koala Feature Drop | 2024.1.2 Canary 8"
    sha256Hash = "sha256-2wqZV0UqZHprfUFvhWh0IdA9TQcwlZtWECZVwZ47ICc=";
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
