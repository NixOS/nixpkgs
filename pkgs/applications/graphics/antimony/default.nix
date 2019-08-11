{ stdenv, fetchFromGitHub, libpng, python3
, libGLU_combined, qtbase, ncurses
, cmake, flex, lemon
}:

let
  gitRev    = "c0038e3ea82fec6119de364bcbc3370955ed46a2";
  gitBranch = "develop";
  gitTag    = "0.9.3";
in
  stdenv.mkDerivation rec {
    name    = "antimony-${version}";
    version = "2018-10-20";

    src = fetchFromGitHub {
      owner  = "mkeeter";
      repo   = "antimony";
      rev    = gitRev;
      sha256 = "01cjcjppbb0gvh6npcsaidzpfcfzrqhhi07z4v0jkfyi0fl125v4";
    };

    patches = [ ./paths-fix.patch ];

    postPatch = ''
       sed -i "s,/usr/local,$out,g" \
       app/CMakeLists.txt app/app/app.cpp app/app/main.cpp
       sed -i "s,python3,${python3.executable}," CMakeLists.txt
    '';

    buildInputs = [
      libpng python3 python3.pkgs.boost
      libGLU_combined qtbase ncurses
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
      homepage    = "https://github.com/mkeeter/antimony";
      license     = licenses.mit;
      maintainers = with maintainers; [ rnhmjoj ];
      platforms   = platforms.linux;
    };
  }
