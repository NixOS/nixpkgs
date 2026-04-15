{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
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
  zlib,
  ctestCheckHook,
  python3,
  gtest,
  nix-update-script,
  testers,
}:
let
  version = "9.1.0";
  versionPrefix = "gz-physics${lib.versions.major version}";
  ldLibraryPathEnv = if stdenv.hostPlatform.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gz-physics";
  inherit version;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-physics";
    tag = "${versionPrefix}_${finalAttrs.version}";
    hash = "sha256-9JM/vtDOOfwpmc4cu1XEE0FSgaYBaLAD7dCvqI7MuMY=";
  };

  patches = [
    # Fix bullet-featherstone CastTo*Shape failures on macOS when Bullet is linked
    # as a shared library: replaces dynamic_cast (broken by RTTI fragmentation under
    # RTLD_LOCAL + -fvisibility=hidden) with Bullet's getShapeType() enum.
    # TODO: Remove after update to > 9.1.0
    (fetchpatch2 {
      url = "https://github.com/gazebosim/gz-physics/commit/260e8938dfba398101b97f546ccb834f8e1aeb49.patch?full_index=1";
      hash = "sha256-jXBKrTmskXLTth09sNUSIEQ4lybkUP0HuaiOLxOV9GA=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  # Nix sets CMAKE_INSTALL_LIBDIR to an absolute store path, which produces
  # broken doubled paths in getEngineInstallDir().  Force it to be relative.
  cmakeFlags = [ "-DCMAKE_INSTALL_LIBDIR=lib" ];

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

  preCheck = ''
    # Some test cases use $HOME
    export HOME=$(mktemp -d)

    # Plugin shared libraries in the build tree need dartsim/bullet libs on the linker path.
    export ${ldLibraryPathEnv}=${
      lib.makeLibraryPath [
        dartsim
        bullet
        zlib
      ]
    }''${${ldLibraryPathEnv}:+:$${ldLibraryPathEnv}}
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
    description = "Abstract physics interface designed for robot simulation";
    homepage = "https://github.com/gazebosim/gz-physics";
    changelog = "https://github.com/gazebosim/gz-physics/blob/${finalAttrs.src.tag}/Changelog.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    pkgConfigModules = [ "gz-physics" ];
    maintainers = with lib.maintainers; [ taylorhoward92 ];
  };
})
