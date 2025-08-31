{
  callPackage,
  makeFontsConf,
  buildFHSEnv,
  tiling_wm ? false,
}:

let
  mkStudio =
    opts:
    callPackage (import ./common.nix opts) {
      fontsConf = makeFontsConf {
        fontDirectories = [ ];
      };
      inherit buildFHSEnv;
      inherit tiling_wm;
    };
  stableVersion = {
    version = "2025.1.2.12"; # "Android Studio Narwhal Feature Drop | 2025.1.2 Patch 1"
    sha256Hash = "sha256-fLjCbB9Wwrx7siYQTmtWvce+8TdYTea+y6HTtSTYWAY=";
  };
  betaVersion = {
    version = "2025.1.3.6"; # "Android Studio Narwhal 3 Feature Drop | 2025.1.3 RC 2"
    sha256Hash = "sha256-S8KK/EGev0v03fVywIkD6Ym3LrciGKXJVorzyZ1ljdQ=";
  };
  latestVersion = {
    version = "2025.1.4.3"; # "Android Studio Narwhal 4 Feature Drop | 2025.1.4 Canary 3"
    sha256Hash = "sha256-YYacdZ7YdmmrTSsKtCfmSSrrZV+/GGPK34KnlO0+aKQ=";
  };
in
{
  # Attributes are named by their corresponding release channels

  stable = mkStudio (
    stableVersion
    // {
      channel = "stable";
      pname = "android-studio";
    }
  );

  beta = mkStudio (
    betaVersion
    // {
      channel = "beta";
      pname = "android-studio-beta";
    }
  );

  dev = mkStudio (
    latestVersion
    // {
      channel = "dev";
      pname = "android-studio-dev";
    }
  );

  canary = mkStudio (
    latestVersion
    // {
      channel = "canary";
      pname = "android-studio-canary";
    }
  );
}
