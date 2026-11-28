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

  pname = "seaweedfs-worker";

  sourceRoot = "${finalAttrs.src.name}/seaweed-worker";

  cargoHash = "sha256-tVmJYbUYv2ivVWPgGMgwgaOSaY0ZqGZvoJZfMUHker8=";

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

    description = "Lance maintenance job worker of Seaweedfs";
    mainProgram = "weed-worker";
  };
})
