{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "b3sum";
  version = "1.8.2";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-/qyBs+t8n5I6uf1dSc3E0yHpdlUz77pvlqV5+r4dRBc=";
  };

  cargoHash = "sha256-PKVDfBFWQY95FxJ66vl6E26GEZChNCsA3ST++iieYSM=";

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
