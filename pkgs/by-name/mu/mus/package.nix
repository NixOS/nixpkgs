{
  lib,
  fetchFromSourcehut,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mus";
  version = "0.2.0";

  src = fetchFromSourcehut {
    owner = "~nbsp";
    repo = "mus";
    rev = finalAttrs.version;
    hash = "sha256-yvMV+lhU9Wtwrhw0RKRUNFNznvZP0zcnT6jqPaqzhUs=";
  };

  cargoHash = "sha256-1ruRKqHW5/MH4THRAozofAROZT6zE3JFKGluuWWa1ms=";

  meta = {
    description = "Pretty good mpd client";
    homepage = "https://sr.ht/~nbsp/mus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nbsp ];
    mainProgram = "mus";
  };
})
