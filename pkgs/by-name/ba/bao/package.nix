{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "bao";
  version = "0.13.0";

  src = fetchCrate {
    inherit version;
    pname = "${pname}_bin";
    hash = "sha256-MpMNhL1n8dNJJcJJiDXv/qWUgCNqQIvvcR8veH+abuI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Vw8T/pgGMjI8QklkQNuZSYmKcKhaR320q8ZBAT4HPZ8=";

  meta = {
    description = "Implementation of BLAKE3 verified streaming";
    homepage = "https://github.com/oconnor663/bao";
    maintainers = with lib.maintainers; [ amarshall ];
    license = with lib.licenses; [
      cc0
      asl20
    ];
    mainProgram = "bao";
  };
}
