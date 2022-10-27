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
      default = false;
      example = true;
      description = lib.mdDoc "Whether to set the root password from the Digital Ocean metadata";
    };
    setSshKeys = mkOption {
      type = bool;
      default = true;
      example = true;
      description = lib.mdDoc "Whether to fetch ssh keys from Digital Ocean";
    };
    seedEntropy = mkOption {
      type = bool;
      default = true;
      example = true;
      description = lib.mdDoc "Whether to run the kernel RNG entropy seeding script from the Digital Ocean vendor data";
    };
  };
  config =
    let
      cfg = config.virtualisation.digitalOcean;
      hostName = config.networking.hostName;
      doMetadataFile = "/run/do-metadata/v1.json";
    in mkMerge [{
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
          grub.device = "/dev/vda";
          timeout = 0;
          grub.configurationLimit = 0;
        };
      };
      services.openssh = {
        enable = mkDefault true;
        passwordAuthentication = mkDefault false;
      };
      services.do-agent.enable = mkDefault true;
      networking = {
        hostName = mkDefault ""; # use Digital Ocean metadata server
      };

      /* Check for and wait for the metadata server to become reachable.
       * This serves as a dependency for all the other metadata services. */
      systemd.services.digitalocean-metadata = {
        path = [ pkgs.curl ];
        description = "Get host metadata provided by Digitalocean";
        script = ''
          set -eu
          DO_DELAY_ATTEMPTS=0
          while ! curl -fsSL -o $RUNTIME_DIRECTORY/v1.json http://169.254.169.254/metadata/v1.json; do
            DO_DELAY_ATTEMPTS=$((DO_DELAY_ATTEMPTS + 1))
            if (( $DO_DELAY_ATTEMPTS >= $DO_DELAY_ATTEMPTS_MAX )); then
              echo "giving up"
              exit 1
            fi

            echo "metadata unavailable, trying again in 1s..."
            sleep 1
          done
          chmod 600 $RUNTIME_DIRECTORY/v1.json
          '';
        environment = {
          DO_DELAY_ATTEMPTS_MAX = "10";
        };
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          RuntimeDirectory = "do-metadata";
          RuntimeDirectoryPreserve = "yes";
        };
        unitConfig = {
          ConditionPathExists = "!${doMetadataFile}";
          After = [ "network-pre.target" ] ++
            optional config.networking.dhcpcd.enable "dhcpcd.service" ++
            optional config.systemd.network.enable "systemd-networkd.service";
        };
      };

      /* Fetch the root password from the digital ocean metadata.
       * There is no specific route for this, so we use jq to get
       * it from the One Big JSON metadata blob */
      systemd.services.digitalocean-set-root-password = mkIf cfg.setRootPassword {
        path = [ pkgs.shadow pkgs.jq ];
        description = "Set root password provided by Digitalocean";
        wantedBy = [ "multi-user.target" ];
        script = ''
          set -eo pipefail
          ROOT_PASSWORD=$(jq -er '.auth_key' ${doMetadataFile})
          echo "root:$ROOT_PASSWORD" | chpasswd
          mkdir -p /etc/do-metadata/set-root-password
          '';
        unitConfig = {
          ConditionPathExists = "!/etc/do-metadata/set-root-password";
          Before = optional config.services.openssh.enable "sshd.service";
          After = [ "digitalocean-metadata.service" ];
          Requires = [ "digitalocean-metadata.service" ];
        };
        serviceConfig = {
          Type = "oneshot";
        };
      };

      /* Set the hostname from Digital Ocean, unless the user configured it in
       * the NixOS configuration. The cached metadata file isn't used here
       * because the hostname is a mutable part of the droplet. */
      systemd.services.digitalocean-set-hostname = mkIf (hostName == "") {
        path = [ pkgs.curl pkgs.nettools ];
        description = "Set hostname provided by Digitalocean";
        wantedBy = [ "network.target" ];
        script = ''
          set -e
          DIGITALOCEAN_HOSTNAME=$(curl -fsSL http://169.254.169.254/metadata/v1/hostname)
          hostname "$DIGITALOCEAN_HOSTNAME"
          if [[ ! -e /etc/hostname || -w /etc/hostname ]]; then
            printf "%s\n" "$DIGITALOCEAN_HOSTNAME" > /etc/hostname
          fi
        '';
        unitConfig = {
          Before = [ "network.target" ];
          After = [ "digitalocean-metadata.service" ];
          Wants = [ "digitalocean-metadata.service" ];
        };
        serviceConfig = {
          Type = "oneshot";
        };
      };

      /* Fetch the ssh keys for root from Digital Ocean */
      systemd.services.digitalocean-ssh-keys = mkIf cfg.setSshKeys {
        description = "Set root ssh keys provided by Digital Ocean";
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.jq ];
        script = ''
          set -e
          mkdir -m 0700 -p /root/.ssh
          jq -er '.public_keys[]' ${doMetadataFile} > /root/.ssh/authorized_keys
          chmod 600 /root/.ssh/authorized_keys
        '';
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        unitConfig = {
          ConditionPathExists = "!/root/.ssh/authorized_keys";
          Before = optional config.services.openssh.enable "sshd.service";
          After = [ "digitalocean-metadata.service" ];
          Requires = [ "digitalocean-metadata.service" ];
        };
      };

      /* Initialize the RNG by running the entropy-seed script from the
       * Digital Ocean metadata
       */
      systemd.services.digitalocean-entropy-seed = mkIf cfg.seedEntropy {
        description = "Run the kernel RNG entropy seeding script from the Digital Ocean vendor data";
        wantedBy = [ "network.target" ];
        path = [ pkgs.jq pkgs.mpack ];
        script = ''
          set -eo pipefail
          TEMPDIR=$(mktemp -d)
          jq -er '.vendor_data' ${doMetadataFile} | munpack -tC $TEMPDIR
          ENTROPY_SEED=$(grep -rl "DigitalOcean Entropy Seed script" $TEMPDIR)
          ${pkgs.runtimeShell} $ENTROPY_SEED
          rm -rf $TEMPDIR
          '';
        unitConfig = {
          Before = [ "network.target" ];
          After = [ "digitalocean-metadata.service" ];
          Requires = [ "digitalocean-metadata.service" ];
        };
        serviceConfig = {
          Type = "oneshot";
        };
      };

    }
  ];
  meta.maintainers = with maintainers; [ arianvp eamsden ];
}

