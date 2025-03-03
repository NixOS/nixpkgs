{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "b3sum";
  version = "1.6.1";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-tl5rIDLLMOrZimkBuUl4NQfry17mFF/vdCCP/Atb9fQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-0CezqiuqEvPa46uUEW2HhUuvB7TZb0YUNBnW/IwTlc8=";

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
