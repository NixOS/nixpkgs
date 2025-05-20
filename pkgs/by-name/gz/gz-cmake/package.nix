{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doxygen,
  graphviz,
  pkg-config,
  python3,
  nix-update-script,
}:
let
  version = "4.2.0";
  versionPrefix = "gz-cmake${lib.versions.major version}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gz-cmake";
  inherit version;

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-cmake";
    tag = "${versionPrefix}_${finalAttrs.version}";
    hash = "sha256-+bMOcGWfcwPhxR9CBp4iH02CZC4oplCjsTDpPDsDnSs=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    pkg-config
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILDSYSTEM_TESTING" finalAttrs.doCheck)
  ];

  nativeCheckInputs = [ python3 ];

  # 98% tests passed, 1 tests failed out of 44
  # 44 - c_child_requires_c_nodep (Failed)
  #
  # Package gz-c_child_private was not found in the pkg-config search path.
  # Perhaps you should add the directory containing `gz-c_child_private.pc'
  # to the PKG_CONFIG_PATH environment variable
  # No package 'gz-c_child_private' found
  doCheck = false;

  # Extract the version by matching the tag's prefix.
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=${versionPrefix}_([\\d\\.]+)" ];
  };

  meta = {
    description = "CMake modules to build Gazebo projects";
    homepage = "https://github.com/gazebosim/gz-cmake";
    changelog = "https://github.com/gazebosim/gz-cmake/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ guelakais ];
  };
})
