{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "b3sum";
  version = "1.8.3";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-mU2r5xbYf6A1RibWqhow/637YxybCFMT3UzYcUMjhdg=";
  };

  cargoHash = "sha256-w9l8dn4Ahck3NXuN4Ph9qmGoS767/mQRBgO9AT0CH3Y=";

  meta = {
    description = "BLAKE3 cryptographic hash function";
    mainProgram = "b3sum";
    homepage = "https://github.com/BLAKE3-team/BLAKE3/";
    maintainers = with lib.maintainers; [
      fpletz
      ivan
    ];
    license = with lib.licenses; [
      cc0
      asl20
    ];
    changelog = "https://github.com/BLAKE3-team/BLAKE3/releases/tag/${version}";
  };
}
