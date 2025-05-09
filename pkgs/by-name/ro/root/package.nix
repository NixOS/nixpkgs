{
  stdenv,
  lib,
  callPackage,
  fetchFromGitHub,
  fetchurl,
  makeWrapper,
  writeText,
  apple-sdk,
  cmake,
  coreutils,
  git,
  davix,
  fftw,
  ftgl,
  gl2ps,
  glew,
  gnugrep,
  gnused,
  gsl,
  libGLU,
  libGL,
  libxcrypt,
  libxml2,
  llvm_18,
  lsof,
  lz4,
  xorg,
  xz,
  man,
  openssl,
  pcre2,
  nlohmann_json,
  pkg-config,
  procps,
  python3,
  which,
  xxHash,
  zlib,
  zstd,
  giflib,
  libjpeg,
  libtiff,
  libpng,
  patchRcPathCsh,
  patchRcPathFish,
  patchRcPathPosix,
  tbb,
  xrootd,
}:

stdenv.mkDerivation rec {
  pname = "root";
  version = "6.36.00";

  passthru = {
    tests = import ./tests { inherit callPackage; };
  };

  src = fetchurl {
    url = "https://root.cern.ch/download/root_v${version}-rc1.source.tar.gz";
    hash = "sha256-WkB2IP4BZMv2yfJrGuiCoXwQFRRy1yaPutF2AnVkscA=";
  };

  clad_src = fetchFromGitHub {
    owner = "vgvassilev";
    repo = "clad";
    # Make sure that this is the same tag as in the ROOT build files!
    # https://github.com/root-project/root/blob/master/interpreter/cling/tools/plugins/clad/CMakeLists.txt#L76
    rev = "refs/tags/v1.9";
    hash = "sha256-TKCRAfwdTp/uDH7rk9EE4z2hwqBybklHhhYH6hQFYpg=";
  };

  # ROOT requires a patched version on clang
  clang = (callPackage ./clang-root.nix { });

  nativeBuildInputs = [
    makeWrapper
    cmake
    pkg-config
    git
  ];
  propagatedBuildInputs = [
    nlohmann_json # link interface of target "ROOT::ROOTEve"
  ];
  buildInputs =
    [
      clang
      davix
      fftw
      ftgl
      giflib
      gl2ps
      glew
      gsl
      libjpeg
      libpng
      libtiff
      libxcrypt
      libxml2
      llvm_18
      lz4
      openssl
      patchRcPathCsh
      patchRcPathFish
      patchRcPathPosix
      pcre2
      python3.pkgs.numpy
      tbb
      xrootd
      xxHash
      xz
      zlib
      zstd
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk.privateFrameworksHook ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      libGLU
      libGL
      xorg.libX11
      xorg.libXpm
      xorg.libXft
      xorg.libXext
    ];

  preConfigure =
    ''
      for path in builtins/*; do
        if [[ "$path" != "builtins/openui5" ]] && [[ "$path" != "builtins/rendercore" ]]; then
          rm -rf "$path"
        fi
      done
      substituteInPlace cmake/modules/SearchInstalledSoftware.cmake \
        --replace-fail 'set(lcgpackages ' '#set(lcgpackages '

      substituteInPlace core/clingutils/CMakeLists.txt \
        --replace-fail 'set(CLANG_RESOURCE_DIR_STEM ''${LLVM_LIBRARY_DIR}/clang)' 'set(CLANG_RESOURCE_DIR_STEM ${clang}/lib/clang)'

      patchShebangs cmake/unix/
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # Eliminate impure reference to /System/Library/PrivateFrameworks
      substituteInPlace core/macosx/CMakeLists.txt \
        --replace-fail "-F/System/Library/PrivateFrameworks " ""
    ''
    +
      lib.optionalString
        (stdenv.hostPlatform.isDarwin && lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11")
        ''
          MACOSX_DEPLOYMENT_TARGET=10.16
        '';

  cmakeFlags =
    [
      "-DCLAD_SOURCE_DIR=${clad_src}"
      "-DCMAKE_INSTALL_BINDIR=bin"
      "-DCMAKE_INSTALL_INCLUDEDIR=include"
      "-DCMAKE_INSTALL_LIBDIR=lib"
      "-DCMAKE_OSX_SYSROOT=/tmp" # random path to not trigger automatic detection in SetUpMacOS.cmake
      "-DClang_DIR=${clang}/lib/cmake/clang"
      "-Dbuiltin_clang=OFF"
      "-Dbuiltin_llvm=OFF"
      "-Dfail-on-missing=ON"
      "-Dfftw3=ON"
      "-Dfitsio=OFF"
      "-Dgnuinstall=ON"
      "-Dmathmore=ON"
      "-Dsqlite=OFF"
      "-Dvdt=OFF"
    ]
    ++ lib.optional (
      (!stdenv.hostPlatform.isDarwin) && (stdenv.cc.libc != null)
    ) "-DC_INCLUDE_DIRS=${lib.getDev stdenv.cc.libc}/include"
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # fatal error: module map file '/nix/store/<hash>-Libsystem-osx-10.12.6/include/module.modulemap' not found
      # fatal error: could not build module '_Builtin_intrinsics'
      "-Druntime_cxxmodules=OFF"
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

  # workaround for
  # https://github.com/root-project/root/issues/14778
  env.NIX_LDFLAGS = lib.optionalString (
    !stdenv.hostPlatform.isDarwin
  ) "--version-script,${writeText "version.map" "ROOT { global: *; };"}";

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
    description = "Data analysis framework";
    platforms = platforms.unix;
    maintainers = [
      maintainers.guitargeek
      maintainers.veprbl
    ];
    license = licenses.lgpl21;
  };
}
