{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gz-cmake,
  gz-common,
  gz-math,
  gz-plugin,
  gz-utils,
  sdformat,
  eigen,
  dartsim,
  bullet,
  spdlog,
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
    versionPrefix = "gz-physics${lib.versions.major finalAttrs.version}";
  in
  {
    pname = "gz-physics";
    version = "9.5.1";

    strictDeps = true;
    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "gazebosim";
      repo = "gz-physics";
      tag = "${versionPrefix}_${finalAttrs.version}";
      hash = "sha256-y4i5RBbdEW/vvPeMHCXDa1V0p9a+grAJop77xiD+WkA=";
    };

    nativeBuildInputs = [
      cmake
      pkg-config
    ];

    # Nix sets CMAKE_INSTALL_LIBDIR to an absolute store path, which produces
    # broken doubled paths in getEngineInstallDir().  Force it to be relative.
    cmakeFlags = [ (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib") ];

    buildInputs = [
      gz-cmake
    ];

    propagatedBuildInputs = [
      bullet
      dartsim
      gz-common
      gz-math
      gz-plugin
      gz-utils
      sdformat
      eigen
      spdlog
    ];

    nativeCheckInputs = [
      ctestCheckHook
      python3
      writableTmpDirAsHomeHook
    ];

    checkInputs = [ gtest ];

    postPatch = ''
      # Fix shebang in testrunner.bash (uses #!/bin/bash which doesn't exist in sandbox).
      patchShebangs test/static_assert/testrunner.bash
    '';

    disabledTests = [
      # Dartsim/bullet tolerance-based assertions too tight for sandbox builds.
      "COMMON_TEST_detachable_joint_dartsim"
      "COMMON_TEST_joint_features_dartsim"
      "UNIT_SDFFeatures_TEST"
      # Performance benchmark — timing-sensitive under Nix build load
      "PERFORMANCE_ExpectData"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
      # Dartsim mesh-plane collision test crashes with SIGTRAP on aarch64-darwin.
      # Upstream CI passes because Bazel statically links everything into one binary.
      # In Nix, the dartsim plugin is a shared library loaded via dlopen(RTLD_LOCAL),
      # which causes RTTI fragmentation on macOS.
      "COMMON_TEST_collisions_dartsim"
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
      description = "Abstract physics interface designed for robot simulation";
      homepage = "https://github.com/gazebosim/gz-physics";
      changelog = "https://github.com/gazebosim/gz-physics/blob/${finalAttrs.src.tag}/Changelog.md";
      license = lib.licenses.asl20;
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
      pkgConfigModules = [ "gz-physics" ];
      maintainers = with lib.maintainers; [ taylorhoward92 ];
    };
  }
)
