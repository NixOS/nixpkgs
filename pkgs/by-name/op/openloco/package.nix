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
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    sdl3
    libpng
    libzip
    openal
    yaml-cpp
    fmt_11
    libx11
  ];

  cmakeFlags = [
    (lib.cmakeBool "OPENLOCO_BUILD_TESTS" false)
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=null-dereference";
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

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
      keenanweaver
    ];
    platforms = lib.platforms.linux;
    mainProgram = "OpenLoco";
  };
})
