{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gz-cmake,
  gz-math,
  gz-utils,
  tinyxml-2,
  python3Packages,
  ruby,
  ctestCheckHook,
  gtest,
  nix-update-script,
  testers,
}:
stdenv.mkDerivation (
  finalAttrs:
  let
    versionPrefix = "sdformat${lib.versions.major finalAttrs.version}";
  in
  {
    pname = "sdformat";
    version = "16.1.0";

    strictDeps = true;
    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "gazebosim";
      repo = "sdformat";
      tag = "${versionPrefix}_${finalAttrs.version}";
      hash = "sha256-iZ1it91NCJ8xUohp4WyoDfSEYGfp4MWT2DrtYCwjgjs=";
    };

    nativeBuildInputs = [
      cmake
      python3Packages.python
      python3Packages.pybind11
    ];

    buildInputs = [
      gz-cmake
    ];

    propagatedBuildInputs = [
      gz-math
      gz-utils
      tinyxml-2
    ];

    nativeCheckInputs = [
      ctestCheckHook
      python3Packages.python
      python3Packages.gz-math
      ruby
    ];

    checkInputs = [ gtest ];

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
      description = "Simulation Description Format (SDF) parser and description files";
      homepage = "https://sdformat.org/";
      changelog = "https://github.com/gazebosim/sdformat/blob/${finalAttrs.src.tag}/Changelog.md";
      license = lib.licenses.asl20;
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
      pkgConfigModules = [ "sdformat" ];
      maintainers = with lib.maintainers; [ taylorhoward92 ];
    };
  }
)
