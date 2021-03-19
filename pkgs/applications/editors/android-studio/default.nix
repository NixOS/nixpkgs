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
    version = "4.1.3.0"; # "Android Studio 4.1.3"
    build = "201.7199119";
    sha256Hash = "06xwgk7bwcmljka8xa56cfwwg858r0bl0xp2jb9hdnkwljf796gm";
  };
  betaVersion = {
    version = "4.2.0.21"; # "Android Studio 4.2 Beta 5"
    build = "202.7141121";
    sha256Hash = "05610xf9zz3yxarx6fv83fynlvqw9jl7h2a40yj3xx5kb7mzdnf2";
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
