{ lib
, stdenv
, fetchurl
, fetchpatch
, cmake
, pcre
, pkg-config
, python2
, libX11
, libXpm
, libXft
, libXext
, libGLU
, libGL
, zlib
, libxml2
, lz4
, xz
, gsl_1
, xxHash
, Cocoa
, OpenGL
, noSplash ? false
}:

stdenv.mkDerivation rec {
  pname = "root";
  version = "5.34.38";

  src = fetchurl {
    url = "https://root.cern.ch/download/root_v${version}.source.tar.gz";
    sha256 = "1ln448lszw4d6jmbdphkr2plwxxlhmjkla48vmmq750xc1lxlfrc";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ pcre python2 zlib libxml2 lz4 xz gsl_1 xxHash ]
    ++ lib.optionals (!stdenv.isDarwin) [ libX11 libXpm libXft libXext libGLU libGL ]
    ++ lib.optionals (stdenv.isDarwin) [ Cocoa OpenGL ]
  ;

  patches = [
    ./sw_vers_root5.patch

    # prevents rootcint from looking in /usr/includes and such
    ./purify_include_paths_root5.patch

    # disable dictionary generation for stuff that includes libc headers
    # our glibc requires a modern compiler
    ./disable_libc_dicts_root5.patch

    (fetchpatch {
      name = "root5-gcc9-fix.patch";
      url = "https://github.com/root-project/root/commit/348f30a6a3b5905ef734a7bd318bc0ee8bca6dc9.diff";
      sha256 = "0dvrsrkpacyn5z87374swpy7aciv9a8s6m61b4iqd7a956r67rn3";
    })
    (fetchpatch {
      name = "root5-gcc10-fix.patch";
      url = "https://github.com/root-project/root/commit/3c243b18768d3c3501faf3ca4e4acfc071021350.diff";
      sha256 = "1hjmgnp4zx6im8ps78673x0rrhmfyy1nffhgxjlfl1r2z8cq210z";
    })
  ];

  preConfigure = ''
    # binutils 2.37 fixes
    fixupList=(
      cint/demo/gl/make0
      cint/demo/exception/Makefile
      cint/demo/makecint/KRcc/Makefile
      cint/demo/makecint/Stub2/Make2
      cint/demo/makecint/Array/Makefile
      cint/demo/makecint/DArray/Makefile
      cint/demo/makecint/ReadFile/Makefile
      cint/demo/makecint/stl/Makefile
      cint/demo/makecint/Stub2/Make1
      cint/cint/include/makemat
      cint/cint/lib/WildCard/Makefile
      cint/cint/include/make.arc
      cint/cint/lib/qt/Makefile
      cint/cint/lib/pthread/Makefile
      graf2d/asimage/src/libAfterImage/Makefile.in
    )
    for toFix in "''${fixupList[@]}"; do
      substituteInPlace "$toFix" --replace "clq" "cq"
    done

    patchShebangs build/unix/
    ln -s ${lib.getDev stdenv.cc.libc}/include/AvailabilityMacros.h cint/cint/include/

    # __malloc_hook is deprecated
    substituteInPlace misc/memstat/src/TMemStatHook.cxx \
      --replace "defined(R__GNU) && (defined(R__LINUX) || defined(__APPLE__))" \
                "defined(R__GNU) && (defined(__APPLE__))"
  ''
  # Fix CINTSYSDIR for "build" version of rootcint
  # This is probably a bug that breaks out-of-source builds
  + ''
    substituteInPlace cint/cint/src/loadfile.cxx\
      --replace 'env = "cint";' 'env = "'`pwd`'/cint";'
  '' + lib.optionalString noSplash ''
    substituteInPlace rootx/src/rootx.cxx --replace "gNoLogo = false" "gNoLogo = true"
  '';

  cmakeFlags = [
    "-Drpath=ON"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_CXX_FLAGS=-std=c++11"
    "-Dalien=OFF"
    "-Dbonjour=OFF"
    "-Dcastor=OFF"
    "-Dchirp=OFF"
    "-Ddavix=OFF"
    "-Ddcache=OFF"
    "-Dfftw3=OFF"
    "-Dfitsio=OFF"
    "-Dfortran=OFF"
    "-Dgfal=OFF"
    "-Dgsl_shared=ON"
    "-Dgviz=OFF"
    "-Dhdfs=OFF"
    "-Dkrb5=OFF"
    "-Dldap=OFF"
    "-Dmathmore=ON"
    "-Dmonalisa=OFF"
    "-Dmysql=OFF"
    "-Dodbc=OFF"
    "-Dopengl=ON"
    "-Doracle=OFF"
    "-Dpgsql=OFF"
    "-Dpythia6=OFF"
    "-Dpythia8=OFF"
    "-Drfio=OFF"
    "-Dsqlite=OFF"
    "-Dssl=OFF"
    "-Dxml=ON"
    "-Dxrootd=OFF"
  ]
  ++ lib.optional stdenv.isDarwin "-DOPENGL_INCLUDE_DIR=${OpenGL}/Library/Frameworks";

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    homepage = "https://root.cern.ch/";
    description = "A data analysis framework";
    platforms = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
    license = licenses.lgpl21;
  };
}
