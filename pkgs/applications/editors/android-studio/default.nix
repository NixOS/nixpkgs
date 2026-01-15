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
    version = "2025.2.3.9"; # "Android Studio Otter 3 Feature Drop | 2025.2.3"
    sha256Hash = "sha256-mG6myss22nI/LIVQzM19jNPouLe7JEbTqL85u6+Rq8E=";
  };
  betaVersion = {
    version = "2025.2.3.7"; # "Android Studio Otter 3 Feature Drop | 2025.2.3 RC 2"
    sha256Hash = "sha256-d5BcAUkYV7O25wyoifiZxfUsANPxLa/QkuT9u1qqfP8=";
  };
  latestVersion = {
    version = "2025.3.1.2"; # "Android Studio Panda 1 | 2025.3.1 Canary 2"
    sha256Hash = "sha256-kgYPwMF/CypkCq4w/y+HnraNdPNHf53198x35S0i7OA=";
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
