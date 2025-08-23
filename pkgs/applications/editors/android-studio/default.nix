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
    version = "2025.1.2.11"; # "Android Studio Narwhal Feature Drop | 2025.1.2"
    sha256Hash = "sha256-jzh0xrEZU4zdlse8tlVV/uqBEz4lH2k2XSHd13d3vng=";
  };
  betaVersion = {
    version = "2025.1.3.5"; # "Android Studio Narwhal 3 Feature Drop | 2025.1.3 RC 1"
    sha256Hash = "sha256-3LkcpvuoUhY/kRpoqYnwfx1cdPvvdBMEFXtRLYmqTk4=";
  };
  latestVersion = {
    version = "2025.1.4.1"; # "Android Studio Narwhal 4 Feature Drop | 2025.1.4 Canary 1"
    sha256Hash = "sha256-OGnBf0LrfbN7WpO9skT8+ltAeKejyqHobxFvrzLp3EY=";
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
