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
    repo = "mus";
    rev = version;
    hash = "sha256-yvMV+lhU9Wtwrhw0RKRUNFNznvZP0zcnT6jqPaqzhUs=";
  };

  cargoHash = "sha256-1ruRKqHW5/MH4THRAozofAROZT6zE3JFKGluuWWa1ms=";

  meta = with lib; {
    description = "Pretty good mpd client";
    homepage = "https://sr.ht/~nbsp/mus";
    license = licenses.mit;
    maintainers = with maintainers; [ nbsp ];
    mainProgram = "mus";
  };
}
