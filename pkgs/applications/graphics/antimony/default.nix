{ stdenv, fetchFromGitHub, libpng, python3
, libGLU, libGL, qtbase, wrapQtAppsHook, ncurses
, cmake, flex, lemon
}:

let
  gitRev    = "6dfe6822e0279a4cc2f1c60e85b42212627285fe";
  gitBranch = "develop";
  gitTag    = "0.9.3";
in
  stdenv.mkDerivation {
    pname = "antimony";
    version = "2019-10-30";

    src = fetchFromGitHub {
      owner  = "mkeeter";
      repo   = "antimony";
      rev    = gitRev;
      sha256 = "07zlkwlk79czq8dy85b6n3ds3g36l8qy4ix849ady6ia3gm8981j";
    };

    patches = [ ./paths-fix.patch ];

    postPatch = ''
       sed -i "s,/usr/local,$out,g" \
       app/CMakeLists.txt app/app/app.cpp app/app/main.cpp
       sed -i "s,python3,${python3.executable}," CMakeLists.txt
    '';

    buildInputs = [
      libpng python3 python3.pkgs.boost
      libGLU libGL qtbase wrapQtAppsHook
      ncurses
    ];

    nativeBuildInputs = [ cmake flex lemon ];

    cmakeFlags= [
      "-DGITREV=${gitRev}"
      "-DGITTAG=${gitTag}"
      "-DGITBRANCH=${gitBranch}"
    ];

    enableParallelBuilding = true;

    meta = with stdenv.lib; {
      description = "A computer-aided design (CAD) tool from a parallel universe";
      homepage    = https://github.com/mkeeter/antimony;
      license     = licenses.mit;
      maintainers = with maintainers; [ rnhmjoj ];
      platforms   = platforms.linux;
    };
  }
