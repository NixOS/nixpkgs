{
  lib,
  stdenv,
  fetchFromGitHub,
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
stdenv.mkDerivation (
  finalAttrs:
  let
    versionPrefix = "gz-msgs${lib.versions.major finalAttrs.version}";
  in
  {
    pname = "gz-msgs";
    version = "12.0.2";

    strictDeps = true;
    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "gazebosim";
      repo = "gz-msgs";
      tag = "${versionPrefix}_${finalAttrs.version}";
      hash = "sha256-yKuD08jZtQmtCWO/TvLngqhRVAbu4bZC9B4e9KxKr4M=";
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

    preCheck = ''
      # Python tests import the protobuf bindings generated in the build tree.
      export PYTHONPATH=$PWD/gz_msgs_gen/python''${PYTHONPATH:+:$PYTHONPATH}
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
  }
)
