{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ../profiles/qemu-guest.nix
    ../profiles/headless.nix
    ./grow-partition.nix
  ];

  config = {
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      autoResize = true;
    };

    virtualisation.growPartition = true;

    boot.kernelParams = [ "console=ttyS0" ];
    boot.loader.grub.device = "/dev/vda";
    boot.loader.timeout = 0;

    # Allow root logins
    services.openssh.enable = true;
    services.openssh.permitRootLogin = "prohibit-password";

    # Put /tmp and /var on /ephemeral0, which has a lot more space.
    # Unfortunately we can't do this with the `fileSystems' option
    # because it has no support for creating the source of a bind
    # mount.  Also, "move" /nix to /ephemeral0 by layering a unionfs-fuse
    # mount on top of it so we have a lot more space for Nix operations.

    /*
    boot.initrd.postMountCommands =
      ''
        mkdir -m 1777 -p $targetRoot/ephemeral0/tmp
        mkdir -m 1777 -p $targetRoot/tmp
        mount --bind $targetRoot/ephemeral0/tmp $targetRoot/tmp

        mkdir -m 755 -p $targetRoot/ephemeral0/var
        mkdir -m 755 -p $targetRoot/var
        mount --bind $targetRoot/ephemeral0/var $targetRoot/var

        mkdir -p /unionfs-chroot/ro-nix
        mount --rbind $targetRoot/nix /unionfs-chroot/ro-nix

        mkdir -p /unionfs-chroot/rw-nix
        mkdir -m 755 -p $targetRoot/ephemeral0/nix
        mount --rbind $targetRoot/ephemeral0/nix /unionfs-chroot/rw-nix
        unionfs -o allow_other,cow,nonempty,chroot=/unionfs-chroot,max_files=32768 /rw-nix=RW:/ro-nix=RO $targetRoot/nix
      '';

      boot.initrd.supportedFilesystems = [ "unionfs-fuse" ];
    */
  };
}
