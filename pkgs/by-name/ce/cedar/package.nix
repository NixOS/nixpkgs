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
  version = "4.14.0";

  src = fetchFromGitHub {
    owner = "cedar-policy";
    repo = "cedar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Nt44iX6Oc/ZPQvAmFzP7jcHNurFa2hPGG4DdBU4n2Pg=";
  };

  cargoHash = "sha256-1gmLRfq/D1WYfswCKAPwUm60JZ/Zl32l3knKKvfqTNk=";

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
