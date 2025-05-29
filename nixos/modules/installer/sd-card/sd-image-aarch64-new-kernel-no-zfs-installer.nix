{ lib, ... }:

{
  imports = [ ./sd-image-aarch64-new-kernel-installer.nix ];

  boot.supportedFilesystems.zfs = lib.mkForce false;
}
