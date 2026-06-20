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
    version = "2026.1.1.8"; # "Android Studio Quail 1 | 2026.1.1"
    sha256Hash = "sha256-DB+kujz6vQfkipDgCl+i6iqCzVhwgz2tpbApDIF9g9M=";
    url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.1.1.8/android-studio-quail1-linux.tar.gz";
  };
  betaVersion = {
    version = "2026.1.1.7"; # "Android Studio Quail 1 | 2026.1.1 RC 2"
    sha256Hash = "sha256-TB9hPynvVq1axv6oAw8un6WHVHakZPvEBjfPCs+Dwj0=";
    url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.1.1.7/android-studio-quail1-rc2-linux.tar.gz";
  };
  latestVersion = {
    version = "2026.1.2.7"; # "Android Studio Quail 2 | 2026.1.2 Canary 7"
    sha256Hash = "sha256-LHszfAtM5ZLNbTZG0isb+aUW3uwp+zav/igHT4HDeEM=";
    url = "https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.1.2.7/android-studio-quail2-canary7-linux.tar.gz";
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
