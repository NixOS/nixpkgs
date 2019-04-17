{ config, pkgs, lib, modulesPath, ... }:
with lib;
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    (modulesPath + "/virtualisation/digital-ocean-init.nix")
  ];
  options.virtualisation.digitalOcean = with types; {
    setRootPassword = mkOption {
      type = bool;
      default = true;
      example = true;
      description = "Whether to set the root password from the Digital Ocean metadata";
    };
    setSshKeys = mkOption {
      type = bool;
      default = true;
      example = true;
      description = "Whether to fetch ssh keys from Digital Ocean";
    };
    seedEntropy = mkOption {
      type = bool;
      default = true;
      example = true;
      description = "Whether to run the kernel RNG entropy seeding script from the Digital Ocean vendor data";
    };
  };
  config =
    let
      cfg = config.virtualisation.digitalOcean;
      hostName = config.networking.hostName;
    in {
      fileSystems."/" = {
        device = "/dev/disk/by-label/nixos";
        autoResize = true;
        fsType = "ext4";
      };
      boot = {
        growPartition = true;
        kernelParams = [ "console=ttyS0" "panic=1" "boot.panic_on_fail" ];
        initrd.kernelModules = [ "virtio_scsi" ];
        kernelModules = [ "virtio_pci" "virtio_net" ];
        loader = {
          grub.device = "/dev/sda";
          timeout = 0;
          grub.configurationLimit = 0;
        };
      };
      services.openssh = {
        enable = true;
        permitRootLogin = "prohibit-password";
        passwordAuthentication = mkDefault false;
      };
      networking = {
        firewall.allowedTCPPorts = [ 22 ];
        hostName = mkDefault ""; # use Digital Ocean metadata server
        useNetworkd = true;
      };

      /* Fetch the root password from the digital ocean metadata.
       * There is no specific route for this, so we use jq to get
       * it from the One Big JSON metadata blob */
      systemd.services.digitalocean-set-root-password = {
        enable = cfg.setRootPassword;
        path = [ pkgs.curl pkgs.shadow pkgs.jq ];
        description = "Set root password provided by Digitalocean";
        wantedBy = [ "multi-user.target" ];
        script = ''
          set -e
          ROOT_PASSWORD=$(curl --retry-connrefused http://169.254.169.254/metadata/v1.json | jq -r '.auth_key')
          echo "root:$ROOT_PASSWORD" | chpasswd
          '';
        unitConfig = {
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };
        serviceConfig = {
          Type = "oneshot";
        };
      };

      /* Set the hostname from Digital Ocean, unless the user configured it in
       * the NixOS configuration */
      systemd.services.digitalocean-set-hostname = {
        enable = hostName == "";
        path = [ pkgs.curl pkgs.nettools ];
        description = "Set hostname provided by Digitalocean";
        wantedBy = [ "multi-user.target" ];
        script = ''
          set -e
          DIGITALOCEAN_HOSTNAME=$(curl --retry-connrefused http://169.254.169.254/metadata/v1/hostname)
          hostname $DIGITALOCEAN_HOSTNAME
        '';
        unitConfig = {
          After =  [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };
        serviceConfig = {
          Type = "oneshot";
        };
      };

      /* Fetch the ssh keys for root from Digital Ocean */
      systemd.services.digitalocean-ssh-keys = {
        enable = cfg.setSshKeys;
        description = "Set root ssh keys provided by Digital Ocean";
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.curl ];
        script = ''
          set -e
          mkdir -m 0700 -p /root/.ssh
          curl --retry-connrefused --output /root/.ssh/authorized_keys http://169.254.169.254/metadata/v1/public-keys
          chmod 600 /root/.ssh/authorized_keys
        '';
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        unitConfig = {
          ConditionFileExists = "!/root/.ssh/authorized_keys";
          After =  [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };
      };

      /* Initialize the RNG by running the entropy-seed script from the
       * Digital Ocean metadata
       */
      systemd.services.digitalocean-entropy-seed = {
        enable = cfg.seedEntropy;
        description = "Run the kernel RNG entropy seeding script from the Digital Ocean vendor data";
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.curl pkgs.mpack ];
        script = ''
          set -e
          TEMPDIR=$(mktemp -d)
          curl --retry-connrefused http://169.254.169.254/metadata/v1/vendor-data | munpack -C $TEMPDIR
          $TEMPDIR/entropy-seed
          rm -rf $TEMPDIR
          '';
        unitConfig = {
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };
        serviceConfig = {
          Type = "oneshot";
        };
      };

    };
  meta.maintainers = with maintainers; [ eamsden ];
}

