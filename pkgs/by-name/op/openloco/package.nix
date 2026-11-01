{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  cmake,
  fmt_11,
  libpng,
  libx11,
  libzip,
  llvmPackages,
  makeBinaryWrapper,
  openal,
  pkg-config,
  sdl3,
  versionCheckHook,
  yaml-cpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openloco";
  version = "26.09";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "OpenLoco";
    repo = "OpenLoco";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qAppsd/aznLs2HMfbGg+mKx6RwFeJCrYL7qxXc+UdWc=";
  };

  postPatch = ''
    # the upstream build process determines the version tag, branch
    # and commit hash from git; since we are not using a git checkout,
    # we patch it manually
    substituteInPlace src/Version/include/OpenLoco/Version.hpp \
      --replace-fail '#define OPENLOCO_NAME "OpenLoco"' '#define OPENLOCO_NAME "OpenLoco"
    #define OPENLOCO_VERSION_TAG "${finalAttrs.version}"
    #define OPENLOCO_BRANCH "master"
    #define OPENLOCO_COMMIT_SHA1_SHORT "${finalAttrs.passthru.commit}"'

    # prefetch sfl header sources
    substituteInPlace thirdparty/CMakeLists.txt \
      --replace-fail 'GIT_REPOSITORY      https://github.com/slavenf/sfl-library' \
                     'SOURCE_DIR ${finalAttrs.passthru.sfl}' \
      --replace-fail 'GIT_TAG             ${finalAttrs.passthru.sfl-version}' ""

    # prefetch openloco-objects
    substituteInPlace CMakeLists.txt \
      --replace-fail '${finalAttrs.passthru.objects.url}' '${finalAttrs.passthru.objects}'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # the app bundle's Info.plist takes its version from the git-derived cmake variables
    substituteInPlace cmake/OpenLocoVersion.cmake \
      --replace-fail 'set(OPENLOCO_VERSION_TAG "unknown")' 'set(OPENLOCO_VERSION_TAG "${finalAttrs.version}")' \
      --replace-fail 'set(OPENLOCO_BRANCH "unknown")' 'set(OPENLOCO_BRANCH "master")' \
      --replace-fail 'set(OPENLOCO_COMMIT_SHA1_SHORT "unknown")' 'set(OPENLOCO_COMMIT_SHA1_SHORT "${finalAttrs.passthru.commit}")'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeBinaryWrapper
  ];

  buildInputs = [
    sdl3
    libpng
    libzip
    openal
    yaml-cpp
    fmt_11
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libx11
  ];

  cmakeFlags = [
    (lib.cmakeBool "OPENLOCO_BUILD_TESTS" false)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # used for LSMinimumSystemVersion in Info.plist
    (lib.cmakeFeature "MACOSX_DEPLOYMENT_TARGET" stdenv.hostPlatform.darwinMinVersion)
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=null-dereference";

  # upstream builds with -fexperimental-library on darwin for std::execution::par.
  # The SDK's libc++ headers select the libdispatch PSTL backend, whose out-of-line
  # parts live in libc++experimental.a, which nixpkgs does not ship for darwin
  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    $CXX -std=c++20 -fexperimental-library -O2 -c \
      ${llvmPackages.libcxx.src}/libcxx/src/pstl/libdispatch.cpp -o "$NIX_BUILD_TOP/libdispatch.o"
    $AR rcs "$NIX_BUILD_TOP/libc++experimental.a" "$NIX_BUILD_TOP/libdispatch.o"
    export NIX_LDFLAGS+=" -L$NIX_BUILD_TOP"
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications $out/bin
    mv $out/OpenLoco.app $out/Applications/
    makeWrapper $out/Applications/OpenLoco.app/Contents/MacOS/OpenLoco $out/bin/OpenLoco
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  # the user directory under ~/Library is created on startup, even for --version,
  # and Foundation ignores $HOME when resolving it
  preInstallCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export CFFIXED_USER_HOME="$(mktemp -d)"
  '';
  versionCheckKeepEnvironment = lib.optionals stdenv.hostPlatform.isDarwin [ "CFFIXED_USER_HOME" ];

  passthru = {
    commit = "ec72a7d";
    objects-version = "0.1.12";
    sfl-version = "2.2.0";

    objects = fetchurl {
      url = "https://github.com/OpenLoco/OpenGraphics/releases/download/v${finalAttrs.passthru.objects-version}/objects.zip";
      hash = "sha256-nmWWqqUrIpbPx3m746qwHQ+zfvYfyyPNDl/00rnoRso=";
    };
    sfl = fetchFromGitHub {
      owner = "slavenf";
      repo = "sfl-library";
      tag = finalAttrs.passthru.sfl-version;
      hash = "sha256-U1InclhSF3pte2AhKUVYBYOXZagksDMkUWgFn5ZB/tk=";
    };

    updateScript = ./update.sh;
  };

  meta = {
    description = "Open source re-implementation of Chris Sawyer's Locomotion";
    homepage = "https://openloco.io/";
    changelog = "https://github.com/OpenLoco/OpenLoco/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      icewind1991
      iedame
      keenanweaver
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "OpenLoco";
  };
})
