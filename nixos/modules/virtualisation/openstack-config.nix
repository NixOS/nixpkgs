{ pkgs, lib, ... }:

with lib;
let
  metadataFetcher = import ./openstack-metadata-fetcher.nix {
    targetRoot = "/";
    wgetExtraOptions = "--retry-connrefused";
  };
in
{
  imports = [
    ../profiles/qemu-guest.nix
    ../profiles/headless.nix
    # The Openstack Metadata service exposes data on an EC2 API also.
    # We use afterburn for most metadata, except the NixOS specific extensions, which are handled by amazon-init.nix
    ./amazon-init.nix
  ];

  config = {
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      autoResize = true;
    };

    boot.growPartition = true;
    boot.kernelParams = [ "console=ttyS0" ];
    boot.loader.grub.device = "/dev/vda";
    boot.loader.timeout = 0;

    # Allow root logins
    services.openssh = {
      enable = true;
      permitRootLogin = "prohibit-password";
      passwordAuthentication = mkDefault false;
    };

    # Force getting the hostname from Openstack metadata.
    networking.hostName = mkDefault "";

    services.afterburn.enable = true;
    services.afterburn.provider = "cloudstack-configdrive";
  };
}
