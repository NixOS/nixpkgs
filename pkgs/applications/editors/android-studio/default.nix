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
    version = "2020.3.1.26"; # "Android Studio Arctic Fox (2020.3.1)"
    sha256Hash = "NE2FgjXtXTCVrCWRakqPhzAGn3blpf0OugJSKviPVBs=";
  };
  betaVersion = {
    version = "2021.1.1.18"; # "Android Studio Bumblebee (2021.1.1) Beta 5"
    sha256Hash = "gWG8h3wTQDH84vSKlfTm3soUqLkwFYfSymJuAAFPDuQ=";
  };
  latestVersion = { # canary & dev
    version = "2021.2.1.5"; # "Android Studio Chipmunk (2021.2.1) Canary 5"
    sha256Hash = "PS45nu5g9qXNeolYnFEs//Z6p8eIZoD6kUo/0yfHQ6A=";
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
