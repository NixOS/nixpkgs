{ pkgs, lib, ... }:

with lib;

let
  metadataFetcher = import ./ec2-metadata-fetcher.nix {
    targetRoot = "/";
    wgetExtraOptions = "--retry-connrefused";
  };
in
{
  imports = [
    ../profiles/qemu-guest.nix
    ../profiles/headless.nix
    # The Openstack Metadata service exposes data on an EC2 API also.
    ./ec2-data.nix
    ./amazon-init.nix
  ];

  config = {
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
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

    systemd.services.openstack-init = {
      path = [ pkgs.wget ];
      description = "Fetch Metadata on startup";
      wantedBy = [ "multi-user.target" ];
      before = [ "apply-ec2-data.service" "amazon-init.service"];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      script = metadataFetcher;
      restartIfChanged = false;
      unitConfig.X-StopOnRemoval = false;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };
  };
}
