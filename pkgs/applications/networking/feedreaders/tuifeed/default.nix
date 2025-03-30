{
  lib,
  stdenv,
  fetchCrate,
  rustPlatform,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "tuifeed";
  version = "0.4.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-/13YC5ur633bCRq2pEQKWL+EwLFp5ZkJF6Pnipqo76s=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-xfva1kEJz/KjPB5YP11130pyQngYUWAyqH3dVU7WqI8=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  doCheck = false;

  meta = with lib; {
    description = "Terminal feed reader with a fancy UI";
    mainProgram = "tuifeed";
    homepage = "https://github.com/veeso/tuifeed";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ devhell ];
  };
}
