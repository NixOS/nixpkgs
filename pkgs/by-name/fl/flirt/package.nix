{
  rustPlatform,
  fetchFromSourcehut,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "flirt";
  version = "0.2";

  src = fetchFromSourcehut {
    owner = "~hadronized";
    repo = "flirt";
    rev = "v${version}";
    hash = "sha256-NV6UP7fPTcn0WrZwIfe1zuZW6hJDuxrfATM2Gpx0yr0=";
  };

  cargoHash = "sha256-gVtRU+tjwf3rTei/TjUFYSMvLB9g6gNeGYO+9NBxgYQ=";

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
