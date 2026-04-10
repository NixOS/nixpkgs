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
    version = "2025.3.3.6"; # "Android Studio Panda 3 | 2025.3.3"
    sha256Hash = "sha256-NBrA/BfbyYfQUw4M+zJxJUgFM9ZzOoifITdja+zUhqU=";
    url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2025.3.3.6/android-studio-panda3-linux.tar.gz";
  };
  betaVersion = {
    version = "2025.3.3.5"; # "Android Studio Panda 3 | 2025.3.3 RC 1"
    sha256Hash = "sha256-lKpFKw2Oq7OlDrPjFJhMH3aQsJO7TeOKy7HGUCE0B1U=";
    url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2025.3.3.5/android-studio-panda3-rc1-linux.tar.gz";
  };
  latestVersion = {
    version = "2025.3.4.3"; # "Android Studio Panda 4 | 2025.3.4 Canary 3"
    sha256Hash = "sha256-8fqHdU6IPuRmcJeCZQOqUPgfild9k98sLnN77dl2Hs8=";
    url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2025.3.4.3/android-studio-panda4-canary3-linux.tar.gz";
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
