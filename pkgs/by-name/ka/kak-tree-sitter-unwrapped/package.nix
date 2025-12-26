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
  version = "3.0.0";

  src = fetchFromSourcehut {
    owner = "~hadronized";
    repo = "kak-tree-sitter";
    rev = "kak-tree-sitter-v${version}";
    hash = "sha256-9QeTHmDTw1Qxnl+AnqCZgxlCCycq5qYF0aM/6fu8qwM=";
  };

  cargoHash = "sha256-lZNM5HqICP6JfaMiBjACcUNRTTTIRhq2ou8cOLU0yOU=";

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
