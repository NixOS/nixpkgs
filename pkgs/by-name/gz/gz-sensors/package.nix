{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gz-cmake,
  gz-common,
  gz-math,
  gz-msgs,
  gz-rendering,
  gz-transport,
  sdformat,
  gz-utils,
  eigen,
  protobuf,
  ctestCheckHook,
  python3,
  gtest,
  testers,
  nix-update-script,
}:
let
  version = "10.0.1";
  versionPrefix = "gz-sensors${lib.versions.major version}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gz-sensors";
  inherit version;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-sensors";
    tag = "${versionPrefix}_${finalAttrs.version}";
    hash = "sha256-dBeqnONAV8SedLPirehY7KPvf/Ae9ux7Tda2eH1vM7E=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
  ];

  buildInputs = [
    gz-cmake
  ];

  propagatedBuildInputs = [
    gz-common
    gz-math
    gz-msgs
    gz-rendering
    gz-transport
    sdformat
    gz-utils
    eigen
    protobuf
  ];

  cmakeFlags = [
    # Requires GPU/display server (unavailable in Nix sandbox);
    # non-rendering tests (air_pressure, altimeter, imu, etc.) still run.
    "-DDRI_TESTS=OFF"
  ];

  nativeCheckInputs = [
    ctestCheckHook
    python3
  ];

  checkInputs = [ gtest ];

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
    description = "Sensor models for robot simulation with Gazebo";
    homepage = "https://github.com/gazebosim/gz-sensors";
    changelog = "https://github.com/gazebosim/gz-sensors/blob/${finalAttrs.src.tag}/Changelog.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    pkgConfigModules = [ "gz-sensors" ];
    maintainers = with lib.maintainers; [ taylorhoward92 ];
  };
})
