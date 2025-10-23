{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "codebook";
  version = "0.3.14";

  src = fetchFromGitHub {
    owner = "blopker";
    repo = "codebook";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XS4neGqi0tLzs53jV37mDsfC8bAXwpqinoe3gT8GYZw=";
  };

  buildAndTestSubdir = "crates/codebook-lsp";
  cargoHash = "sha256-39ROafYvaTL3wZCUyycGV0PCnR/mr+rJK3/lrvfqKIM=";

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
