{  stdenv, callPackage, fetchurl, makeFontsConf }:
let
  mkStudio = opts: callPackage (import ./common.nix opts) {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
  };
in rec {
  stable = mkStudio rec {
    pname = "android-studio";
    version = "2.3.3.0";
    build = "162.4069837";
    sha256Hash = "0zzis9m2xp44xwkj0zvcqw5rh3iyd3finyi5nqhgira1fkacz0qk";

    meta = with stdenv.lib; {
      description = "The Official IDE for Android (stable version)";
      longDescription = ''
        Android Studio is the official IDE for Android app development, based on
        IntelliJ IDEA.
      '';
      homepage = https://developer.android.com/studio/index.html;
      license = licenses.asl20;
      platforms = [ "x86_64-linux" ];
      maintainers = with maintainers; [ primeos ];
    };
  };

  preview = mkStudio rec {
    pname = "android-studio-preview";
    version = "3.0.0.15"; # "Android Studio 3.0 Beta 7"
    build = "171.4365657";
    sha256Hash = "0am3rq0ag982ik95mpcxvx2zlv0h4l6747b29mlsbqih66868db6";

    meta = stable.meta // {
      description = "The Official IDE for Android (preview version)";
      homepage = https://developer.android.com/studio/preview/index.html;
      maintainers = with stdenv.lib.maintainers; [ primeos tomsmeets ];
    };
  };
}
