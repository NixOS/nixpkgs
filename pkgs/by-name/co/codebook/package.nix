{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "codebook";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "blopker";
    repo = "codebook";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lQfk4dJ9WFraxMDWJVSBiTGumikfHYlMBe+0NHa/3nY=";
  };

  buildAndTestSubdir = "crates/codebook-lsp";
  cargoHash = "sha256-MLd7V5Pp8yx4pFAXSjZf4KUGp964ombrnGKbrtXhC0I=";

  # Integration tests require internet access for dictionaries
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unholy spellchecker for code";
    homepage = "https://github.com/blopker/codebook";
    changelog = "https://github.com/blopker/codebook/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jpds
    ];
    mainProgram = "codebook-lsp";
    platforms = with lib.platforms; unix ++ windows;
  };
})
