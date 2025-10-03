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
    version = "2025.1.3.7"; # "Android Studio Narwhal 3 Feature Drop | 2025.1.3"
    sha256Hash = "sha256-pet3uTmL4pQ/FxB2qKv+IZNx540gMC7hmfOaQ8iLQpQ=";
  };
  betaVersion = {
    version = "2025.1.3.6"; # "Android Studio Narwhal 3 Feature Drop | 2025.1.3 RC 2"
    sha256Hash = "sha256-S8KK/EGev0v03fVywIkD6Ym3LrciGKXJVorzyZ1ljdQ=";
  };
  latestVersion = {
    version = "2025.2.1.3"; # "Android Studio Otter | 2025.2.1 Canary 3"
    sha256Hash = "sha256-McgPREXfErJ6vcHPKlAC4EVf61QedMV6J643LM5N7Wg=";
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
