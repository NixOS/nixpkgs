{
  rustPlatform,
  fetchFromSourcehut,
  lib,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flirt";
  version = "0.4.1";

  src = fetchFromSourcehut {
    owner = "~hadronized";
    repo = "flirt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-L7BiNA/cG7e1GX9sOxwwLS5+2/Tpb1PeA/2rPz8ALf8=";
  };

  cargoHash = "sha256-roPPL9zR8JBr3Ya2IhkvIOfnKxuRSXdxxaJ80ZUK87M=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "FiLe InteRacT, the file interaction tool for your command line";
    homepage = "https://git.sr.ht/~hadronized/flirt";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      adda
    ];
    mainProgram = "flirt";
  };
})
