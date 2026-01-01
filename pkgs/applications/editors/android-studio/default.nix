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
<<<<<<< HEAD
    version = "2025.2.2.8"; # "Android Studio Otter 2 Feature Drop | 2025.2.2 Patch 1"
    sha256Hash = "sha256-xs9ABQ9f8/gtxcoiZkf/xEtmTOj6rb4Ty+w70/+C4Ss=";
  };
  betaVersion = {
    version = "2025.2.3.7"; # "Android Studio Otter 3 Feature Drop | 2025.2.3 RC 2"
    sha256Hash = "sha256-d5BcAUkYV7O25wyoifiZxfUsANPxLa/QkuT9u1qqfP8=";
  };
  latestVersion = {
    version = "2025.3.1.1"; # "Android Studio Panda 1 | 2025.3.1 Canary 1"
    sha256Hash = "sha256-hCWt8wMxqA4So/oZL6RzRRY3Kg6vAYr9xDAzQ/5ZXow=";
=======
    version = "2025.2.1.8"; # "Android Studio Otter | 2025.2.1 Patch 1"
    sha256Hash = "sha256-eqai5G60OH3vH06iK4tKK2gCHvqFBlNHxBGHQ5/SUJY=";
  };
  betaVersion = {
    version = "2025.2.2.6"; # "Android Studio Otter 2 Feature Drop | 2025.2.2 RC 2"
    sha256Hash = "sha256-ciu+To5Kcus8FPDz1D43AD+qOqfPHaW4JsEBr9fx2PE=";
  };
  latestVersion = {
    version = "2025.2.3.3"; # "Android Studio Otter 3 Feature Drop | 2025.2.3 Canary 3"
    sha256Hash = "sha256-cU6EFqmM1GsaWdGE1sbR/9eHXiYXKYV/m1/H0a+A1Bw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
