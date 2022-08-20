{ stdenv
, lib
, fetchurl
, fetchpatch
, makeWrapper
, cmake
, git
, ftgl
, gl2ps
, glew
, gsl
, lapack
, libX11
, libXpm
, libXft
, libXext
, libGLU
, libGL
, libxml2
, llvm_9
, lz4
, xz
, openblas
, pcre
, nlohmann_json
, pkg-config
, python
, xxHash
, zlib
, zstd
, libAfterImage
, giflib
, libjpeg
, libtiff
, libpng
, tbb
, Cocoa
, CoreSymbolication
, OpenGL
, noSplash ? false
}:

let

  _llvm_9 = llvm_9.overrideAttrs (prev: {
    patches = (prev.patches or []) ++ [
      (fetchpatch {
        url = "https://github.com/root-project/root/commit/a9c961cf4613ff1f0ea50f188e4a4b0eb749b17d.diff";
        stripLen = 3;
        hash = "sha256-LH2RipJICEDWOr7JzX5s0QiUhEwXNMFEJihYKy9qWpo=";
      })
    ];
  });

in

stdenv.mkDerivation rec {
  pname = "root";
  version = "6.26.06";

  src = fetchurl {
    url = "https://root.cern.ch/download/root_v${version}.source.tar.gz";
    hash = "sha256-sfc8l2pYClxWyMigFSWCod/FYLTdgOG3VFI3tl5sics=";
  };

  nativeBuildInputs = [ makeWrapper cmake pkg-config git ];
  buildInputs = [
    ftgl
    gl2ps
    glew
    pcre
    zlib
    zstd
    lapack
    libxml2
    _llvm_9
    lz4
    xz
    gsl
    openblas
    xxHash
    libAfterImage
    giflib
    libjpeg
    libtiff
    libpng
    nlohmann_json
    python.pkgs.numpy
    tbb
  ]
  ++ lib.optionals (!stdenv.isDarwin) [ libX11 libXpm libXft libXext libGLU libGL ]
  ++ lib.optionals (stdenv.isDarwin) [ Cocoa CoreSymbolication OpenGL ]
  ;

  patches = [
    ./sw_vers.patch
  ];

  # Fix build against vanilla LLVM 9
  postPatch = ''
    sed \
      -e '/#include "llvm.*RTDyldObjectLinkingLayer.h"/i#define private protected' \
      -e '/#include "llvm.*RTDyldObjectLinkingLayer.h"/a#undef private' \
      -i interpreter/cling/lib/Interpreter/IncrementalJIT.h
  '';

  preConfigure = ''
    rm -rf builtins/*
    substituteInPlace cmake/modules/SearchInstalledSoftware.cmake \
      --replace 'set(lcgpackages ' '#set(lcgpackages '

    # Don't require textutil on macOS
    : > cmake/modules/RootCPack.cmake

    # Hardcode path to fix use with cmake
    sed -i cmake/scripts/ROOTConfig.cmake.in \
      -e '1iset(nlohmann_json_DIR "${nlohmann_json}/lib/cmake/nlohmann_json/")'

    patchShebangs build/unix/
  '' + lib.optionalString noSplash ''
    substituteInPlace rootx/src/rootx.cxx --replace "gNoLogo = false" "gNoLogo = true"
  '' + lib.optionalString stdenv.isDarwin ''
    # Eliminate impure reference to /System/Library/PrivateFrameworks
    substituteInPlace core/CMakeLists.txt \
      --replace "-F/System/Library/PrivateFrameworks" ""
  '';

  cmakeFlags = [
    "-Drpath=ON"
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-Dbuiltin_llvm=OFF"
    "-Dbuiltin_nlohmannjson=OFF"
    "-Dbuiltin_openui5=OFF"
    "-Dalien=OFF"
    "-Dbonjour=OFF"
    "-Dcastor=OFF"
    "-Dchirp=OFF"
    "-Dclad=OFF"
    "-Ddavix=OFF"
    "-Ddcache=OFF"
    "-Dfail-on-missing=ON"
    "-Dfftw3=OFF"
    "-Dfitsio=OFF"
    "-Dfortran=OFF"
    "-Dimt=ON"
    "-Dgfal=OFF"
    "-Dgviz=OFF"
    "-Dhdfs=OFF"
    "-Dhttp=ON"
    "-Dkrb5=OFF"
    "-Dldap=OFF"
    "-Dmonalisa=OFF"
    "-Dmysql=OFF"
    "-Dodbc=OFF"
    "-Dopengl=ON"
    "-Doracle=OFF"
    "-Dpgsql=OFF"
    "-Dpythia6=OFF"
    "-Dpythia8=OFF"
    "-Drfio=OFF"
    "-Droot7=OFF"
    "-Dsqlite=OFF"
    "-Dssl=OFF"
    "-Dtmva=ON"
    "-Dvdt=OFF"
    "-Dwebgui=OFF"
    "-Dxml=ON"
    "-Dxrootd=OFF"
  ]
  ++ lib.optional (stdenv.cc.libc != null) "-DC_INCLUDE_DIRS=${lib.getDev stdenv.cc.libc}/include"
  ++ lib.optionals stdenv.isDarwin [
    "-DOPENGL_INCLUDE_DIR=${OpenGL}/Library/Frameworks"
    "-DCMAKE_DISABLE_FIND_PACKAGE_Python2=TRUE"

    # fatal error: module map file '/nix/store/<hash>-Libsystem-osx-10.12.6/include/module.modulemap' not found
    # fatal error: could not build module '_Builtin_intrinsics'
    "-Druntime_cxxmodules=OFF"
  ];

  postInstall = ''
    for prog in rootbrowse rootcp rooteventselector rootls rootmkdir rootmv rootprint rootrm rootslimtree; do
      wrapProgram "$out/bin/$prog" \
        --set PYTHONPATH "$out/lib" \
        --set ${lib.optionalString stdenv.isDarwin "DY"}LD_LIBRARY_PATH "$out/lib"
    done
  '';

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    homepage = "https://root.cern.ch/";
    description = "A data analysis framework";
    platforms = platforms.unix;
    maintainers = [ maintainers.veprbl ];
    license = licenses.lgpl21;
  };
}
