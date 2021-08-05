{ callPackage, makeFontsConf, gnome2, buildFHSUserEnv }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
    inherit buildFHSUserEnv;
  };
  stableVersion = {
    version = "4.2.2.0"; # "Android Studio 4.2.2"
    build = "202.7486908";
    sha256Hash = "18zc9xr2xmphj6m6a1ilwripmvqzplp2583afq1pzzz3cv5h8fvk";
  };
  betaVersion = {
    version = "2020.3.1.21"; # "Android Studio Arctic Fox (2020.3.1) RC 1"
    sha256Hash = "04k7c328bl8ixi8bvp2mm33q2hmv40yc9p5dff5cghyycarwpd3f";
  };
  latestVersion = { # canary & dev
    version = "2021.1.1.4"; # "Android Studio Bumblebee (2021.1.1) Canary 4"
    sha256Hash = "0s2py7xikzryqrfd9v3in9ia9qv71dd9aad1nzbda6ff61inzizb";
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
