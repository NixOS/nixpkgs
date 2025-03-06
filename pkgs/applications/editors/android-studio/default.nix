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
    version = "2024.3.1.13"; # "Android Studio Meerkat | 2024.3.1"
    sha256Hash = "sha256-4zJeoD5Fd4KgCt/oNzxhBwYeHuHBgmmAeFTIfZCElRA=";
  };
  betaVersion = {
    version = "2024.3.1.12"; # "Android Studio Meerkat | 2024.3.1 RC 2"
    sha256Hash = "sha256-gi7kaB4cPnnYqHJcoeKdQ6+InIzW1kaX5kBuKR48u+Q=";
  };
  latestVersion = {
    version = "2024.3.2.7"; # "Android Studio Meerkat Feature Drop | 2024.3.2 Canary 7"
    sha256Hash = "sha256-RENjqoPdq3iYrF1q8QcjrXVBG8xNQrV+Vq9dj0Z/Im8=";
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
