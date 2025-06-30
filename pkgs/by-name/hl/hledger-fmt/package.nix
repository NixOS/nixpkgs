{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "hledger-fmt";
  version = "0.2.8";

  src = fetchCrate {
    pname = "hledger-fmt";
    inherit version;
    hash = "sha256-to6GlMtxwCSBf85AoRJprMvkKEvOrgw+pmFXIFKQ3MA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-yv8qaFlUmixtiJGlKqmzTVv5WHV+GvTwPI0Naihioco=";

  meta = {
    homepage = "https://github.com/mondeja/hledger-fmt";
    description = "Opinionated hledger's journal files formatter";
    changelog = "https://github.com/mondeja/hledger-fmt/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "hledger-fmt";
    maintainers = with lib.maintainers; [ mksafavi ];
  };
}
