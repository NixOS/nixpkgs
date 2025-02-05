{
  lib,
  rustPlatform,
  fetchCrate,
  libbfd,
  libopcodes,
  libunwind,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bolero";
  version = "0.12.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-ta0H6V7Zg/Jnu3973eYJXGwwQcqZnDTlsmWAHkQr2EA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-XndJm7nkOxY/4tJZIdv1HYxhsju667G1x8FSW1fb4BI=";

  buildInputs = [
    libbfd
    libopcodes
    libunwind
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Fuzzing and property testing front-end framework for Rust";
    mainProgram = "cargo-bolero";
    homepage = "https://github.com/camshaft/bolero";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ekleog ];
  };
}
