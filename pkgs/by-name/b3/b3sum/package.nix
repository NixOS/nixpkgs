{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "b3sum";
  version = "1.5.4";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-+aC6yyQ9IcdliYqteB/UTMqwGNCWW0LZWYfMxnaPMm0=";
  };

  cargoHash = "sha256-2E6SU4fMHj0NCIMrn0YNfkllZrFwCLn1wGJfzBPqtKQ=";

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
