{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "b3sum";
  version = "1.8.0";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-FWblGKr/ZQsLZkPOax20FYEyoLiPREf7UjfOtFCljZU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-vSxAG0CKtTHZ/3fSDtZqmqvfY+swDBBPZ8YZP1Vlj0w=";

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
