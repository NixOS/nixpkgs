{
  lib,
  libguestfs,
  libguestfs-appliance-nix,
  qemu_kvm,
}:

# Like libguestfs-with-appliance, but uses the Nix-built 9p-backed appliance.
# Patches libguestfs to share /nix/store into the VM via virtio-9p, and
# wraps all binaries to set LIBGUESTFS_NIX_9P=/nix/store.
# Uses qemu_kvm instead of full qemu since the appliance is host-arch only.
(libguestfs.override {
  appliance = libguestfs-appliance-nix;
  qemu = qemu_kvm;
}).overrideAttrs
  (prevAttrs: {
    patches = (prevAttrs.patches or [ ]) ++ [
      # Adds support for LIBGUESTFS_NIX_9P env var to share a host path
      # into the appliance VM via virtio-9p.
      ./nix-9p-virtfs.patch
    ];

    extraWrapArgs = prevAttrs.extraWrapArgs ++ [
      "--set"
      "LIBGUESTFS_NIX_9P"
      "/nix/store"
    ];

    meta = prevAttrs.meta // {
      maintainers = with lib.maintainers; [ illustris ];
    };
  })
