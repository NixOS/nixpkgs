{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "protoc-gen-connect-rust";
  version = "0.9.0";

  src = fetchCrate {
    pname = "connectrpc-codegen";
    inherit (finalAttrs) version;
    hash = "sha256-f9MW/JbPW5bbHcJ3l5J3YFiFQdnkg3N8NTpiWH8d7LU=";
  };

  cargoHash = "sha256-eyWjHSUF0ZPtU/nrRXGQSmkhLOA+yHDDKfmfeu51ZMQ=";

  meta = {
    description = "Protoc plugin for generating ConnectRPC Rust service bindings";
    homepage = "https://github.com/connectrpc/connect-rust";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ macalinao ];
    mainProgram = "protoc-gen-connect-rust";
  };
})
