{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gz-cmake,
  gz-utils,
  ctestCheckHook,
  python3,
  gtest,
  nix-update-script,
  testers,
}:
let
  version = "4.0.0";
  versionPrefix = "gz-plugin${lib.versions.major version}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gz-plugin";
  inherit version;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-plugin";
    tag = "${versionPrefix}_${finalAttrs.version}";
    hash = "sha256-cHpRXLKm3BHJJibL5VdLMHyRYAD3gLP7ageyFY13tZE=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    gz-cmake
  ];

  propagatedBuildInputs = [
    gz-utils
  ];

  nativeCheckInputs = [
    ctestCheckHook
    python3
  ];

  checkInputs = [ gtest ];

  postPatch = ''
    # Fix shebang in testrunner.bash (uses #!/bin/bash which doesn't exist in sandbox)
    patchShebangs test/static_assertions/testrunner.bash
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
    description = "Cross-platform C++ library for dynamically loading plugins";
    homepage = "https://github.com/gazebosim/gz-plugin";
    changelog = "https://github.com/gazebosim/gz-plugin/blob/${finalAttrs.src.tag}/Changelog.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    pkgConfigModules = [ "gz-plugin" ];
    maintainers = with lib.maintainers; [ taylorhoward92 ];
  };
})
