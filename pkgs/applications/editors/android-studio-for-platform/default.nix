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
    version = "2024.2.2.13";
    # this seems to be a fuckup on google's side
    versionPrefix = "Ladybug%20Feature%20Drop";
    sha256Hash = "sha256-yMUTWOpYHa/Aizrgvs/mbofrDqrbL5bJYjuklIdyU/0=";
  };
  canaryVersion = {
    version = "2024.3.1.9";
    versionPrefix = "canary-meerkat";
    sha256Hash = "sha256-j5KEwHbc+0eFi3GZlD5PMuM/RWw2MJ1PaXZrPMvhCik=";
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
