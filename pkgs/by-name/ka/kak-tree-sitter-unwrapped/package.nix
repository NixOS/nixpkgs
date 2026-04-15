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
  version = "3.2.0";

  src = fetchFromSourcehut {
    owner = "~hadronized";
    repo = "kak-tree-sitter";
    rev = "kak-tree-sitter-v${finalAttrs.version}";
    hash = "sha256-8J6bqQkeDfJOyd9WusT+H35J6AMVcCIEr0BCrwGKVXI=";
  };

  cargoHash = "sha256-rEF2BaadWuM0OtesiXV3IZ8bRpcpdRekUnvBAWM7Dwc=";

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
