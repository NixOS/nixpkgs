{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  libusb1,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hf2";
  version = "0.3.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-0o3j7YfgNNnfbrv9Gppo24DqYlDCxhtsJHIhAV214DU=";
  };

  cargoHash = "sha256-cRliZegzRKmoGIE96pyVuNySA2L6l+imcTHbZBXXiz4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libusb1 ];

  meta = with lib; {
    description = "Cargo Subcommand for Microsoft HID Flashing Library for UF2 Bootloaders";
    mainProgram = "cargo-hf2";
    homepage = "https://lib.rs/crates/cargo-hf2";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ astrobeastie ];
  };
}
