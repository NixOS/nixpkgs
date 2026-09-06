{
  lib,
  cedar,
  testers,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cedar";
  version = "4.12.0";

  src = fetchFromGitHub {
    owner = "cedar-policy";
    repo = "cedar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BU0D5VGHt2S9iWVFtBbgCBRKvnhn2YnvrKH38UazmhY=";
  };

  cargoHash = "sha256-fQ8oPE3fpHh61lhsaXyMpd70/nmdKFHrcKfQ/1Ih1uE=";

  cargoBuildFlags = [
    "--bin"
    "cedar"
    "--bin"
    "cedar-language-server"
  ];

  cargoTestFlags = finalAttrs.cargoBuildFlags;

  preCheck = ''
    export TMPDIR="/tmp"
  '';

  passthru = {
    tests.version = testers.testVersion { package = cedar; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Implementation of the Cedar Policy Language";
    homepage = "https://github.com/cedar-policy/cedar";
    changelog = "https://github.com/cedar-policy/cedar/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ meain ];
    mainProgram = "cedar";
  };
})
