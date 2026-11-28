{
  lib,
  rustPlatform,
  hydra,
  pkg-config,
  protobuf,
  rust-jemalloc-sys,
  zstd,
  aws-lc,
  xz,
  sqlite,
  withOtel ? false,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hydra-builder";
  inherit (hydra) version src;
  __structuredAttrs = true;

  cargoHash = "sha256-1hBknwIWH2dDgnsbjOPZYwa/IHieYaOmq5J0KKPnNhE=";

  cargoBuildFlags = [
    "--package"
    "hydra-builder"
  ];

  buildFeatures = lib.optional withOtel "otel";

  # The sqlx-macros proc macro links against sqlite on the build platform.
  depsBuildBuild = [
    pkg-config
    sqlite
  ];

  # The pkg-config crate uses HOST_PKG_CONFIG for build scripts of crates
  # compiled for the build platform (proc macros and their dependencies),
  # instead of PKG_CONFIG, which points to the host pkg-config.
  env.HOST_PKG_CONFIG = "pkg-config";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    protobuf
    rust-jemalloc-sys
    zstd
    aws-lc
    xz
    sqlite
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
