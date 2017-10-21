{ stdenv, fetchFromGitHub, libpng, python3, boost, mesa, qtbase, ncurses, cmake, flex, lemon }:

let
  gitRev    = "e8480c718e8c49ae3cc2d7af10ea93ea4c2fff9a";
  gitBranch = "master";
  gitTag    = "0.9.2";
in 
  stdenv.mkDerivation rec {
    name    = "antimony-${version}";
    version = gitTag;

    src = fetchFromGitHub {
      owner = "mkeeter";
      repo = "antimony";
      rev = gitTag;
      sha256 = "0fpgy5cb4knz2z9q078206k8wzxfs8b9g76mf4bz1ic77931ykjz";
    };

    patches = [ ./paths-fix.patch ];

    postPatch = ''
       sed -i "s,/usr/local,$out,g" app/CMakeLists.txt app/app/app.cpp app/app/main.cpp
    '';

    buildInputs = [
      libpng python3 (boost.override { python = python3; })
      mesa qtbase ncurses
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
      platforms   = platforms.linux;
    };
  }
