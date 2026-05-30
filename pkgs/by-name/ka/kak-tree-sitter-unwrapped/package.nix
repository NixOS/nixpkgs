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
  version = "3.2.1";

  src = fetchFromSourcehut {
    owner = "~hadronized";
    repo = "kak-tree-sitter";
    rev = "kak-tree-sitter-v${finalAttrs.version}";
    hash = "sha256-w+taJzr9tPLXdpV5RLTedVGR48Qodq/4M5IhlKAM/lU=";
  };

  cargoHash = "sha256-ztVBBeLU1AByDz3yVDMZ102bDG6JfL/6IoJlcqRmCmU=";

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
