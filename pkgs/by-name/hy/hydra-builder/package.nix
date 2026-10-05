{
  lib,
  rustPlatform,
  hydra,
  pkg-config,
  protobuf,
  rust-jemalloc-sys,
  withOtel ? false,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hydra-builder";
  inherit (hydra) version src;
  __structuredAttrs = true;

  cargoHash = "sha256-ULaL4B00O0ApZbBkv7GtLZWAoJI/ZNFPr+0FWsNp3OE=";

  cargoBuildFlags = [
    "--package"
    "hydra-builder"
  ];

  buildFeatures = lib.optional withOtel "otel";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    protobuf
    rust-jemalloc-sys
  ];

  # The unit tests spin up a PostgreSQL instance, which is not available in the
  # sandbox.
  doCheck = false;

  meta = {
    description = "Build agent for the Nix-based continuous build system Hydra";
    homepage = "https://github.com/NixOS/hydra";
    license = lib.licenses.gpl3Only;
    mainProgram = "hydra-builder";
    maintainers = with lib.maintainers; [
      conni2461
      das_j
      helsinki-Jo
      mindavi
    ];
    platforms = lib.platforms.unix;
  };
})
