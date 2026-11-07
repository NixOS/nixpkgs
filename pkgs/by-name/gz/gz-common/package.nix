{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gz-cmake,
  gz-math,
  gz-utils,
  tinyxml-2,
  spdlog,
  libuuid,
  assimp,
  gdal,
  ffmpeg,
  zlib,
  ctestCheckHook,
  python3,
  gtest,
  nix-update-script,
  testers,
  writableTmpDirAsHomeHook,
}:
stdenv.mkDerivation (
  finalAttrs:
  let
    versionPrefix = "gz-common${lib.versions.major finalAttrs.version}";
  in
  {
    pname = "gz-common";
    version = "7.4.0";

    strictDeps = true;
    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "gazebosim";
      repo = "gz-common";
      tag = "${versionPrefix}_${finalAttrs.version}";
      hash = "sha256-XxAAva64aZWPk12H9dXioW/PmM42w5PSD8MnvM2dl5s=";
    };

    nativeBuildInputs = [
      cmake
      pkg-config
    ];

    buildInputs = [
      gz-cmake
      # direct DT_NEEDED of libgz-common-graphics.so (linked via assimp/gdal)
      zlib
    ];

    propagatedBuildInputs = [
      assimp
      ffmpeg
      gdal
      gz-math
      gz-utils
      spdlog
      tinyxml-2
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libuuid
    ];

    nativeCheckInputs = [
      ctestCheckHook
      python3
      writableTmpDirAsHomeHook
    ];

    checkInputs = [ gtest ];

    disabledTests = [
      # Timing-sensitive under Nix build load
      "INTEGRATION_encoder_timing"
      "UNIT_WorkerPool_TEST"
      # Signal handling is unreliable in the Nix sandbox
      "UNIT_SignalHandler_TEST"
    ];

    doCheck = true;

    passthru = {
      tests.pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
      };
      updateScript = nix-update-script {
        extraArgs = [ "--version-regex=${versionPrefix}_([\\d\\.]+)" ];
      };
    };

    meta = {
      description = "Common libraries for the Gazebo projects (audio, graphics, geospatial, AV)";
      homepage = "https://github.com/gazebosim/gz-common";
      changelog = "https://github.com/gazebosim/gz-common/blob/${finalAttrs.src.tag}/Changelog.md";
      license = lib.licenses.asl20;
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
      pkgConfigModules = [ "gz-common" ];
      maintainers = with lib.maintainers; [ taylorhoward92 ];
    };
  }
)
