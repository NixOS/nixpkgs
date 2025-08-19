{
  rustPlatform,
  fetchFromSourcehut,
  lib,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "flirt";
  version = "0.4";

  src = fetchFromSourcehut {
    owner = "~hadronized";
    repo = "flirt";
    rev = "v${version}";
    hash = "sha256-wH6WLLUqUj5YrrudNbGkzZ4i15xRPDBE3UKwyhkQSxg=";
  };

  cargoHash = "sha256-m1aLJFa6C5X9HwNweezoUcFnpG09AuYf9ooet8GUGFE=";

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
}
