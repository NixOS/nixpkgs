{ callPackage, makeFontsConf, gnome2 }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
  stableVersion = {
    version = "3.5.1.0"; # "Android Studio 3.5.1"
    build = "191.5900203";
    sha256Hash = "0afxlif8pkrl6m1lhiqri1qv4vf5mfm1yg6qk5rad0442hm3kz4l";
  };
  betaVersion = {
    version = "3.6.0.13"; # "Android Studio 3.6 Beta 1"
    build = "192.5916306";
    sha256Hash = "0kvz3mgpfb3wqr1pw9847d5syswlzls3b4nilzgk6w127k2zmkfy";
  };
  latestVersion = { # canary & dev
    version = "4.0.0.1"; # "Android Studio 4.0 Canary 1"
    build = "192.5959023";
    sha256Hash = "1d9hvyk0wnfiip1612ci4sbw58rq93cyy026cx6s33rvjk3cwfrl";
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
