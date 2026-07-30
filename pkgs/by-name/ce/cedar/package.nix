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
  version = "4.11.2";

  src = fetchFromGitHub {
    owner = "cedar-policy";
    repo = "cedar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pJiSnaq2oz1uZVkLp9s2HLPdG2sZ0EtURlO8R2V+dJs=";
  };

  cargoHash = "sha256-6AtFdE7vXoevOU3uWP4sgibakNHK8ffnuWCzJxFt/wo=";

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
