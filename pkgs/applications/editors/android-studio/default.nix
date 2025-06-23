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
    version = "2024.3.2.15"; # "Android Studio Meerkat Feature Drop | 2024.3.2 Patch 1"
    sha256Hash = "sha256-L8s8l1/Q4AJEGvdzTLLu9sRZlkNyRDMQvK8moZXOeIE=";
  };
  betaVersion = {
    version = "2025.1.1.11"; # "Android Studio Narwhal | 2025.1.1 RC 1"
    sha256Hash = "sha256-upx+qcrd+E4XVV94iaqZPN8w1RpcD8KfV37397nkznU=";
  };
  latestVersion = {
    version = "2025.1.2.5"; # "Android Studio Narwhal Feature Drop | 2025.1.2 Canary 5"
    sha256Hash = "sha256-7GgWBwMrsGwqjodjBBQEFzT6MqJ+LgzP3emoS8HJjfE=";
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
