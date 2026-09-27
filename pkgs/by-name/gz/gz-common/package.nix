{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
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
}:
let
  version = "7.1.1";
  versionPrefix = "gz-common${lib.versions.major version}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gz-common";
  inherit version;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-common";
    tag = "${versionPrefix}_${finalAttrs.version}";
    hash = "sha256-0+C2gvX7vF/8DbRfX0rftbrYydO6zHYXAhWDe3YXWcs=";
  };

  patches = [
    # Replace FreeImage with STB image headers (vendored).
    # TODO: Remove after update to > 7.1.1
    (fetchpatch2 {
      url = "https://github.com/gazebosim/gz-common/commit/a2d36c050b8e93e23b3d8d5ec1abb7b87c61cfdc.patch?full_index=1";
      hash = "sha256-Zk6kFfWWSwNon/HcLDMmmO1XZrMUoPbc6bk0zAXXN9Y=";
    })

    # Replace hardcoded /home with /tmp in SystemPaths_TEST.cc FindFile test.
    # TODO: Remove after update to > 7.1.1
    (fetchpatch2 {
      url = "https://github.com/gazebosim/gz-common/commit/2d63d3f5b3f4b29418955a7c266a199f803e6d5c.patch?full_index=1";
      hash = "sha256-Gws0KVhfGd61uPNC1gJXlCaY81tVZeU6PlqcJA40LeA=";
    })
  ];

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

  preCheck = ''
    # Some test cases use $HOME
    export HOME=$(mktemp -d)
  '';

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
})
