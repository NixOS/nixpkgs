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
    version = "4.1.2.0"; # "Android Studio 4.1.2"
    build = "201.7042882";
    sha256Hash = "1f9bclvyvm3sg9an7wxlfwd8jwnb9cl726dvggmysa6r7shc7xw9";
  };
  betaVersion = {
    version = "4.2.0.19"; # "Android Studio 4.2 Beta 3"
    build = "202.7033425";
    sha256Hash = "037r99hn16y0fy6z6k90qf6yx5a4vvx6bl9rdyagdm16ry4bpiw4";
  };
  latestVersion = { # canary & dev
    version = "2020.3.1.4"; # "Android Studio Arctic Fox Canary 4"
    sha256Hash = "05drh4grq0b37qg5nspf2c6vmvcc9x71al3xwc2ddjhmyj0f9sk4";
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
