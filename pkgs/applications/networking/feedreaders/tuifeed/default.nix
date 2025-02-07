{
  lib,
  stdenv,
  fetchCrate,
  rustPlatform,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "tuifeed";
  version = "0.3.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-JG/l6NfN5RqBpz9NVcVY3mP/iE31TXvw+Vjq8N8rNIY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-UlZDT/i3UB0wGGpuSBBvVPqRbzGHneDJs57pHn11E5k=";

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
