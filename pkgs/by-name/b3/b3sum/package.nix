{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "b3sum";
  version = "1.5.3";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-wyr5LuFn3yRPJCyNfLT1Vgn6Sz1U4VNo0nppJrqE7IY=";
  };

  cargoHash = "sha256-v2sQKZ0DG08MDLho8fQ8O7fiNu+kxZB1sPNMgF5W2HA=";

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
