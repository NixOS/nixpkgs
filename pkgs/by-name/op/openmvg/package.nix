{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  cereal,
  ceres-solver,
  clp,
  coin-utils,
  eigen,
  lemon-graph,
  libjpeg,
  libpng,
  libtiff,
  nix-update-script,
  llvmPackages,
  osi,
  zlib,
  enableShared ? !stdenv.hostPlatform.isStatic,
  enableExamples ? false,
  enableDocs ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.1";
  pname = "openmvg";

  src = fetchFromGitHub {
    owner = "openmvg";
    repo = "openmvg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vG+tW9Gl/DAUL8DeY+rJVDJH/oMPH3XyZMUgzjtwFv0=";
  };

  # Pretend we checked out the dependency submodules
  postPatch = ''
    mkdir src/dependencies/cereal/include
  '';

  buildInputs = [
    cereal
    ceres-solver
    clp
    coin-utils
    eigen
    lemon-graph
    libjpeg
    libpng
    libtiff
    llvmPackages.openmp
    osi
    zlib
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  # flann is missing because the lz4 dependency isn't propagated: https://github.com/openMVG/openMVG/issues/1265
  cmakeFlags = [
    (lib.cmakeBool "OpenMVG_BUILD_EXAMPLES" enableExamples)
    (lib.cmakeBool "OpenMVG_BUILD_DOC" enableDocs)
    (lib.cmakeFeature "TARGET_ARCHITECTURE" "generic")
    (lib.cmakeFeature "CLP_INCLUDE_DIR_HINTS" "${lib.getDev clp}/include")
    (lib.cmakeFeature "COINUTILS_INCLUDE_DIR_HINTS" "${lib.getDev coin-utils}/include")
    (lib.cmakeFeature "LEMON_INCLUDE_DIR_HINTS" "${lib.getDev lemon-graph}/include")
    (lib.cmakeFeature "OSI_INCLUDE_DIR_HINTS" "${lib.getDev osi}/include")

    # Compatibility with CMake < 3.5 has been removed from CMake.
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  ]
  ++ lib.optionals enableShared [
    (lib.cmakeBool "OpenMVG_BUILD_SHARED" true)
  ];

  cmakeDir = "./src";

  dontUseCmakeBuildDir = true;

  # This can be enabled, but it will exhause virtual memory on most machines.
  enableParallelBuilding = false;

  # Without hardeningDisable, certain flags are passed to the compile that break the build (primarily string format errors)
  hardeningDisable = [ "all" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Library for computer-vision scientists and targeted for the Multiple View Geometry community";
    homepage = "https://openmvg.readthedocs.io/en/latest/";
    downloadPage = "https://github.com/openMVG/openMVG";
    changelog = "https://github.com/openMVG/openMVG/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.unix;
    badPlatforms = [
      "x86_64-darwin"
    ];
    maintainers = with lib.maintainers; [
      mdaiter
      bouk
    ];
  };
})
