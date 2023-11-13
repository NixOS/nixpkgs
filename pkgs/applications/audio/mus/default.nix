{ lib, fetchFromSourcehut, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mus";
  version = "0.1.0";

  src = fetchFromSourcehut {
    owner = "~sfr";
    repo = pname;
    rev = version;
    hash = "sha256-s7rizOieOmzK0Stkk1SWe9h/5DoaH6MMmL/5QFeezt0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "mpd-0.1.0" = "sha256-5UC6aFNJU9B5AlgJ7uPO+W7e2MHpvTu2OpktjiIXMfc=";
    };
  };

  meta = with lib; {
    description = "a pretty good mpd client";
    homepage = "https://sr.ht/~sfr/mus";
    license = licenses.mit;
    maintainers = with maintainers; [ sfr ];
    mainProgram = "mus";
  };
}
