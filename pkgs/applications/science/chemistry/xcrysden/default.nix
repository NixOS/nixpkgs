{ lib
, fetchurl
, fftw
, gcc8Stdenv
, gfortran
, libGL
, libGLU
, tcl
, tk
, util-linux
, libXmu
}:

let
  bwidget = rec {
    ver = "1.9.13";
    tgz = "bwidget-${ver}.tar.gz";
    src = fetchurl {
      url = "mirror://sourceforge.net/projects/tcllib/files/BWidget/${ver}/${tgz}";
      sha256 = "sha256-dtj0IoDnFgJCGG0SQ3lJgw6r1QCabBT059ug9mFAOoE=";
    };
  };

  togl = tcl.mkTclDerivation rec {
    pname = "togl";
    version = "2.0";

    src = fetchurl {
      url = "https://sourceforge.net/projects/togl/files/Togl/${version}/Togl${version}-src.tar.gz";
      sha256 = "sha256-t9SpC7rTrKYY1QXumef9j7BMgp9jIx3aI2D1V7o/dhA=";
    };

    postPatch = ''
      sed -i "s|\".*/generic/tclInt.h\"|\"${tcl}/include/tclInt.h\"|" configure
      sed -i "s|\".*/generic/tkInt.h\"|\"${tk.dev}/include/tkInt.h\"|" configure
    '';

    configureFlags = [
      "--with-tcl=${tcl}/lib"
      "--with-tk=${tk}/lib"
    ];

    buildInputs = [
      tcl
      tk.dev
      libGL
      xorg.libX11
      xorg.libXmu
    ];

    postInstall = ''
      ln -s $out/lib/Togl2.0/libTogl2.0.so $out/lib/libTogl.so
    '';
  };

in


gcc8Stdenv.mkDerivation rec {
  pname = "xcrysden";
  version = "1.6.2";

  src = fetchurl {
    url = "http://www.xcrysden.org/download/xcrysden-${version}.tar.gz";
    sha256 = "sha256-gRc27lmL7BpbQn/RDk4GOjDdfK2ulqQ6ULNs6QpPUD8=";
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
    # `bwidget` source code is required to build xcrysden.
    # If it is not existing, the build script tries to download it and fails.
    cp ${bwidget.src} external/src/${bwidget.tgz}

    cp system/Make.sys-shared Make.sys
  '';

  buildPhase = ''
    make all
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
