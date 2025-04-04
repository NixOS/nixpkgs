{
  lib,
  fetchFromSourcehut,
  rustPlatform,
  sqlite,
}:

rustPlatform.buildRustPackage {
  pname = "cnsprcy";
  version = "0.2.0";

  src = fetchFromSourcehut {
    owner = "~xaos";
    repo = "cnsprcy";
    rev = "v0.2.0";
    hash = "sha256-f+DauSU4bT3EljY8/ig7jLnUgyDPEo2NSBQcPN0iKx0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-lPTufjKOXMvPy+cP1UyVCTfRXkOmzZqDR6yraIgk+Dg=";

  RUSTC_BOOTSTRAP = true;

  buildInputs = [ sqlite ];

  meta = {
    description = "End to end encrypted connections between trusted devices";
    homepage = "https://git.sr.ht/~xaos/cnsprcy";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ supinie ];
    mainProgram = "cnspr";
    platforms = lib.platforms.linux;
  };
}
