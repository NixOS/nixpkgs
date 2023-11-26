{ lib, fetchFromSourcehut, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mus";
  version = "0.2.0";

  src = fetchFromSourcehut {
    owner = "~sfr";
    repo = pname;
    rev = version;
    hash = "sha256-yvMV+lhU9Wtwrhw0RKRUNFNznvZP0zcnT6jqPaqzhUs=";
  };

  cargoHash = "sha256-K9B8y9pOHcAOrUCmCB0zW2wy81DTF3K97gPYmAiKwAM=";

  meta = with lib; {
    description = "a pretty good mpd client";
    homepage = "https://sr.ht/~sfr/mus";
    license = licenses.mit;
    maintainers = with maintainers; [ sfr ];
    mainProgram = "mus";
  };
}
