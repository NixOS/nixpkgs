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
    version = "2025.2.1.7"; # "Android Studio Otter | 2025.2.1"
    sha256Hash = "sha256-Fq8foC10bkwYLYhS/zhZu6XBgnaO/qz6GKi4HWXnjLE=";
  };
  betaVersion = {
    version = "2025.2.1.6"; # "Android Studio Otter | 2025.2.1 RC 1"
    sha256Hash = "sha256-l+bJ0AWIrJ3qNcKJWiE+onrl6ZpLb6YWFXE3HtIejUs=";
  };
  latestVersion = {
    version = "2025.2.3.1"; # "Android Studio Otter 3 Feature Drop | 2025.2.3 Canary 1"
    sha256Hash = "sha256-OHUKe2FBaxql3bS9kxrM8SSsSt6UpNYoZpkiPWfpafA=";
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
