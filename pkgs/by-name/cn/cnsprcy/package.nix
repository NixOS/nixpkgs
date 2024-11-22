{
  lib,
  fetchFromSourcehut,
  rustPlatform,
  sqlite,
}:

rustPlatform.buildRustPackage rec {
  pname = "cnsprcy";
  version = "0.2.0";

  src = fetchFromSourcehut {
    owner = "~xaos";
    repo = pname;
    rev = "v0.2.0";
    hash = "sha256-f+DauSU4bT3EljY8/ig7jLnUgyDPEo2NSBQcPN0iKx0=";
  };

  cargoHash = "sha256-e9+nMz/FCtd5pnHSHA1RenWzrgIHyCf5eEDO4xMxGHk=";

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
