{
  diskImage,
  lib,
  sharedDirectories,
  writableStoreUseTmpfs,
}:

{
  "/" = lib.mkVMOverride {
    device = "tmpfs";
    fsType = "tmpfs";
    neededForBoot = true;
    options = [ "mode=0755" ];
  };
}
// lib.optionalAttrs (!writableStoreUseTmpfs && diskImage != null) {
  # Second disk, hence /dev/vdb: store image is always first. Mount all of
  # /nix so the Nix database persists together with the writable store.
  "/nix" = lib.mkVMOverride {
    device = "/dev/vdb";
    fsType = "ext4";
    autoFormat = true;
    neededForBoot = true;
  };
}
// lib.mapAttrs' (
  _: share:
  lib.nameValuePair share.target (
    lib.mkVMOverride {
      device = share.tag;
      fsType = "virtiofs";
    }
  )
) sharedDirectories
