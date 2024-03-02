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
, gtest
, lapack
, libX11
, libXpm
, libXft
, libXext
, libGLU
, libGL
, libxcrypt
, libxml2
, llvm_13
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

stdenv.mkDerivation rec {
  pname = "root";
  version = "6.30.04";

  passthru = {
    tests = import ./tests { inherit callPackage; };
  };

  src = fetchurl {
    url = "https://root.cern.ch/download/root_v${version}.source.tar.gz";
    hash = "sha256-K0GAtpjznMZdkQhNgzqIRRWzJbxfZzyOOavoGLAl2Mw=";
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
    llvm_13
    lz4
    xz
    gsl
    gtest
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

    # compatibility with recent XRootD
    # https://github.com/root-project/root/pull/13752
    (fetchpatch {
      url = "https://github.com/root-project/root/commit/3d3cda6c520791282298782189cdb8ca07ace4b9.diff";
      hash = "sha256-O3aXzrOEQiPjZgbAj9TL6Wt/adN1kKFwjooeaFRyT4I=";
    })
    (fetchpatch {
      url = "https://github.com/root-project/root/commit/6e7798e62dbed1ffa8b91a180fa5a080b7c04ba3.diff";
      hash = "sha256-47/J631DBnVlvM1Pm9iicKXDKAqN8v9hjAstQuHmH8Q=";
    })
  ];

  preConfigure = ''
    for path in builtins/*; do
      if [[ "$path" != "builtins/openui5" ]] && [[ "$path" != "builtins/rendercore" ]]; then
        rm -rf "$path"
      fi
    done
    substituteInPlace cmake/modules/SearchInstalledSoftware.cmake \
      --replace 'set(lcgpackages ' '#set(lcgpackages '

    substituteInPlace interpreter/llvm-project/clang/tools/driver/CMakeLists.txt \
      --replace 'add_clang_symlink(''${link} clang)' ""

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
    substituteInPlace core/macosx/CMakeLists.txt \
      --replace "-F/System/Library/PrivateFrameworks " ""
  '' + lib.optionalString (stdenv.isDarwin && lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11") ''
    MACOSX_DEPLOYMENT_TARGET=10.16
  '';

  cmakeFlags = [
    "-Drpath=ON"
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-Dbuiltin_llvm=OFF"
    "-Dbuiltin_freetype=OFF"
    "-Dbuiltin_gtest=OFF"
    "-Dbuiltin_nlohmannjson=OFF"
    "-Dbuiltin_openui5=ON"
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
    "-Dgnuinstall=ON"
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
    "-Droot7=ON"
    "-Dsqlite=OFF"
    "-Dssl=ON"
    "-Dtmva=ON"
    "-Dtmva-pymva=OFF"
    "-Dvdt=OFF"
    "-Dwebgui=ON"
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

  # suppress warnings from compilation of the vendored clang to avoid running into log limits on the Hydra
  NIX_CFLAGS_COMPILE = lib.optionals stdenv.cc.isGNU [ "-Wno-shadow" "-Wno-maybe-uninitialized" ];

  postInstall = ''
    for prog in rootbrowse rootcp rooteventselector rootls rootmkdir rootmv rootprint rootrm rootslimtree; do
      wrapProgram "$out/bin/$prog" \
        --set PYTHONPATH "$out/lib"
    done

    # Make ldd and sed available to the ROOT executable by prefixing PATH.
    wrapProgram "$out/bin/root" \
      --prefix PATH : "${lib.makeBinPath [
        gnused # sed
        stdenv.cc # c++ ld etc.
        stdenv.cc.libc # ldd
      ]}"

    # Patch thisroot.{sh,csh,fish}

    # The main target of `thisroot.sh` is "bash-like shells",
    # but it also need to support Bash-less POSIX shell like dash,
    # as they are mentioned in `thisroot.sh`.

    patchRcPathPosix "$out/bin/thisroot.sh" "${lib.makeBinPath [
      coreutils # dirname tail
      gnugrep # grep
      gnused # sed
      lsof # lsof
      man # manpath
      procps # ps
      which # which
    ]}"
    patchRcPathCsh "$out/bin/thisroot.csh" "${lib.makeBinPath [
      coreutils
      gnugrep
      gnused
      lsof # lsof
      man
      which
    ]}"
    patchRcPathFish "$out/bin/thisroot.fish" "${lib.makeBinPath [
      coreutils
      man
      which
    ]}"
  '';

  # To use the debug information on the fly (without installation)
  # add the outPath of root.debug into NIX_DEBUG_INFO_DIRS (in PATH-like format)
  # and make sure that gdb from Nixpkgs can be found in PATH.
  #
  # Darwin currently fails to support it (#203380)
  # we set it to true hoping to benefit from the future fix.
  # Before that, please make sure if root.debug exists before using it.
  separateDebugInfo = true;

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    homepage = "https://root.cern.ch/";
    description = "A data analysis framework";
    platforms = platforms.unix;
    maintainers = [ maintainers.veprbl ];
    license = licenses.lgpl21;
  };
}
