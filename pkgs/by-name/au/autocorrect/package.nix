{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "autocorrect";
  version = "2.16.3";

  src = fetchFromGitHub {
    owner = "huacnlee";
    repo = "autocorrect";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SRG603v6yP8/p3aUgGKRdbZScd818A+WqizcyPXaGB4=";
  };

  cargoHash = "sha256-4CuvHOXGXUPN46HbiblVa6gSVA+jkYbo7i4uRFWc5+0=";

  cargoBuildFlags = [
    "-p"
    "autocorrect-cli"
  ];
  cargoTestFlags = [
    "-p"
    "autocorrect-cli"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Linter and formatter for help you improve copywriting, to correct spaces, punctuations between CJK (Chinese, Japanese, Korean)";
    mainProgram = "autocorrect";
    homepage = "https://huacnlee.github.io/autocorrect";
    changelog = "https://github.com/huacnlee/autocorrect/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ definfo ];
  };
})
