{
  lib,
  guestfs-tools,
  libguestfs-with-appliance-nix,
  passt,
  qemu_kvm,
}:

# guestfs-tools built against the Nix-built 9p-backed appliance.
# LIBGUESTFS_NIX_9P=/nix/store is set so the libguestfs launch-direct
# patch adds the -virtfs share to QEMU.
# passt is added to PATH so libguestfs uses it as the user-mode network
# backend instead of falling back to -netdev user (QEMU slirp).
(guestfs-tools.override {
  libguestfs-with-appliance = libguestfs-with-appliance-nix;
  qemu = qemu_kvm;
}).overrideAttrs
  (prevAttrs: {
    extraWrapArgs = prevAttrs.extraWrapArgs ++ [
      "--set"
      "LIBGUESTFS_NIX_9P"
      "/nix/store"
      "--prefix"
      "PATH"
      ":"
      "${passt}/bin"
    ];

    meta = prevAttrs.meta // {
      maintainers = with lib.maintainers; [ illustris ];
      hydraPlatforms = [ "x86_64-linux" ];
    };
  })
