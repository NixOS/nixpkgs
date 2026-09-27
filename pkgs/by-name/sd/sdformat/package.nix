{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
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
let
  version = "16.0.1";
  versionPrefix = "sdformat${lib.versions.major version}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sdformat";
  inherit version;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "sdformat";
    tag = "${versionPrefix}_${finalAttrs.version}";
    hash = "sha256-WhbPVzlR8p89bqtzqGjfGJbTjOHjdlm7mMxhvyHmZjA=";
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
    ruby
  ];

  checkInputs = [ gtest ];

  patches = [
    # Use ENVIRONMENT_MODIFICATION (prepend) instead of ENVIRONMENT (overwrite)
    # for Python test PYTHONPATH — fixes broken CMAKE_INSTALL_PREFIX paths
    # and allows the shell env to provide dependency paths.
    # TODO: Remove after update to > 16.0.1
    (fetchpatch2 {
      url = "https://github.com/gazebosim/sdformat/commit/855596c16fa34fe0fd18b883249a77402a1943c9.patch?full_index=1";
      hash = "sha256-9lYlcaU0BoHqYB1riS3IzERMtbL5/xZDl9c7v+15DHQ=";
    })
  ];

  preCheck = ''
    # Python tests import gz-math bindings, which live in Nix store paths
    # not on any default search path in the sandbox.
    export PYTHONPATH=${gz-math}/lib/python/:$PYTHONPATH
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
    description = "Simulation Description Format (SDF) parser and description files";
    homepage = "https://sdformat.org/";
    changelog = "https://github.com/gazebosim/sdformat/blob/${finalAttrs.src.tag}/Changelog.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    pkgConfigModules = [ "sdformat" ];
    maintainers = with lib.maintainers; [ taylorhoward92 ];
  };
})
