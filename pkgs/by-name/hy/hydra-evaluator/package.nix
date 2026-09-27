{
  lib,
  rustPlatform,
  hydra,
  pkg-config,
  protobuf,
  rust-jemalloc-sys,
  nixosTests,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hydra-evaluator";
  inherit (hydra) version src;
  __structuredAttrs = true;

  cargoHash = "sha256-ULaL4B00O0ApZbBkv7GtLZWAoJI/ZNFPr+0FWsNp3OE=";

  cargoBuildFlags = [
    "--package"
    "hydra-evaluator"
  ];

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

  passthru.tests = { inherit (nixosTests) hydra; };

  meta = {
    description = "Evaluator for the Nix-based continuous build system Hydra";
    homepage = "https://github.com/NixOS/hydra";
    license = lib.licenses.gpl3Only;
    mainProgram = "hydra-evaluator";
    maintainers = with lib.maintainers; [
      conni2461
      das_j
      helsinki-Jo
      mindavi
    ];
    platforms = lib.platforms.linux;
  };
})
