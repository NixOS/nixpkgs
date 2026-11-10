{ lib, ... }:

{
  imports = [ ./installation-cd-minimal-new-kernel.nix ];

  boot.supportedFilesystems.zfs = lib.mkForce false;
}
