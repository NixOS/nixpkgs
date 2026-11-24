{
  lib,
  rustPlatform,
  seaweedfs,
  pkg-config,
  protobuf,
  aws-lc,
  zstd,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  inherit (seaweedfs) version src;
  __structuredAttrs = true;

  pname = "seaweedfs-vector";

  sourceRoot = "${finalAttrs.src.name}/seaweed-vector";

  cargoHash = "sha256-tskJ74uWGm9lQb0tRxnudrA4qhKR2LpDMnSR16bD9bA=";

  env.PROTOC = lib.getExe protobuf;

  nativeBuildInputs = [
    protobuf
    pkg-config
  ];

  buildInputs = [
    aws-lc
    zstd
  ];

  meta = {
    inherit (seaweedfs.meta) homepage license maintainers;

    description = "SeaweedFS vector engine serves the S3 Vector data plane through the S3 gateway";
    mainProgram = "weed-vector";
  };
})
