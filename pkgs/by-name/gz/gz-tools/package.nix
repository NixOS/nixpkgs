{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gz-cmake,
  ruby,
  testers,
  nix-update-script,
}:
let
  version = "2.0.3";
  versionPrefix = "gz-tools${lib.versions.major version}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gz-tools";
  inherit version;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-tools";
    tag = "${versionPrefix}_${finalAttrs.version}";
    hash = "sha256-xMFJylj7OnDc7zVWiI4a/mvNpu9scz83F3bGopCt8l8=";
  };

  patches = [
    # Use a relative path to find the backward library instead of relying on
    # LD_LIBRARY_PATH/DYLD_LIBRARY_PATH or absolute paths
    # https://github.com/gazebosim/gz-tools/pull/174
    ./patches/pr-174.patch
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    gz-cmake
    ruby
  ];

  doCheck = true;

  nativeCheckInputs = [ ruby ];

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "gz --help";
      version = finalAttrs.version;
    };
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex=${versionPrefix}_([\\d\\.]+)" ];
    };
  };

  meta = {
    description = "Command line tools for the Gazebo libraries";
    homepage = "https://github.com/gazebosim/gz-tools";
    changelog = "https://github.com/gazebosim/gz-tools/blob/${finalAttrs.src.tag}/Changelog.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "gz";
    maintainers = with lib.maintainers; [ taylorhoward92 ];
  };
})
