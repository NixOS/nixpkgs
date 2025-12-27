{
  lib,
  rustPlatform,
  fetchFromSourcehut,
  nix-update-script,
  testers,
  kak-tree-sitter-unwrapped,
}:

rustPlatform.buildRustPackage rec {
  pname = "kak-tree-sitter-unwrapped";
  version = "3.1.1";

  src = fetchFromSourcehut {
    owner = "~hadronized";
    repo = "kak-tree-sitter";
    rev = "kak-tree-sitter-v${version}";
    hash = "sha256-iDpWzvtM0xQSEqs+TsfW3AGaMYwYkHwWqKrbWPRposc=";
  };

  cargoHash = "sha256-WblDG+8GSsy3s2dDE7fgWY6Jkoe7Qqw0ijPR/YQrX7I=";

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
}
