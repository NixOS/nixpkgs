{
  rustPlatform,
  fetchFromSourcehut,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "flirt";
  version = "0.2.1";

  src = fetchFromSourcehut {
    owner = "~hadronized";
    repo = "flirt";
    rev = "v${version}";
    hash = "sha256-LCwSETvXHAUbe4QIeGpT7vVbuZl1SDfIehVG8svkmHM=";
  };

  cargoHash = "sha256-EquriyhfbYyi87TP3zuLiCXDV7baDRaTRuZd7Yht/UA=";

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
