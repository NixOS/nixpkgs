{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage {
  pname = "prettypst";
  version = "unstable-2023-11-27";

  src = fetchFromGitHub {
    owner = "antonWetzel";
    repo = "prettypst";
    rev = "0bf6aa013efa2b059d8c7dcae3441a6004b02fa1";
    hash = "sha256-8rAF7tzs+0qGphmanTvx6MXhYOSG6igAMY4ZLkljRp8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "typst-syntax-0.9.0" = "sha256-LwRB/AQE8TZZyHEQ7kKB10itzEgYjg4R/k+YFqmutDc=";
    };
  };

  meta = {
    description = "Formatter for Typst";
    homepage = "https://github.com/antonWetzel/prettypst";
    license = lib.licenses.mit;
    mainProgram = "prettypst";
    maintainers = with lib.maintainers; [ drupol ];
  };
}
