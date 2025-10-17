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
    version = "2025.1.4.8"; # "Android Studio Narwhal 4 Feature Drop | 2025.1.4"
    sha256Hash = "sha256-znRzVtUqNrLmpLYd9a96jFh85n+EgOsdteVLqxnMvfM=";
  };
  betaVersion = {
    version = "2025.1.4.7"; # "Android Studio Narwhal 4 Feature Drop | 2025.1.4 RC 2"
    sha256Hash = "sha256-KrKUsA7wFeI7IBa9VOp+MERqWIiMnNzLFO8oF0rCiIw=";
  };
  latestVersion = {
    version = "2025.2.1.5"; # "Android Studio Otter | 2025.2.1 Canary 5"
    sha256Hash = "sha256-Slpp29OMpG4i/9ykYBF/KMwnBgOTSuqObZrfdcMfDbQ=";
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
