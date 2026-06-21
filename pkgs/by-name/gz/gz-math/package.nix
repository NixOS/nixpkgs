{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gz-cmake,
  gz-utils,
  eigen,
  python3Packages,
  swig,
  ruby,
  ctestCheckHook,
  gtest,
  testers,
  nix-update-script,
}:
let
  version = "9.1.0";
  versionPrefix = "gz-math${lib.versions.major version}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gz-math";
  inherit version;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-math";
    tag = "${versionPrefix}_${finalAttrs.version}";
    hash = "sha256-Kc9g5D52+NVygYLpMf+4GFPPn2sTEfXBOC14iw39NlA=";
  };

  nativeBuildInputs = [
    cmake
    python3Packages.python
    python3Packages.pybind11
    swig
    ruby
  ];

  buildInputs = [
    gz-cmake
  ];

  propagatedBuildInputs = [
    eigen
    gz-utils
  ];

  nativeCheckInputs = [
    ctestCheckHook
    python3Packages.python
  ];

  checkInputs = [ gtest ];

  disabledTests = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    # Non-deterministic random tests fail on aarch64-darwin
    "GaussMarkovProcess_TEST.rb"
    "Rand_TEST.rb"
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
    description = "General purpose math library for robot applications";
    homepage = "https://github.com/gazebosim/gz-math";
    changelog = "https://github.com/gazebosim/gz-math/blob/${finalAttrs.src.tag}/Changelog.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    pkgConfigModules = [ "gz-math" ];
    maintainers = with lib.maintainers; [ taylorhoward92 ];
  };
})
