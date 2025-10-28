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
    version = "2025.2.1.6"; # "Android Studio Otter | 2025.2.1 RC 1"
    sha256Hash = "sha256-l+bJ0AWIrJ3qNcKJWiE+onrl6ZpLb6YWFXE3HtIejUs=";
  };
  latestVersion = {
    version = "2025.2.2.1"; # "Android Studio Otter 2 Feature Drop | 2025.2.2 Canary 1"
    sha256Hash = "sha256-sSp9IpGpo7pE0x7C5wSmZiGKt2uLoUlNVh7NHF4j/N4=";
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
