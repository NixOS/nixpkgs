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
    version = "4.0.1.0"; # "Android Studio 4.0.1"
    build = "193.6626763";
    sha256Hash = "15vm7fvi8c286wx9f28z6ysvm8wqqda759qql0zy9simwx22gy7j";
  };
  betaVersion = {
    version = "4.1.0.14"; # "Android Studio 4.1 Beta 4"
    build = "201.6667167";
    sha256Hash = "11lkwcbzdl86cyz4lci65cx9z5jjhrc4z40maqx2r5hw1xka9290";
  };
  latestVersion = { # canary & dev
    version = "4.2.0.7"; # "Android Studio 4.2 Canary 7"
    build = "201.6720134";
    sha256Hash = "1c9s6rd0z596qr7hbil5rl3fqby7c8h7ma52d1qj5rxra73k77nz";
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
