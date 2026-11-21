# Checks that amazonImage.storeCompression follows what the kernel can mount.
{
  lib,
  emptyFile,
  nixos,
}:
let
  eval =
    modules:
    (nixos (
      [
        ../maintainers/scripts/ec2/amazon-image.nix
        {
          system.stateVersion = lib.trivial.release;
          amazonImage.store = "erofs";
        }
      ]
      ++ modules
    )).config;

  failedAssertions =
    config: map (assertion: assertion.message) (lib.filter (a: !a.assertion) config.assertions);

  withoutKernelOption = option: {
    boot.kernelPatches = [
      {
        name = "no-${option}";
        patch = null;
        structuredExtraConfig.${option} = lib.mkForce lib.kernel.no;
      }
    ];
  };

  withoutZstd = withoutKernelOption "EROFS_FS_ZIP_ZSTD";
  withoutZip = withoutKernelOption "EROFS_FS_ZIP";

  fires = message: config: lib.elem message (failedAssertions config);

  default = eval [ ];
  noZstd = eval [ withoutZstd ];
in
assert default.amazonImage.storeCompression == "zstd";
assert failedAssertions default == [ ];
assert noZstd.amazonImage.storeCompression == "lz4hc";
assert failedAssertions noZstd == [ ];
assert fires
  ''amazonImage.storeCompression = "zstd" needs a kernel with EROFS_FS_ZIP_ZSTD. Enable it or use "lz4hc".''
  (eval [
    withoutZstd
    { amazonImage.storeCompression = "zstd"; }
  ]);
assert fires ''amazonImage.storeCompression = "lz4hc" needs a kernel with EROFS_FS_ZIP.'' (eval [
  withoutZip
  withoutZstd
]);
emptyFile
