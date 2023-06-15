{ lib
, fetchurl
, fftw
, gcc8Stdenv
, gfortran
, libGL
, libGLU
, tcl
, tk
, togl
, util-linux
, libXmu
}:

let
  bwidget = rec {
    ver = "1.9.13";
    tgz = "bwidget-${ver}.tar.gz";
    src = fetchurl {
      url = "mirror://sourceforge.net/projects/tcllib/files/BWidget/${ver}/${tgz}";
      hash = "sha256-dtj0IoDnFgJCGG0SQ3lJgw6r1QCabBT059ug9mFAOoE=";
    };
  };
in

gcc8Stdenv.mkDerivation rec {
  pname = "xcrysden";
  version = "1.6.2";

  src = fetchurl {
    url = "http://www.xcrysden.org/download/xcrysden-${version}.tar.gz";
    hash = "sha256-gRc27lmL7BpbQn/RDk4GOjDdfK2ulqQ6ULNs6QpPUD8=";
  };

  buildInputs = [
    fftw
    gfortran
    libGL
    libGLU
    tcl
    tk.dev
    togl
    libXmu
  ];

  configurePhase = ''
    runHook preConfigure

    # `bwidget` source code is required to build xcrysden.
    # If it is not existing, the build script tries to download it and fails.
    cp ${bwidget.src} external/src/${bwidget.tgz}

    cp system/Make.sys-shared Make.sys

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    make all

    runHook postBuild
  '';

  makeFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    description = "Crystalline and molecular structure visualisation program";
    homepage = "http://www.xcrysden.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ kayhide ];
    platforms = lib.platforms.unix;
  };
}
