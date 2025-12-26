{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "autocorrect";
  version = "2.16.2";

  src = fetchFromGitHub {
    owner = "huacnlee";
    repo = "autocorrect";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IpBEmgZ40CFHMISP4tRzt2c2bE2Di9tn8e+/YJPg9RA=";
  };

  cargoHash = "sha256-sn+72+Qq7qppaiiiMS46RXVhFcm27lCPgXmAIYORKU8=";

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
