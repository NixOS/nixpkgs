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
    version = "2023.2.1.20"; # Android Studio Iguana | 2023.2.1 Beta 2
    sha256Hash = "sha256-cM/pkSghqLUUvJVF/OVLDOxVBJlJLH8ge1bfZtDUegY=";
  };
  canaryVersion = {
    version = "2023.3.2.1"; # Android Studio Jellyfish | 2023.3.2 Canary 1
    sha256Hash = "sha256-XOsbMyNentklfEp1k49H3uFeiRNMCV/Seisw9K1ganM=";
  };
in
{
  # Attributes are named by their corresponding release channels

  stable = mkStudio (
    stableVersion
    // {
      channel = "stable";
      pname = "android-studio-for-platform";
    }
  );

  canary = mkStudio (
    canaryVersion
    // {
      channel = "canary";
      pname = "android-studio-for-platform-canary";
    }
  );
}
