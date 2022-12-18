{ stdenv
, lib
, callPackage
, fetchurl
, fetchpatch
, makeWrapper
, cmake
, coreutils
, git
, davix
, ftgl
, gl2ps
, glew
, gnugrep
, gnused
, gsl
, lapack
, libX11
, libXpm
, libXft
, libXext
, libGLU
, libGL
, libxcrypt
, libxml2
, llvm_9
, lsof
, lz4
, xz
, man
, openblas
, openssl
, pcre
, nlohmann_json
, pkg-config
, procps
, python
, which
, xxHash
, zlib
, zstd
, libAfterImage
, giflib
, libjpeg
, libtiff
, libpng
, patchRcPathCsh
, patchRcPathFish
, patchRcPathPosix
, tbb
, xrootd
, Cocoa
, CoreSymbolication
, OpenGL
, noSplash ? false
}:

let

  _llvm_9 = llvm_9.overrideAttrs (prev: {
    patches = (prev.patches or [ ]) ++ [
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
  version = "6.26.10";

  passthru = {
    tests = import ./tests { inherit callPackage; };
  };

  src = fetchurl {
    url = "https://root.cern.ch/download/root_v${version}.source.tar.gz";
    hash = "sha256-jla+w5cQQBeqVPnrVU3noaE0R0/gs7sPQ6cPxPq9Yl8=";
  };

  nativeBuildInputs = [ makeWrapper cmake pkg-config git ];
  propagatedBuildInputs = [
    nlohmann_json
  ];
  buildInputs = [
    davix
    ftgl
    gl2ps
    glew
    pcre
    zlib
    zstd
    lapack
    libxcrypt
    libxml2
    _llvm_9
    lz4
    xz
    gsl
    openblas
    openssl
    xxHash
    libAfterImage
    giflib
    libjpeg
    libtiff
    libpng
    patchRcPathCsh
    patchRcPathFish
    patchRcPathPosix
    python.pkgs.numpy
    tbb
    xrootd
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
  '' + lib.optionalString (stdenv.isDarwin && lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11") ''
    MACOSX_DEPLOYMENT_TARGET=10.16
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
    "-Ddavix=ON"
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
    "-Dssl=ON"
    "-Dtmva=ON"
    "-Dvdt=OFF"
    "-Dwebgui=OFF"
    "-Dxml=ON"
    "-Dxrootd=ON"
  ]
  ++ lib.optional (stdenv.cc.libc != null) "-DC_INCLUDE_DIRS=${lib.getDev stdenv.cc.libc}/include"
  ++ lib.optionals stdenv.isDarwin [
    "-DOPENGL_INCLUDE_DIR=${OpenGL}/Library/Frameworks"
    "-DCMAKE_DISABLE_FIND_PACKAGE_Python2=TRUE"

    # fatal error: module map file '/nix/store/<hash>-Libsystem-osx-10.12.6/include/module.modulemap' not found
    # fatal error: could not build module '_Builtin_intrinsics'
    "-Druntime_cxxmodules=OFF"
  ];

  NIX_LDFLAGS = lib.optionalString (stdenv.isLinux && stdenv.isAarch64 && stdenv.cc.isGNU) "-lgcc";

  # Workaround the xrootd runpath bug #169677 by prefixing [DY]LD_LIBRARY_PATH with ${lib.makeLibraryPath xrootd}.
  # TODO: Remove the [DY]LDLIBRARY_PATH prefix for xrootd when #200830 get merged.
  postInstall = ''
    for prog in rootbrowse rootcp rooteventselector rootls rootmkdir rootmv rootprint rootrm rootslimtree; do
      wrapProgram "$out/bin/$prog" \
        --set PYTHONPATH "$out/lib" \
        --set ${lib.optionalString stdenv.isDarwin "DY"}LD_LIBRARY_PATH "$out/lib:${lib.makeLibraryPath [ xrootd ]}"
    done

    # Make ldd and sed available to the ROOT executable by prefixing PATH.
    wrapProgram "$out/bin/root" \
      --prefix PATH : "${lib.makeBinPath [
        gnused # sed
        stdenv.cc # c++ ld etc.
        stdenv.cc.libc # ldd
      ]}" \
      --prefix ${lib.optionalString stdenv.hostPlatform.isDarwin "DY"}LD_LIBRARY_PATH : "${lib.makeLibraryPath [ xrootd ]}"

    # Patch thisroot.{sh,csh,fish}

    # The main target of `thisroot.sh` is "bash-like shells",
    # but it also need to support Bash-less POSIX shell like dash,
    # as they are mentioned in `thisroot.sh`.

    # `thisroot.sh` would include commands `lsof` and `procps` since ROOT 6.28.
    # See https://github.com/root-project/root/pull/10332

    patchRcPathPosix "$out/bin/thisroot.sh" "${lib.makeBinPath [
      coreutils # dirname tail
      gnugrep # grep
      gnused # sed
      lsof # lsof # for ROOT (>=6.28)
      man # manpath
      procps # ps # for ROOT (>=6.28)
      which # which
    ]}"
    patchRcPathCsh "$out/bin/thisroot.csh" "${lib.makeBinPath [
      coreutils
      gnugrep
      gnused
      lsof # lsof # for ROOT (>=6.28)
      man
      which
    ]}"
    patchRcPathFish "$out/bin/thisroot.fish" "${lib.makeBinPath [
      coreutils
      man
      which
    ]}"
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
