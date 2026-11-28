{
  lib,
  rustPlatform,
  seaweedfs,
  pkg-config,
  protobuf,
  aws-lc,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  inherit (seaweedfs) version src;
  __structuredAttrs = true;

  pname = "seaweedfs-volume";

  sourceRoot = "${finalAttrs.src.name}/seaweed-volume";

  cargoHash = "sha256-mwuuXOlyI32OVyeWiO49LOrdlEPhVhxhYvOKZL6exDk=";

  env.PROTOC = lib.getExe protobuf;

  nativeBuildInputs = [
    protobuf
    pkg-config
  ];

  buildInputs = [
    aws-lc
  ];

  meta = {
    inherit (seaweedfs.meta) homepage license maintainers;

    description = "weed-volume is a drop-in replacement for SeaweedFS's Go volume server";
    mainProgram = "weed-volume";
  };
})
