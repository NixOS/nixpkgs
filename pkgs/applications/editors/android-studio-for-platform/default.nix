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
    version = "2025.3.2.6";
    versionPrefix = "Panda%202";
    sha256Hash = "sha256-mAJPmDSoE9STOh45u0dIejL4TyR8CIqcGMhiixIFIWc=";
  };
  canaryVersion = {
    version = "2026.1.2.1";
    versionPrefix = "canary-Quail%202";
    sha256Hash = "sha256-UYj+6CSmtxC11HVjPxc+m9r6b5RrXXFOzpDfSkx4mw4=";
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
