{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "protoc-gen-connect-rust";
  version = "0.3.2";

  src = fetchCrate {
    pname = "connectrpc-codegen";
    inherit (finalAttrs) version;
    hash = "sha256-cEG00Zn9wF4YGhrF1qHABN9ZcqAUeRJU50ZNi142SX4=";
  };

  cargoHash = "sha256-Wox9oH1gX35gh1w6Q0eh54rG4GnVA54hr1felQKDtog=";

  meta = {
    description = "Protoc plugin for generating ConnectRPC Rust service bindings";
    homepage = "https://github.com/anthropics/connect-rust";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ macalinao ];
    mainProgram = "protoc-gen-connect-rust";
  };
})
