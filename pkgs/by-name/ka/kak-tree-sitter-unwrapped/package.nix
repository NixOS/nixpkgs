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
  version = "1.1.3";

  src = fetchFromSourcehut {
    owner = "~hadronized";
    repo = "kak-tree-sitter";
    rev = "kak-tree-sitter-v${version}";
    hash = "sha256-vQZ+zQgwIw5ZBdIuMDD37rIdhe+WpNBmq0TciXBNiSU=";
  };

  cargoHash = "sha256-bDxQEbUyeNUqYRaWV2kBL60ZFGtA4s+kwmgz6y88MAw=";

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
