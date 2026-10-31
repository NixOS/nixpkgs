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
stdenv.mkDerivation (
  finalAttrs:
  let
    versionPrefix = "gz-tools${lib.versions.major finalAttrs.version}";
  in
  {
    pname = "gz-tools";
    version = "2.0.4";

    strictDeps = true;
    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "gazebosim";
      repo = "gz-tools";
      tag = "${versionPrefix}_${finalAttrs.version}";
      hash = "sha256-WVeZg7Wreqz0eScbrgELEAsmpfr1Dy7HogZFjGEht/I=";
    };

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
  }
)
