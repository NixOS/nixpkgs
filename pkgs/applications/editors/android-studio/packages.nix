{  stdenv, callPackage, fetchurl, makeFontsConf }:
let
  mkStudio = opts: callPackage (import ./common.nix opts);
in rec {
  stable = mkStudio rec {
    pname = "android-studio";
    version = "2.3.3.0";
    build = "162.4069837";

    src = fetchurl {
      url = "https://dl.google.com/dl/android/studio/ide-zips/${version}/android-studio-ide-${build}-linux.zip";
      sha256 = "0zzis9m2xp44xwkj0zvcqw5rh3iyd3finyi5nqhgira1fkacz0qk";
    };

    meta = with stdenv.lib; {
      description = "The Official IDE for Android";
      homepage = https://developer.android.com/studio/index.html;
      license = licenses.asl20;
      platforms = [ "x86_64-linux" ];
      maintainers = with maintainers; [ primeos ];
    };
  } {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
  };

  preview = mkStudio rec {
    pname = "android-studio-preview";
    version = "3.0.0.7"; # This is actually "Android Studio 3.0 Canary 8"
    build = "171.4195411";

    src = fetchurl {
      url = "https://dl.google.com/dl/android/studio/ide-zips/${version}/android-studio-ide-${build}-linux.zip";
      sha256 = "1yzhr845shjq2cd5hcanppxmnj34ky9ry755y4ywf5f1w5ha5xzj";
    };

    meta = stable.meta // {
      homepage = https://developer.android.com/studio/preview/index.html;
      maintainers = with stdenv.lib.maintainers; [ tomsmeets ];
    };
  } {
    fontsConf = makeFontsConf {
      fontDirectories = [];
    };
  };
}
