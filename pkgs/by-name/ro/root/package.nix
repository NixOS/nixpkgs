{
  stdenv,
  lib,
  blas,
  callPackage,
  cfitsio,
  civetweb,
  curl,
  fetchFromGitHub,
  fetchurl,
  linkFarm,
  makeWrapper,
  apple-sdk,
  cmake,
  coreutils,
  davix,
  fftw,
  ftgl,
  gl2ps,
  gnugrep,
  gnused,
  gsl,
  libGLU,
  libGL,
  libxcrypt,
  libxml2,
  llvm_22,
  lsof,
  lz4,
  libxpm,
  libxft,
  libxext,
  libx11,
  xz,
  man,
  openssl,
  pcre2,
  nlohmann_json,
  pkg-config,
  procps,
  python3,
  sqlite,
  which,
  xxhash,
  zlib,
  zstd,
  giflib,
  git,
  libjpeg,
  libtiff,
  libpng,
  patchRcPathCsh,
  patchRcPathFish,
  patchRcPathPosix,
  onetbb,
  xrootd,
  freetype,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "root";
  # The last tag reachable from the v6-42-00-patches branch
  version = "6.42.00-rc1-unstable-2026-11-06";

  passthru = {
    tests = import ./tests { inherit callPackage; } // {
      # The Python package runs the import checks for the PyROOT bindings
      pyroot = python3.pkgs.root;
    };
  };

  src = fetchFromGitHub {
    owner = "root-project";
    repo = "root";
    rev = "9c3c928cb60f73a8f89cb912b2f5f4d971fbcb88";
    hash = "sha256-RADlmKCfQqMOzr1Xd93OZC8nqNLWQwg1bGz57e7Uneg=";
  };

  # Hashes are checked at ROOT build time, so wrong downloads will not be silently accepted
  builtin_downloads = linkFarm "root-builtin-downloads" [
    {
      name = "jsroot-7.12.0.tar.gz";
      path = fetchurl {
        url = "https://github.com/root-project/jsroot/releases/download/7.12.0/JsRoot7120.tar.gz";
        hash = "sha256-5dgoiHUL2nAJCsS/81VzQAA3LJg6Pv8R1n76CfMNSwY=";
      };
    }
    {
      name = "openui5-runtime-1.152.0.zip";
      path = fetchurl {
        url = "https://github.com/UI5/openui5/releases/download/1.152.0/openui5-runtime-1.152.0.zip";
        hash = "sha256-SIICPUdg7UwgYC423Rg7AqU4/H6Lv9pge24lvRy7zbE=";
      };
    }
    {
      name = "mathjax-3.2.0.tar.gz";
      path = fetchurl {
        url = "https://github.com/mathjax/MathJax/archive/refs/tags/3.2.0.tar.gz";
        hash = "sha256-aEfxz92YCvvjG0ZkdNowGlarhZpn2ANUQrBS3UrC+gM=";
      };
    }
    {
      name = "clad-2.5.tar.gz";
      path = fetchurl {
        url = "https://github.com/vgvassilev/clad/archive/refs/tags/v2.5.tar.gz";
        hash = "sha256-9Uig5Opphah/x7h484eR80+W7x3AakH/NdcFjXWvFBc=";
      };
    }
  ];

  # ROOT requires a patched version of clang
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
  buildInputs = [
    finalAttrs.clang
    blas
    cfitsio
    (civetweb.override {
      # ROOT requires civetweb with websocket, zlib and unix domain socket support
      withWebSockets = true;
      withZlib = true;
      withUnixSockets = true;
    })
    curl
    davix
    fftw
    ftgl
    giflib
    gl2ps
    gsl
    libjpeg
    libpng
    libtiff
    libxcrypt
    libxml2
    llvm_22
    lz4
    openssl
    patchRcPathCsh
    patchRcPathFish
    patchRcPathPosix
    pcre2
    python3
    sqlite
    onetbb
    xrootd
    xxhash
    xz
    zlib
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk.privateFrameworksHook
    freetype
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libGLU
    libGL
    libx11
    libxpm
    libxft
    libxext
  ];

  cmakeFlags = [
    "-DClang_DIR=${finalAttrs.clang}/lib/cmake/clang"
    "-Dbuiltin_clang=OFF"
    "-Dbuiltin_llvm=OFF"
    "-Dbuiltin_jsroot=ON"
    "-Dbuiltin_mathjax=ON"
    "-Dbuiltin_openui5=ON"
    "-DROOT_DOWNLOAD_DIR=${finalAttrs.builtin_downloads}"
    "-Dfail-on-missing=ON"
    "-Dfftw3=ON"
    "-Dmathmore=ON"
    "-Dvdt=OFF"
  ];

  postInstall = ''
    for prog in rooteventselector rootmv rootprint rootslimtree; do
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

  meta = {
    homepage = "https://root.cern/";
    description = "Data analysis framework";
    changelog = "https://root.cern/doc/v${lib.versions.major finalAttrs.version}${lib.versions.minor finalAttrs.version}/release-notes.html";
    platforms = lib.platforms.unix;
    maintainers = [
      lib.maintainers.guitargeek
      lib.maintainers.veprbl
    ];
    license = lib.licenses.lgpl21Plus;
    mainProgram = "root";
  };
})
