{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  gz-cmake,
  gz-math,
  gz-tools,
  gz-utils,
  protobuf,
  tinyxml-2,
  python3Packages,
  ctestCheckHook,
  gtest,
  nix-update-script,
  testers,
}:
let
  version = "12.0.1";
  versionPrefix = "gz-msgs${lib.versions.major version}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gz-msgs";
  inherit version;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-msgs";
    tag = "${versionPrefix}_${finalAttrs.version}";
    hash = "sha256-XMzokmj6DXiDtbE/FNK+j4qllm7IsmE8vZsQSXEQNIs=";
  };

  nativeBuildInputs = [
    cmake
    python3Packages.python
  ];

  propagatedNativeBuildInputs = [
    protobuf
  ];

  buildInputs = [
    gz-cmake
  ];

  propagatedBuildInputs = [
    gz-math
    gz-tools
    gz-utils
    protobuf
    tinyxml-2
  ];

  nativeCheckInputs = [
    ctestCheckHook
    python3Packages.python
    python3Packages.protobuf
  ];

  checkInputs = [ gtest ];

  patches = [
    # Use ENVIRONMENT_MODIFICATION (prepend) instead of ENVIRONMENT (overwrite)
    # for Python test PYTHONPATH — fixes broken CMAKE_INSTALL_PREFIX paths
    # and allows the shell env to provide dependency paths.
    # https://github.com/gazebosim/gz-msgs/pull/588 (backport of #584)
    (fetchpatch2 {
      url = "https://github.com/gazebosim/gz-msgs/commit/aac2461dfa3210b5939a1a71da8918b6033311cc.patch?full_index=1";
      hash = "sha256-lELP0hYB8DBcBcjRIfr6TgVl0lpQxilQQmay3Apy+oA=";
    })
  ];

  preCheck = ''
    # Python tests need generated protobuf bindings from the build tree and
    # google.protobuf from the Nix store, neither of which is on PYTHONPATH
    # by default in the sandbox.
    export PYTHONPATH=$PWD/gz_msgs_gen/python:${python3Packages.protobuf}/${python3Packages.python.sitePackages}:$PYTHONPATH
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
    description = "Protobuf messages for the Gazebo robot simulation libraries";
    homepage = "https://github.com/gazebosim/gz-msgs";
    changelog = "https://github.com/gazebosim/gz-msgs/blob/${finalAttrs.src.tag}/Changelog.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    pkgConfigModules = [ "gz-msgs" ];
    maintainers = with lib.maintainers; [ taylorhoward92 ];
  };
})
