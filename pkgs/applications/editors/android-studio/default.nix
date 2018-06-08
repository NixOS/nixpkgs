{ stdenv, callPackage, fetchurl, makeFontsConf, gnome2 }:

let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
    inherit (gnome2) GConf gnome_vfs;
  };
  stableVersion = {
    version = "3.1.3.0"; # "Android Studio 3.1.3"
    build = "173.4819257";
    sha256Hash = "196yaswbxh2nd83gimjxr8ggr5xkdxq7n3xlh6ax73v59pj4hryq";
  };
  latestVersion = {
    version = "3.2.0.15"; # "Android Studio 3.2 Canary 16"
    build = "181.4802120";
    sha256Hash = "0ch9jjq58k83dpnq65xyxchyik24w3fmh2v9q3kx1s028iavmpym";
  };
in rec {
  # Old alias
  preview = beta;

  # Attributes are named by the corresponding release channels

  stable = mkStudio (stableVersion // {
    pname = "android-studio";
    #pname = "android-studio-stable"; # TODO: Rename and provide symlink

    meta = with stdenv.lib; {
      description = "The Official IDE for Android (stable channel)";
      longDescription = ''
        Android Studio is the official IDE for Android app development, based on
        IntelliJ IDEA.
      '';
      homepage = https://developer.android.com/studio/index.html;
      license = licenses.asl20;
      platforms = [ "x86_64-linux" ];
      maintainers = with maintainers; [ primeos ];
    };
  });

  beta = mkStudio (stableVersion // {
    pname = "android-studio-preview";
    #pname = "android-studio-beta"; # TODO: Rename and provide symlink

    meta = stable.meta // {
      description = "The Official IDE for Android (beta channel)";
      homepage = https://developer.android.com/studio/preview/index.html;
    };
  });

  dev = mkStudio (latestVersion // {
    pname = "android-studio-dev";

    meta = beta.meta // {
      description = "The Official IDE for Android (dev channel)";
    };
  });

  canary = mkStudio (latestVersion // {
    pname = "android-studio-canary";

    meta = beta.meta // {
      description = "The Official IDE for Android (canary channel)";
    };
  });
}
