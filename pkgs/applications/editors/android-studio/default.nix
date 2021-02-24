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
    version = "4.2.0.20"; # "Android Studio 4.2 Beta 4"
    build = "202.7094744";
    sha256Hash = "10c4qfq6d9ggs88s8h3pryhlnzw17m60qci78rjbh32wmm02sciz";
  };
  latestVersion = { # canary & dev
    version = "2020.3.1.7"; # "Android Studio Arctic Fox (2020.3.1) Canary 7"
    sha256Hash = "03gq4s8rmg7si0r2y1w26v9bjwhj6gzmrdny5z3j5pq8xsfjfqiw";
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
