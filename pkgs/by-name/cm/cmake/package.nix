{
  lib,
  stdenv,
  fetchurl,
  replaceVars,
  buildPackages,
  bzip2,
  curlMinimal,
  expat,
  libarchive,
  libuv,
  ncurses,
  openssl,
  pkg-config,
  ps,
  sysctl,
  rhash,
  sphinx,
  texinfo,
  xz,
  zlib,
  darwin,
  isBootstrap ? null,
  isMinimalBuild ? (
    if isBootstrap != null then
      lib.warn "isBootstrap argument is deprecated and will be removed; use isMinimalBuild instead" isBootstrap
    else
      false
  ),
  useOpenSSL ? !isMinimalBuild,
  useSharedLibraries ? (!isMinimalBuild && !stdenv.hostPlatform.isCygwin),
  uiToolkits ? [ ], # can contain "ncurses" and/or "qt5"
  buildDocs ? !(isMinimalBuild || (uiToolkits == [ ])),
  libsForQt5,
  gitUpdater,
}:

let
  inherit (libsForQt5) qtbase wrapQtAppsHook;
  cursesUI = lib.elem "ncurses" uiToolkits;
  qt5UI = lib.elem "qt5" uiToolkits;
in
# Accepts only "ncurses" and "qt5" as possible uiToolkits
assert lib.subtractLists [ "ncurses" "qt5" ] uiToolkits == [ ];
# Minimal, bootstrap cmake does not have toolkits
assert isMinimalBuild -> (uiToolkits == [ ]);
stdenv.mkDerivation (finalAttrs: {
  pname =
    "cmake"
    + lib.optionalString isMinimalBuild "-minimal"
    + lib.optionalString cursesUI "-cursesUI"
    + lib.optionalString qt5UI "-qt5UI";
  version = "4.1.1";

  src = fetchurl {
    url = "https://cmake.org/files/v${lib.versions.majorMinor finalAttrs.version}/cmake-${finalAttrs.version}.tar.gz";
    hash = "sha256-sp9vGXM6oiS3djUHoQikJ+1Ixojh+vIrKcROHDBUkoI=";
  };

  patches = [
    # Add NIXPKGS_CMAKE_PREFIX_PATH to cmake which is like CMAKE_PREFIX_PATH
    # except it is not searched for programs
    ./nixpkgs-cmake-prefix-path.patch

    # Add the libc paths from the compiler wrapper.
    ./add-nixpkgs-libc-paths.patch
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (replaceVars ./darwin-binary-paths.patch {
      sw_vers = lib.getExe' darwin.DarwinTools "sw_vers";
      vm_stat = lib.getExe' darwin.system_cmds "vm_stat";
    })
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isFreeBSD) [
    (replaceVars ./darwin-bsd-binary-paths.patch {
      # `ps(1)` is theoretically used on Linux too, but only when
      # `/proc` is inaccessible, so we can skip the dependency.
      ps = lib.getExe ps;
      sysctl = lib.getExe sysctl;
    })
  ]
  ++ [
    # Backport of https://gitlab.kitware.com/cmake/cmake/-/merge_requests/11134
    ./fix-curl-8.16.patch

    # Remove references to non‐Nix search paths.
    ./remove-impure-search-paths.patch
  ];

  outputs = [
    "out"
  ]
  ++ lib.optionals buildDocs [
    "man"
    "info"
  ];
  separateDebugInfo = true;
  setOutputFlags = false;

  setupHooks = [
    ./setup-hook.sh
    ./check-pc-files-hook.sh
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs =
    finalAttrs.setupHooks
    ++ [
      pkg-config
    ]
    ++ lib.optionals buildDocs [ texinfo ]
    ++ lib.optionals qt5UI [ wrapQtAppsHook ];

  buildInputs =
    lib.optionals useSharedLibraries [
      bzip2
      curlMinimal
      expat
      libarchive
      xz
      zlib
      libuv
      rhash
    ]
    ++ lib.optional useOpenSSL openssl
    ++ lib.optional cursesUI ncurses
    ++ lib.optional qt5UI qtbase;

  preConfigure = ''
    substituteInPlace Modules/Platform/UnixPaths.cmake \
      --subst-var-by libc_bin ${lib.getBin stdenv.cc.libc} \
      --subst-var-by libc_dev ${lib.getDev stdenv.cc.libc} \
      --subst-var-by libc_lib ${lib.getLib stdenv.cc.libc}
    # CC_FOR_BUILD and CXX_FOR_BUILD are used to bootstrap cmake
    configureFlags="--parallel=''${NIX_BUILD_CORES:-1} CC=$CC_FOR_BUILD CXX=$CXX_FOR_BUILD $configureFlags $cmakeFlags"
  '';

  # The configuration script is not autoconf-based, although being similar;
  # triples and other interesting info are passed via CMAKE_* environment
  # variables and commandline switches
  configurePlatforms = [ ];

  configureFlags = [
    "--docdir=share/doc/${finalAttrs.pname}-${finalAttrs.version}"
  ]
  ++ (
    if useSharedLibraries then
      [
        "--no-system-cppdap"
        "--no-system-jsoncpp"
        "--system-libs"
      ]
    else
      [
        "--no-system-libs"
      ]
  ) # FIXME: cleanup
  ++ lib.optional qt5UI "--qt-gui"
  ++ lib.optionals buildDocs [
    "--sphinx-build=${sphinx}/bin/sphinx-build"
    "--sphinx-info"
    "--sphinx-man"
  ]
  ++ [
    "--"
    # We should set the proper `CMAKE_SYSTEM_NAME`.
    # http://www.cmake.org/Wiki/CMake_Cross_Compiling
    #
    # Unfortunately cmake seems to expect absolute paths for ar, ranlib, and
    # strip. Otherwise they are taken to be relative to the source root of the
    # package being built.
    (lib.cmakeFeature "CMAKE_CXX_COMPILER" "${stdenv.cc.targetPrefix}c++")
    (lib.cmakeFeature "CMAKE_C_COMPILER" "${stdenv.cc.targetPrefix}cc")
    (lib.cmakeFeature "CMAKE_AR" "${lib.getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}ar")
    (lib.cmakeFeature "CMAKE_RANLIB" "${lib.getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}ranlib")
    (lib.cmakeFeature "CMAKE_STRIP" "${lib.getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}strip")

    (lib.cmakeBool "CMAKE_USE_OPENSSL" useOpenSSL)
    (lib.cmakeBool "BUILD_CursesDialog" cursesUI)
  ];

  # make install attempts to use the just-built cmake
  preInstall = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    sed -i 's|bin/cmake|${buildPackages.cmakeMinimal}/bin/cmake|g' Makefile
  '';

  dontUseCmakeConfigure = true;
  enableParallelBuilding = true;

  doCheck = false; # fails

  passthru.updateScript = gitUpdater {
    url = "https://gitlab.kitware.com/cmake/cmake.git";
    rev-prefix = "v";
    ignoredVersions = "-"; # -rc1 and friends
  };

  meta = {
    homepage = "https://cmake.org/";
    description = "Cross-platform, open-source build system generator";
    longDescription = ''
      CMake is an open-source, cross-platform family of tools designed to build,
      test and package software. CMake is used to control the software
      compilation process using simple platform and compiler independent
      configuration files, and generate native makefiles and workspaces that can
      be used in the compiler environment of your choice.
    '';
    changelog = "https://cmake.org/cmake/help/v${lib.versions.majorMinor finalAttrs.version}/release/${lib.versions.majorMinor finalAttrs.version}.html";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      ttuegel
      lnl7
    ];
    platforms = lib.platforms.all;
    mainProgram = "cmake";
    broken = (qt5UI && stdenv.hostPlatform.isDarwin);
  };
})
