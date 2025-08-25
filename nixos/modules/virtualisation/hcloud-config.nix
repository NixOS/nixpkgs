# Configuration for Hetzner Cloud virtual servers.

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hcloud;
  dynamicHostname = config.networking.hostName == "";
in

{
  imports = [
    ../profiles/qemu-guest.nix
  ];

  options = {
    hcloud = {
      efi = lib.mkOption {
        default = pkgs.stdenv.hostPlatform.isAarch64;
        defaultText = lib.literalExpression "pkgs.stdenv.hostPlatform.isAarch64";
        internal = true;
        description = ''
          Whether the server is using EFI to boot.
        '';
      };

      networkGeneratorPackage = lib.mkPackageOption pkgs "systemd-network-generator-hcloud" { };

      fetchMetadata = lib.mkOption {
        default = false;
        description = ''
          Whether to make server metadata available as
          {file}`/run/hcloud-metadata` and {file}`/run/hcloud-userdata`.
        '';
      };
    };
  };

  config = {

    boot.growPartition = true;

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      autoResize = true;
    };

    fileSystems."/boot" = lib.mkIf cfg.efi {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
      options = [ "umask=0077" ];
    };

    boot.loader = {
      grub.enable = !cfg.efi;
      grub.device = "/dev/sda";
      systemd-boot.enable = cfg.efi;
      efi.canTouchEfiVariables = true;
    };

    # Set the hostname from server metadata by default.
    networking.hostName = lib.mkDefault "";

    # Allow root logins only using the SSH key that the user specified
    # at server creation time.
    services.openssh = {
      enable = true;
      settings.PermitRootLogin = "prohibit-password";
    };

    # Per: https://community.hetzner.com/tutorials/install-and-configure-ntp
    networking.timeServers = [
      "ntp1.hetzner.de"
      "ntp2.hetzner.com"
      "ntp3.hetzner.net"
    ];

    # Generate network configuration for systemd-networkd.
    networking.useNetworkd = true;
    networking.useDHCP = false;
    systemd.packages = [ cfg.networkGeneratorPackage ];
    systemd.targets.sysinit.wants = [ "systemd-network-generator-hcloud.service" ];
    systemd.services.systemd-network-generator-hcloud = {
      # Replace the command to set additional arguments.
      serviceConfig.ExecStart = [
        ""
        (
          "${cfg.networkGeneratorPackage}/bin/systemd-network-generator-hcloud"
          # For the below postStart script.
          + lib.optionalString dynamicHostname " --write-hostname /run/hcloud-hostname"
          + " --write-public-keys /run/hcloud-public-keys"
          # For general use.
          + lib.optionalString cfg.fetchMetadata " --write-metadata /run/hcloud-metadata --write-userdata /run/hcloud-userdata"
        )
      ];
      # Amend the service with a script that applies other metadata properties.
      postStart =
        lib.optionalString dynamicHostname ''
          if [[ -s /run/hcloud-hostname ]]; then
            echo "setting hostname..."
            ${pkgs.nettools}/bin/hostname $(</run/hcloud-hostname)
            rm /run/hcloud-hostname
          fi
        ''
        + ''
          if [[ -e /run/hcloud-public-keys ]]; then
            echo "configuring root ssh authorized keys..."
            install -o root -g root -m 0700 -d /root/.ssh/
            mv /run/hcloud-public-keys /root/.ssh/authorized_keys
          fi
        '';
    };

    # Hetzner metadata does not list private networks. This configures DHCPv4
    # on all remaining interfaces to catch those. (Private networks do not
    # appear to have IPv6 support.)
    systemd.network.networks."81-hetzner-fallback" = {
      matchConfig.Name = "en*";
      networkConfig.DHCP = "ipv4";
    };

  };

  meta.maintainers = with lib.maintainers; [ stephank ];
}
