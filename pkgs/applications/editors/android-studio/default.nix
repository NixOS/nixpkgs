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
    version = "2025.1.1.13"; # "Android Studio Narwhal | 2025.1.1"
    sha256Hash = "sha256-MEUqYZd/Ny2spzFqbZ40j2H4Tg6pHQGWqkpRrVtbwO8=";
  };
  betaVersion = {
    version = "2025.1.1.11"; # "Android Studio Narwhal | 2025.1.1 RC 1"
    sha256Hash = "sha256-upx+qcrd+E4XVV94iaqZPN8w1RpcD8KfV37397nkznU=";
  };
  latestVersion = {
    version = "2025.1.2.8"; # "Android Studio Narwhal Feature Drop | 2025.1.2 Canary 8"
    sha256Hash = "sha256-p7sIraR5MbFqr2svD1GKR71I0U1UDMkmAW4PAHjWyD4=";
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
