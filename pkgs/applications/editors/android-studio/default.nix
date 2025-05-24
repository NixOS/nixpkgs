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
    version = "2024.3.2.14"; # "Android Studio Meerkat Feature Drop | 2024.3.2"
    sha256Hash = "sha256-LHtPAJe4Zo2FcYwO0j51vt8QUNPQ2Dwf2UT7H72DyKU=";
  };
  betaVersion = {
    version = "2024.3.2.13"; # "Android Studio Meerkat Feature Drop | 2024.3.2 RC 4"
    sha256Hash = "sha256-tPRTDFyKGPR1DKuJRBcwjWjNxylS/8Zv/Nd6vBmcujg=";
  };
  latestVersion = {
    version = "2025.1.1.10"; # "Android Studio Narwhal | 2025.1.1 Canary 10"
    sha256Hash = "sha256-GKLOlDkA4hSbKeI3Oob3Pmfxq0ji+q2yTK/z2jPV8FU=";
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
