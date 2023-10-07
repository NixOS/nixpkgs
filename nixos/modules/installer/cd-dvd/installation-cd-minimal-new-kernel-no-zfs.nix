{ pkgs, ... }:

{
  imports = [ ./installation-cd-minimal-new-kernel.nix ];

  # Makes `availableOn` fail for zfs, see <nixos/modules/profiles/base.nix>.
  # This is a workaround since we cannot remove the `"zfs"` string from `supportedFilesystems`.
  # The proper fix would be to make `supportedFilesystems` an attrset with true/false which we
  # could then `lib.mkForce false`
  nixpkgs.overlays = [(final: super: {
    zfs = super.zfs.overrideAttrs(_: {
      meta.platforms = [];
    });
  })];
}
