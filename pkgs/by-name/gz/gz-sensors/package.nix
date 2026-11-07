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
  mesa,
  ctestCheckHook,
  python3,
  gtest,
  testers,
  nix-update-script,
}:
stdenv.mkDerivation (
  finalAttrs:
  let
    versionPrefix = "gz-sensors${lib.versions.major finalAttrs.version}";
  in
  {
    pname = "gz-sensors";
    version = "10.1.1";

    strictDeps = true;
    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "gazebosim";
      repo = "gz-sensors";
      tag = "${versionPrefix}_${finalAttrs.version}";
      hash = "sha256-rSfTxdEpeFkhg3NMvGgc9PrMal3qkUuLW7R/FCLOd/w=";
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
      # Rendering tests run on Mesa's llvmpipe through ogre-next's headless EGL
      # backend (see preCheck), so no GPU or display server is needed.
      (lib.cmakeBool "DRI_TESTS" stdenv.hostPlatform.isLinux)
    ];

    nativeCheckInputs = [
      ctestCheckHook
      python3
    ];

    checkInputs = [ gtest ] ++ lib.optionals stdenv.hostPlatform.isLinux [ mesa ];

    # The rendering tests share gz-transport topic names (e.g. /camera3/camera_info
    # in both camera and depth_camera) within one partition, so running them in
    # parallel makes them read each other's messages.
    enableParallelChecking = !stdenv.hostPlatform.isLinux;

    preCheck = lib.optionalString stdenv.hostPlatform.isLinux ''
      export __EGL_VENDOR_LIBRARY_FILENAMES=${mesa}/share/glvnd/egl_vendor.d/50_mesa.json
    '';

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
  }
)
