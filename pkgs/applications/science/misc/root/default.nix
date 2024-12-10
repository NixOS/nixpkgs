{
  stdenv,
  lib,
  callPackage,
  fetchgit,
  fetchurl,
  fetchpatch,
  makeWrapper,
  cmake,
  coreutils,
  git,
  davix,
  ftgl,
  gl2ps,
  glew,
  gnugrep,
  gnused,
  gsl,
  gtest,
  lapack,
  libX11,
  libXpm,
  libXft,
  libXext,
  libGLU,
  libGL,
  libxcrypt,
  libxml2,
  llvm_13,
  lsof,
  lz4,
  xz,
  man,
  openblas,
  openssl,
  pcre,
  nlohmann_json,
  pkg-config,
  procps,
  python,
  which,
  xxHash,
  zlib,
  zstd,
  libAfterImage,
  giflib,
  libjpeg,
  libtiff,
  libpng,
  patchRcPathCsh,
  patchRcPathFish,
  patchRcPathPosix,
  tbb,
  xrootd,
  Cocoa,
  CoreSymbolication,
  OpenGL,
}:

stdenv.mkDerivation rec {
  pname = "root";
  version = "6.30.06";

  passthru = {
    tests = import ./tests { inherit callPackage; };
  };

  src = fetchurl {
    url = "https://root.cern.ch/download/root_v${version}.source.tar.gz";
    hash = "sha256-MA237RtnjtL7ljXKZ1khoZRcfCED2oQAM7STCR9VcAw=";
  };

  clad_src = fetchgit {
    url = "https://github.com/vgvassilev/clad";
    rev = "refs/tags/v1.4"; # Make sure that this is the same tag as in the ROOT build files!
    hash = "sha256-OI9PaS7kQ/ewD5Soe3gG5FZdlR6qG6Y3mfHwi5dj1sI=";
  };

  nativeBuildInputs = [
    makeWrapper
    cmake
    pkg-config
    git
  ];
  propagatedBuildInputs = [
    nlohmann_json
  ];
  buildInputs =
    [
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
    ++ lib.optionals (!stdenv.isDarwin) [
      libX11
      libXpm
      libXft
      libXext
      libGLU
      libGL
    ]
    ++ lib.optionals (stdenv.isDarwin) [
      Cocoa
      CoreSymbolication
      OpenGL
    ];

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

  preConfigure =
    ''
      for path in builtins/*; do
        if [[ "$path" != "builtins/openui5" ]] && [[ "$path" != "builtins/rendercore" ]]; then
          rm -rf "$path"
        fi
      done
      substituteInPlace cmake/modules/SearchInstalledSoftware.cmake \
        --replace 'set(lcgpackages ' '#set(lcgpackages '

      # We have to bypass the connection check, because it would disable clad.
      # This should probably be fixed upstream with a flag to disable the
      # connectivity check!
      substituteInPlace CMakeLists.txt \
        --replace 'if(NO_CONNECTION)' 'if(FALSE)'
      substituteInPlace interpreter/cling/tools/plugins/CMakeLists.txt \
        --replace 'if(NOT DEFINED NO_CONNECTION OR NOT NO_CONNECTION)' 'if(TRUE)'
      # Make sure that clad is not downloaded when building
      substituteInPlace interpreter/cling/tools/plugins/clad/CMakeLists.txt \
        --replace 'UPDATE_COMMAND ""' 'SOURCE_DIR ${clad_src} DOWNLOAD_COMMAND "" UPDATE_COMMAND ""'
      # Make sure that clad is finding the right llvm version
      substituteInPlace interpreter/cling/tools/plugins/clad/CMakeLists.txt \
        --replace '-DLLVM_DIR=''${LLVM_BINARY_DIR}' '-DLLVM_DIR=${llvm_13.dev}/lib/cmake/llvm'
      # Fix that will also be upstream in ROOT 6.32. TODO: remove it when updating to 6.32
      substituteInPlace interpreter/cling/tools/plugins/clad/CMakeLists.txt \
        --replace 'set(_CLAD_LIBRARY_PATH ''${clad_install_dir}/plugins/lib)' 'set(_CLAD_LIBRARY_PATH ''${CMAKE_CURRENT_BINARY_DIR}/clad-prefix/src/clad-build/lib''${LLVM_LIBDIR_SUFFIX})'

      substituteInPlace interpreter/llvm-project/clang/tools/driver/CMakeLists.txt \
        --replace 'add_clang_symlink(''${link} clang)' ""

      # Don't require textutil on macOS
      : > cmake/modules/RootCPack.cmake

      # Hardcode path to fix use with cmake
      sed -i cmake/scripts/ROOTConfig.cmake.in \
        -e '1iset(nlohmann_json_DIR "${nlohmann_json}/lib/cmake/nlohmann_json/")'

      patchShebangs build/unix/
    ''
    + lib.optionalString stdenv.isDarwin ''
      # Eliminate impure reference to /System/Library/PrivateFrameworks
      substituteInPlace core/macosx/CMakeLists.txt \
        --replace "-F/System/Library/PrivateFrameworks " ""
    ''
    +
      lib.optionalString (stdenv.isDarwin && lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11")
        ''
          MACOSX_DEPLOYMENT_TARGET=10.16
        '';

  cmakeFlags =
    [
      "-DCMAKE_INSTALL_BINDIR=bin"
      "-DCMAKE_INSTALL_LIBDIR=lib"
      "-DCMAKE_INSTALL_INCLUDEDIR=include"
      "-Dbuiltin_llvm=OFF"
      "-Dfail-on-missing=ON"
      "-Dfitsio=OFF"
      "-Dgnuinstall=ON"
      "-Dmysql=OFF"
      "-Dpgsql=OFF"
      "-Dsqlite=OFF"
      "-Dtmva-pymva=OFF"
      "-Dvdt=OFF"
    ]
    ++ lib.optional (stdenv.cc.libc != null) "-DC_INCLUDE_DIRS=${lib.getDev stdenv.cc.libc}/include"
    ++ lib.optionals stdenv.isDarwin [
      "-DOPENGL_INCLUDE_DIR=${OpenGL}/Library/Frameworks"

      # fatal error: module map file '/nix/store/<hash>-Libsystem-osx-10.12.6/include/module.modulemap' not found
      # fatal error: could not build module '_Builtin_intrinsics'
      "-Druntime_cxxmodules=OFF"
    ];

  # suppress warnings from compilation of the vendored clang to avoid running into log limits on the Hydra
  NIX_CFLAGS_COMPILE = lib.optionals stdenv.cc.isGNU [
    "-Wno-shadow"
    "-Wno-maybe-uninitialized"
  ];

  postInstall = ''
    for prog in rootbrowse rootcp rooteventselector rootls rootmkdir rootmv rootprint rootrm rootslimtree; do
      wrapProgram "$out/bin/$prog" \
        --set PYTHONPATH "$out/lib"
    done

    # Make ldd and sed available to the ROOT executable by prefixing PATH.
    wrapProgram "$out/bin/root" \
      --prefix PATH : "${
        lib.makeBinPath [
          gnused # sed
          stdenv.cc # c++ ld etc.
          stdenv.cc.libc # ldd
        ]
      }"

    # Patch thisroot.{sh,csh,fish}

    # The main target of `thisroot.sh` is "bash-like shells",
    # but it also need to support Bash-less POSIX shell like dash,
    # as they are mentioned in `thisroot.sh`.

    patchRcPathPosix "$out/bin/thisroot.sh" "${
      lib.makeBinPath [
        coreutils # dirname tail
        gnugrep # grep
        gnused # sed
        lsof # lsof
        man # manpath
        procps # ps
        which # which
      ]
    }"
    patchRcPathCsh "$out/bin/thisroot.csh" "${
      lib.makeBinPath [
        coreutils
        gnugrep
        gnused
        lsof # lsof
        man
        which
      ]
    }"
    patchRcPathFish "$out/bin/thisroot.fish" "${
      lib.makeBinPath [
        coreutils
        man
        which
      ]
    }"
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
    homepage = "https://root.cern/";
    description = "A data analysis framework";
    platforms = platforms.unix;
    maintainers = [
      maintainers.guitargeek
      maintainers.veprbl
    ];
    license = licenses.lgpl21;
  };
}
