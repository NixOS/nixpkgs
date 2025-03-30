{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "b3sum";
  version = "1.7.0";

  src = fetchCrate {
    inherit version pname;
    hash = "sha256-bDydKLPJgeUngkWO8L5BkJP9rGy3mx0QJhWAN2CCYhE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-yB0noD5eabr+HANPRhIhBEG4PCwtJPULNIy+Wx/tC3U=";

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
