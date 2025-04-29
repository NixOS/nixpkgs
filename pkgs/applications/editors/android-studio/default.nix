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
    version = "2024.3.1.15"; # "Android Studio Meerkat | 2024.3.1 Patch 2"
    sha256Hash = "sha256-Qo5H/fqJ28HigN8iQSIIqavDX9hnYuIDbpJfCgZfxiE=";
  };
  betaVersion = {
    version = "2024.3.2.12"; # "Android Studio Meerkat Feature Drop | 2024.3.2 RC 3"
    sha256Hash = "sha256-wmCPkYV88/OwuPqm10t3jT1x+cFRK+7Mgy683Au1P3g=";
  };
  latestVersion = {
    version = "2025.1.1.7"; # "Android Studio Narwhal | 2025.1.1 Canary 7"
    sha256Hash = "sha256-RQOmTzmk0el8WXE3cnSBCnpginFk0bK45Aij7eil1uM=";
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
