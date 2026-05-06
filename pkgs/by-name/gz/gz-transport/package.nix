{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  pkg-config,
  gz-cmake,
  gz-msgs,
  gz-utils,
  protobuf,
  zeromq,
  cppzmq,
  sqlite,
  libsodium,
  libuuid,
  python3Packages,
  ctestCheckHook,
  gtest,
  nix-update-script,
  testers,
}:
let
  version = "15.0.2";
  versionPrefix = "gz-transport${lib.versions.major version}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gz-transport";
  inherit version;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-transport";
    tag = "${versionPrefix}_${finalAttrs.version}";
    hash = "sha256-9ple0Bz3tFno/ZjUi7f2dqU06g81W8w0IeIzRFrA0s8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
    python3Packages.python
    python3Packages.pybind11
  ];

  buildInputs = [
    gz-cmake
    # direct DT_NEEDED of libgz-transport.so (linked via zeromq)
    libsodium
  ];

  propagatedBuildInputs = [
    gz-msgs
    gz-utils
    protobuf
    zeromq
    cppzmq
    sqlite
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libuuid
  ];

  nativeCheckInputs = [
    ctestCheckHook
    python3Packages.python
    python3Packages.protobuf
  ];

  postPatch = ''
    # The gz_TEST.cc bash-completion tests hardcode /usr/bin/bash which
    # doesn't exist in the Nix sandbox.
    substituteInPlace src/cmd/gz_TEST.cc \
      --replace-fail '/usr/bin/bash' '${stdenv.shell}'
  '';

  checkInputs = [ gtest ];

  patches = [
    # Use ENVIRONMENT_MODIFICATION (prepend) instead of ENVIRONMENT (overwrite)
    # for Python test PYTHONPATH — fixes broken CMAKE_INSTALL_PREFIX paths
    # and allows the shell env to provide dependency paths.
    # https://github.com/gazebosim/gz-transport/pull/860 (backport of #849)
    (fetchpatch2 {
      url = "https://github.com/gazebosim/gz-transport/commit/c589565d9708f2e59ebbd546c0ddc00674242b29.patch?full_index=1";
      hash = "sha256-KFBX7waIeT+XG+htTyGMRkAplY5Jwq/aofxG3SrdWaI=";
    })
  ];

  disabledTests = [
    # Timing-sensitive under Nix build load
    "INTEGRATION_twoProcsSrvCallSync1"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    # Timing-sensitive under Nix build load
    "INTEGRATION_twoProcsPubSub"
    "INTEGRATION_playback"
    "INTEGRATION_recorder"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    # Timing-sensitive under Nix build load
    "INTEGRATION_twoProcsPubSubStats"
    "INTEGRATION_twoProcsSrvCallStress"
    "INTEGRATION_twoProcsSrvCallSync1"
    "INTEGRATION_twoProcsSrvCallWithoutInput"
    "INTEGRATION_twoProcsSrvCallWithoutInputSync1"
    "INTEGRATION_twoProcsSrvCallWithoutInputStress"
    "INTEGRATION_twoProcsSrvCallWithoutOutput"
    "UNIT_Node_TEST"
    "UNIT_gz_TEST"
  ];

  preCheck = ''
    # Set up Python package structure for build-tree pybind11 module so tests can
    # import gz.transport. Merge with gz-msgs to handle the gz namespace package.
    local pydir=$(mktemp -d)
    mkdir -p $pydir/gz/transport
    cp $PWD/lib/_transport* $pydir/gz/transport/
    if [ -f $NIX_BUILD_TOP/source/python/gz/transport/__init__.py ]; then
      cp $NIX_BUILD_TOP/source/python/gz/transport/__init__.py $pydir/gz/transport/
    else
      echo "from gz.transport._transport import *" > $pydir/gz/transport/__init__.py
    fi

    # Symlink gz-msgs into the same gz namespace so Python can find both
    ln -s ${gz-msgs}/lib/python/gz/msgs $pydir/gz/msgs
    export PYTHONPATH=$pydir:${python3Packages.protobuf}/${python3Packages.python.sitePackages}:$PYTHONPATH
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
    description = "Communication library for robot simulation using publish/subscribe and services";
    homepage = "https://github.com/gazebosim/gz-transport";
    changelog = "https://github.com/gazebosim/gz-transport/blob/${finalAttrs.src.tag}/Changelog.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    pkgConfigModules = [ "gz-transport" ];
    maintainers = with lib.maintainers; [ taylorhoward92 ];
  };
})
