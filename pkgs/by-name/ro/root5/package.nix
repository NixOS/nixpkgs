{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  cmake,
  pcre,
  pkg-config,
  python3,
  libX11,
  libXpm,
  libXft,
  libXext,
  libGLU,
  libGL,
  zlib,
  libxml2,
  libxcrypt,
  lz4,
  xz,
  gsl,
  xxHash,
  noSplash ? false,
}:

stdenv.mkDerivation rec {
  pname = "root";
  version = "5.34.38";

  src = fetchurl {
    url = "https://root.cern.ch/download/root_v${version}.source.tar.gz";
    sha256 = "1ln448lszw4d6jmbdphkr2plwxxlhmjkla48vmmq750xc1lxlfrc";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs =
    [
      pcre
      python3
      zlib
      libxml2
      lz4
      xz
      gsl
      xxHash
      libxcrypt
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      libX11
      libXpm
      libXft
      libXext
      libGLU
      libGL
    ];

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
    (fetchpatch {
      name = "root5-python37-fix.patch";
      url = "https://github.com/root-project/root/commit/c75458024082de0cc35b45505c652b8460a9e71b.patch";
      sha256 = "sha256-A5zEjQE9OGPFp/L1HUs4NIdxQMRiwbwCRNWOLN2ENrM=";
    })
    # Backport Python 3.11 fix to v5 from v6.26
    # https://github.com/root-project/root/commit/484deb056dacf768aba4954073b41105c431bffc
    ./root5-python311-fix.patch
  ];

  # https://github.com/root-project/root/issues/13216
  hardeningDisable = [ "fortify3" ];

  preConfigure =
    ''
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

      # python 3.12
      substituteInPlace bindings/pyroot/src/PyROOT.h \
        --replace " PyUnicode_GET_SIZE" " PyUnicode_GetLength" \
        --replace " PyUnicode_GetSize" " PyUnicode_GetLength"
    ''
    # Fix CINTSYSDIR for "build" version of rootcint
    # This is probably a bug that breaks out-of-source builds
    + ''
      substituteInPlace cint/cint/src/loadfile.cxx\
        --replace 'env = "cint";' 'env = "'`pwd`'/cint";'
    ''
    + lib.optionalString noSplash ''
      substituteInPlace rootx/src/rootx.cxx --replace "gNoLogo = false" "gNoLogo = true"
    '';

  cmakeFlags =
    [
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
    ++ lib.optional (
      (!stdenv.hostPlatform.isDarwin) && (stdenv.cc.libc != null)
    ) "-DC_INCLUDE_DIRS=${lib.getDev stdenv.cc.libc}/include";

  env.NIX_CFLAGS_COMPILE = "-fpermissive";

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    homepage = "https://root.cern.ch/";
    description = "Data analysis framework";
    platforms = platforms.unix;
    broken = !stdenv.hostPlatform.isx86_64 || stdenv.cc.isClang or false;
    maintainers = with maintainers; [ veprbl ];
    license = licenses.lgpl21;
  };
}
