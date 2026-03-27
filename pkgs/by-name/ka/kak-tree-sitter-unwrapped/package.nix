{
  lib,
  rustPlatform,
  fetchFromSourcehut,
  nix-update-script,
  testers,
  kak-tree-sitter-unwrapped,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kak-tree-sitter-unwrapped";
  version = "3.1.3";

  src = fetchFromSourcehut {
    owner = "~hadronized";
    repo = "kak-tree-sitter";
    rev = "kak-tree-sitter-v${finalAttrs.version}";
    hash = "sha256-PGQlL7HuZRE2WGGAQr7VBfKt5NvuaIUiYNX9qhpJWK4=";
  };

  cargoHash = "sha256-ink1qZD/ujLi/PlJRej5rByBka5a6pPVMP+Y1YlTE1c=";

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = kak-tree-sitter-unwrapped; };
  };

  meta = {
    homepage = "https://git.sr.ht/~hadronized/kak-tree-sitter";
    description = "Server that interfaces tree-sitter with kakoune";
    mainProgram = "kak-tree-sitter";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ lelgenio ];
  };
})
