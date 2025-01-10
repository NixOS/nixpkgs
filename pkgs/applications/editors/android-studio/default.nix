{ callPackage, makeFontsConf, buildFHSEnv, tiling_wm ? false }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit buildFHSEnv;
    inherit tiling_wm;
  };
  stableVersion = {
    version = "2024.2.1.12"; # "Android Studio Ladybug | 2024.2.1 Patch 3"
    sha256Hash = "sha256-TfUax9c+RSAzg0GKU3yVYsWL72q4DUB0zZiss4flyqY=";
  };
  betaVersion = {
    version = "2024.2.2.12"; # "Android Studio Ladybug Feature Drop | 2024.2.2 RC 2"
    sha256Hash = "sha256-zfiTjyD2bMIJ+GVQyg7qUT7306roqYsdRkPECZ/Rdnc=";
  };
  latestVersion = {
    version = "2024.3.1.6"; # "Android Studio Meerkat | 2024.3.1 Canary 6"
    sha256Hash = "sha256-2b2Fp5bjCRT/1f4JUkHkA9PBHM2umwQ9nObevcVYFSw=";
  };
in {
  # Attributes are named by their corresponding release channels

  stable = mkStudio (stableVersion // {
    channel = "stable";
    pname = "android-studio";
  });

  beta = mkStudio (betaVersion // {
    channel = "beta";
    pname = "android-studio-beta";
  });

  dev = mkStudio (latestVersion // {
    channel = "dev";
    pname = "android-studio-dev";
  });

  canary = mkStudio (latestVersion // {
    channel = "canary";
    pname = "android-studio-canary";
  });
}
