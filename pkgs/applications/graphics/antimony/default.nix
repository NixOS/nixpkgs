{ stdenv, fetchFromGitHub, libpng, python3
, libGLU_combined, qtbase, ncurses
, cmake, flex, lemon
}:

let
  gitRev    = "60a58688e552f12501980c4bdab034ab0f2ba059";
  gitBranch = "develop";
  gitTag    = "0.9.3";
in
  stdenv.mkDerivation rec {
    name    = "antimony-${version}";
    version = "2018-07-17";

    src = fetchFromGitHub {
      owner  = "mkeeter";
      repo   = "antimony";
      rev    = gitRev;
      sha256 = "0pgf6kr23xw012xsil56j5gq78mlirmrlqdm09m5wlgcf4vr6xnl";
    };

    patches = [ ./paths-fix.patch ];

    postPatch = ''
       sed -i "s,/usr/local,$out,g" \
       app/CMakeLists.txt app/app/app.cpp app/app/main.cpp
       sed -i "s,python-py35,python36," CMakeLists.txt
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
