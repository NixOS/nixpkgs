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
    version = "4.1.1.0"; # "Android Studio 4.1.1"
    build = "201.6953283";
    sha256Hash = "sha256-aAMhhJWcVFdvEZt8fI3tF12Eg3TzlU+kUFMNeCYN1os=";
  };
  betaVersion = {
    version = "4.2.0.18"; # "Android Studio 4.2 Beta 2"
    build = "202.7008469";
    sha256Hash = "0323i4mcib84z7bsy801640gadd2k8ps7vr9jbdpb6i9gma6klmh";
  };
  latestVersion = { # canary & dev
    version = "2020.3.1.3"; # "Android Studio Arctic Fox Canary 3"
    sha256Hash = "1nx78j3pqr8qgwprnzfy17w9jmkgiqnlbsw91jnslr9p9fd0ixcx";
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
