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
    version = "2024.3.1.14"; # "Android Studio Meerkat | 2024.3.1 Patch 1"
    sha256Hash = "sha256-VNXErfb4PhljcJwGq863ldh/3i8fMdJirlwolEIk+fI=";
  };
  betaVersion = {
    version = "2024.3.2.10"; # "Android Studio Meerkat Feature Drop | 2024.3.2 RC 1"
    sha256Hash = "sha256-r5YBpACLzfmChY9ORyvDUNl4j8r32dsqj3W7fbSWZU8=";
  };
  latestVersion = {
    version = "2025.1.1.4"; # "Android Studio Narwhal | 2025.1.1 Canary 4"
    sha256Hash = "sha256-PQe9JEi9Ogoo1hUgPVnCustFgg10v89gTMF7QGi4s1I=";
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
