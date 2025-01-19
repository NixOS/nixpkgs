{
  lib,
  fetchFromSourcehut,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mus";
  version = "0.2.0";

  src = fetchFromSourcehut {
    owner = "~nbsp";
    repo = pname;
    rev = version;
    hash = "sha256-yvMV+lhU9Wtwrhw0RKRUNFNznvZP0zcnT6jqPaqzhUs=";
  };

  cargoHash = "sha256-K9B8y9pOHcAOrUCmCB0zW2wy81DTF3K97gPYmAiKwAM=";

  meta = {
    description = "Pretty good mpd client";
    homepage = "https://sr.ht/~nbsp/mus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nbsp ];
    mainProgram = "mus";
  };
}
