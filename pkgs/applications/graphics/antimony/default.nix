{ stdenv, fetchFromGitHub, libpng, python3, boost, libGLU_combined, qtbase, ncurses, cmake, flex, lemon }:

let
  gitRev    = "020910c25614a3752383511ede5a1f5551a8bd39";
  gitBranch = "master";
  gitTag    = "0.9.3";
in
  stdenv.mkDerivation rec {
    name    = "antimony-${version}";
    version = gitTag;

    src = fetchFromGitHub {
      owner = "mkeeter";
      repo = "antimony";
      rev = gitTag;
      sha256 = "1vm5h5py8l3b8h4pbmm8s3wlxvlw492xfwnlwx0nvl0cjs8ba6r4";
    };

    patches = [ ./paths-fix.patch ];

    postPatch = ''
       sed -i "s,/usr/local,$out,g" app/CMakeLists.txt app/app/app.cpp app/app/main.cpp
    '';

    buildInputs = [
      libpng python3 (boost.override { python = python3; })
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
      platforms   = platforms.linux;
    };
  }
