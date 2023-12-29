{ lib
, stdenv
, fetchurl
, buildPackages
, bzip2
, curlMinimal
, expat
, libarchive
, libuv
, ncurses
, openssl
, pkg-config
, ps
, rhash
, sphinx
, texinfo
, xz
, zlib
, isBootstrap ? null
, isMinimalBuild ? (
  if isBootstrap != null
  then lib.warn
    "isBootstrap argument is deprecated and will be removed; use isMinimalBuild instead"
    isBootstrap
  else false)
, useOpenSSL ? !isMinimalBuild
, useSharedLibraries ? (!isMinimalBuild && !stdenv.isCygwin)
, uiToolkits ? [] # can contain "ncurses" and/or "qt5"
, buildDocs ? !(isMinimalBuild || (uiToolkits == []))
, darwin
, libsForQt5
}:

let
  inherit (darwin.apple_sdk.frameworks) SystemConfiguration;
  inherit (libsForQt5) qtbase wrapQtAppsHook;
  cursesUI = lib.elem "ncurses" uiToolkits;
  qt5UI = lib.elem "qt5" uiToolkits;
in
# Accepts only "ncurses" and "qt5" as possible uiToolkits
assert lib.subtractLists [ "ncurses" "qt5" ] uiToolkits == [];
# Minimal, bootstrap cmake does not have toolkits
assert isMinimalBuild -> (uiToolkits == []);
stdenv.mkDerivation (finalAttrs: {
  pname = "cmake"
    + lib.optionalString isMinimalBuild "-minimal"
    + lib.optionalString cursesUI "-cursesUI"
    + lib.optionalString qt5UI "-qt5UI";
  version = "3.27.8";

  src = fetchurl {
    url = "https://cmake.org/files/v${lib.versions.majorMinor finalAttrs.version}/cmake-${finalAttrs.version}.tar.gz";
    hash = "sha256-/s4kVj9peHD7uYLqi/F0gsnV+FXYyb8LgkY9dsno0Mw=";
  };

  patches = [
    # Don't search in non-Nix locations such as /usr, but do search in our libc.
    ./001-search-path.diff
    # Don't depend on frameworks.
    ./002-application-services.diff
    # Derived from https://github.com/libuv/libuv/commit/1a5d4f08238dd532c3718e210078de1186a5920d
    ./003-libuv-application-services.diff
  ]
  ++ lib.optional stdenv.isCygwin ./004-cygwin.diff
  # Derived from https://github.com/curl/curl/commit/31f631a142d855f069242f3e0c643beec25d1b51
  ++ lib.optional (stdenv.isDarwin && isMinimalBuild) ./005-remove-systemconfiguration-dep.diff
  # On Darwin, always set CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG.
  ++ lib.optional stdenv.isDarwin ./006-darwin-always-set-runtime-c-flag.diff;

  outputs = [ "out" ] ++ lib.optionals buildDocs [ "man" "info" ];
  setOutputFlags = false;

  setupHooks = [
    ./setup-hook.sh
    ./check-pc-files-hook.sh
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = finalAttrs.setupHooks ++ [
    pkg-config
  ]
  ++ lib.optionals buildDocs [ texinfo ]
  ++ lib.optionals qt5UI [ wrapQtAppsHook ];

  buildInputs = lib.optionals useSharedLibraries [
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
  ++ lib.optional qt5UI qtbase
  ++ lib.optional (stdenv.isDarwin && !isMinimalBuild) SystemConfiguration;

  propagatedBuildInputs = lib.optional stdenv.isDarwin ps;

  preConfigure = ''
    fixCmakeFiles .
    substituteInPlace Modules/Platform/UnixPaths.cmake \
      --subst-var-by libc_bin ${lib.getBin stdenv.cc.libc} \
      --subst-var-by libc_dev ${lib.getDev stdenv.cc.libc} \
      --subst-var-by libc_lib ${lib.getLib stdenv.cc.libc}
    # CC_FOR_BUILD and CXX_FOR_BUILD are used to bootstrap cmake
    configureFlags="--parallel=''${NIX_BUILD_CORES:-1} CC=$CC_FOR_BUILD CXX=$CXX_FOR_BUILD $configureFlags"
  '';

  # The configuration script is not autoconf-based, although being similar;
  # triples and other interesting info are passed via CMAKE_* environment
  # variables and commandline switches
  configurePlatforms = [ ];

  configureFlags = [
    "CXXFLAGS=-Wno-elaborated-enum-base"
    "--docdir=share/doc/${finalAttrs.pname}-${finalAttrs.version}"
  ] ++ (if useSharedLibraries
        then [
          "--no-system-cppdap"
          "--no-system-jsoncpp"
          "--system-libs"
        ]
        else [
          "--no-system-libs"
        ]) # FIXME: cleanup
  ++ lib.optional qt5UI "--qt-gui"
  ++ lib.optionals buildDocs [
    "--sphinx-build=${sphinx}/bin/sphinx-build"
    "--sphinx-info"
    "--sphinx-man"
  ]
  # Workaround https://gitlab.kitware.com/cmake/cmake/-/issues/20568
  ++ lib.optionals stdenv.hostPlatform.is32bit [
    "CFLAGS=-D_FILE_OFFSET_BITS=64"
    "CXXFLAGS=-D_FILE_OFFSET_BITS=64"
  ]
  # Workaround missing atomic ops with gcc <13
  ++ lib.optional stdenv.hostPlatform.isRiscV "LDFLAGS=-latomic"
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
    (lib.cmakeFeature "CMAKE_AR"
      "${lib.getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}ar")
    (lib.cmakeFeature "CMAKE_RANLIB"
      "${lib.getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}ranlib")
    (lib.cmakeFeature "CMAKE_STRIP"
      "${lib.getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}strip")

    (lib.cmakeBool "CMAKE_USE_OPENSSL" useOpenSSL)
    (lib.cmakeBool "BUILD_CursesDialog" cursesUI)
  ];

  # `pkgsCross.musl64.cmake.override { stdenv = pkgsCross.musl64.llvmPackages_16.libcxxStdenv; }`
  # fails with `The C++ compiler does not support C++11 (e.g.  std::unique_ptr).`
  # The cause is a compiler warning `warning: argument unused during compilation: '-pie' [-Wunused-command-line-argument]`
  # interfering with the feature check.
  env.NIX_CFLAGS_COMPILE = "-Wno-unused-command-line-argument";

  # make install attempts to use the just-built cmake
  preInstall = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    sed -i 's|bin/cmake|${buildPackages.cmakeMinimal}/bin/cmake|g' Makefile
  '';

  dontUseCmakeConfigure = true;
  enableParallelBuilding = true;

  doCheck = false; # fails

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
    maintainers = with lib.maintainers; [ ttuegel lnl7 AndersonTorres ];
    platforms = lib.platforms.all;
    broken = (qt5UI && stdenv.isDarwin);
  };
})
