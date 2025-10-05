{ lib, pkgs, ... }:

with lib;

{
  imports = [
    ../profiles/qemu-guest.nix
  ];

  config = {
    fileSystems."/" = lib.mkImageMediaOverride {
      device = "/dev/disk/by-label/nixos";
      autoResize = true;
      fsType = "ext4";
    };

    boot.growPartition = true;
    boot.kernelParams = [ "console=tty0" ];
    boot.loader.grub.device = "/dev/vda";
    boot.loader.timeout = 0;

    # Allow root logins
    services.openssh = {
      enable = true;
      settings.PermitRootLogin = "prohibit-password";
    };

    # Cloud-init configuration.
    services.cloud-init.enable = true;
    # Wget is needed for setting password. This is of little use as
    # root password login is disabled above.
    environment.systemPackages = [ pkgs.wget ];
    # Only enable CloudStack datasource for faster boot speed.
    environment.etc."cloud/cloud.cfg.d/99_cloudstack.cfg".text = ''
      datasource:
        CloudStack: {}
        None: {}
      datasource_list: ["CloudStack"]
    '';
  };
}
