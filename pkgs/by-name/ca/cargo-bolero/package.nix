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
  version = "0.13.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-xmSPIHD9wZoABv+6LZK3SCdakavGchjcRxhZPmSNAaE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-vh/EIMrpolwd/o0ihcjVlJy2XTp7JzlUkoZj0sCnQKg=";

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
