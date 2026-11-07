{
  lib,
  stdenv,
  fetchFromGitHub,
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
stdenv.mkDerivation (
  finalAttrs:
  let
    versionPrefix = "gz-transport${lib.versions.major finalAttrs.version}";
  in
  {
    pname = "gz-transport";
    version = "15.1.0";

    strictDeps = true;
    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "gazebosim";
      repo = "gz-transport";
      tag = "${versionPrefix}_${finalAttrs.version}";
      hash = "sha256-a+PbuwTZ9zFRAJmnrbqmEpbecoetPat6LiAITP4sV2E=";
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
      python3Packages.gz-msgs
      python3Packages.protobuf
    ];

    postPatch = ''
      # The gz_TEST.cc bash-completion tests hardcode /usr/bin/bash which
      # doesn't exist in the Nix sandbox.
      substituteInPlace src/cmd/gz_TEST.cc \
        --replace-fail '/usr/bin/bash' '${stdenv.shell}'
    '';

    checkInputs = [ gtest ];

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
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) [
      # These multi-process tests hang until the 240s ctest timeout, while
      # their Stress/Sync1 variants pass in seconds.
      "INTEGRATION_authPubSub"
      "INTEGRATION_playback"
      "INTEGRATION_recorder"
      "INTEGRATION_twoProcsPubSub"
      "INTEGRATION_twoProcsPubSubStats"
      "INTEGRATION_twoProcsSrvCall"
      "INTEGRATION_twoProcsSrvCallWithoutInput"
      "INTEGRATION_twoProcsSrvCallWithoutOutput"
    ];

    preCheck = ''
      # Python tests import gz.transport from the pybind11 module in the build
      # tree; give it the same package layout the installed bindings have.
      local pydir=$(mktemp -d)
      mkdir -p $pydir/gz/transport
      cp lib/_transport* $pydir/gz/transport/
      cp ../python/src/__init__.py $pydir/gz/transport/
      export PYTHONPATH=$pydir''${PYTHONPATH:+:$PYTHONPATH}
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
  }
)
