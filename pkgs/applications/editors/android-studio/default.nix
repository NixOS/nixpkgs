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
    version = "2024.1.2.12"; # "Android Studio Koala Feature Drop | 2024.1.2"
    sha256Hash = "sha256-dFFogg6YmpCF/4QtR85UFAfbCd97irIHcPbqieQabpI=";
  };
  betaVersion = {
    version = "2024.2.1.7"; # "Android Studio Ladybug | 2024.2.1 Beta 2"
    sha256Hash = "sha256-YNUtRsKwXHfb7McJmTTT39/wW1rHjzw4kFQRwa12kJE=";
  };
  latestVersion = {
    version = "2024.2.2.2"; # "Android Studio Ladybug Feature Drop | 2024.2.2 Canary 2"
    sha256Hash = "sha256-TSjKJ4gAqZlycMP1or8MV+Il+KOQJL/F1kUKQr6/rSw=";
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
