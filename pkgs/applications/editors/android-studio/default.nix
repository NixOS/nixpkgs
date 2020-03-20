{ callPackage, makeFontsConf, gnome2 }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
  stableVersion = {
    version = "3.6.1.0"; # "Android Studio 3.6.1"
    build = "192.6241897";
    sha256Hash = "1mwzk18224bl8hbw9cdxwzgj5cfain4y70q64cpj4p0snffxqm77";
  };
  betaVersion = {
    version = "4.0.0.11"; # "Android Studio 4.0 Beta 2"
    build = "193.6254973";
    sha256Hash = "0i4n5kxnfxnz3y44ba0x2j8nkmss4gchrzcdnb9wf6xc1jqrjwcm";
  };
  latestVersion = { # canary & dev
    version = "4.1.0.3"; # "Android Studio 4.1 Canary 3"
    build = "193.6297379";
    sha256Hash = "0sb8ll9bkkdglq18wvy5hikimhjbpfadjdygx9cd8q545h8dy137";
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
