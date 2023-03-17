{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.virtualisation.azureImage;
in
{
  imports = [ ./azure-common.nix ];

  options = {
    virtualisation.azureImage.diskSize = mkOption {
      type = with types; either (enum [ "auto" ]) int;
      default = "auto";
      example = 2048;
      description = lib.mdDoc ''
        Size of disk image. Unit is MB.
      '';
    };
  };
  config = {
    system.build.azureImage = import ../../lib/make-disk-image.nix {
      name = "azure-image";
      postVM = ''
        ${pkgs.vmTools.qemu}/bin/qemu-img convert -f raw -o subformat=fixed,force_size -O vpc $diskImage $out/disk.vhd
        rm $diskImage
      '';
      configFile = ./azure-config-user.nix;
      format = "raw";
      inherit (cfg) diskSize;
      inherit config lib pkgs;
    };

    # Azure metadata is available as a CD-ROM drive.
    fileSystems."/metadata".device = "/dev/sr0";

    systemd.services.fetch-ssh-keys = {
      description = "Fetch host keys and authorized_keys for root user";

      wantedBy = [ "sshd.service" "waagent.service" ];
      before = [ "sshd.service" "waagent.service" ];

      path  = [ pkgs.coreutils ];
      script =
        ''
          eval "$(cat /metadata/CustomData.bin)"
          if ! [ -z "$ssh_host_ecdsa_key" ]; then
            echo "downloaded ssh_host_ecdsa_key"
            echo "$ssh_host_ecdsa_key" > /etc/ssh/ssh_host_ed25519_key
            chmod 600 /etc/ssh/ssh_host_ed25519_key
          fi

          if ! [ -z "$ssh_host_ecdsa_key_pub" ]; then
            echo "downloaded ssh_host_ecdsa_key_pub"
            echo "$ssh_host_ecdsa_key_pub" > /etc/ssh/ssh_host_ed25519_key.pub
            chmod 644 /etc/ssh/ssh_host_ed25519_key.pub
          fi

          if ! [ -z "$ssh_root_auth_key" ]; then
            echo "downloaded ssh_root_auth_key"
            mkdir -m 0700 -p /root/.ssh
            echo "$ssh_root_auth_key" > /root/.ssh/authorized_keys
            chmod 600 /root/.ssh/authorized_keys
          fi
        '';
      serviceConfig.Type = "oneshot";
      serviceConfig.RemainAfterExit = true;
      serviceConfig.StandardError = "journal+console";
      serviceConfig.StandardOutput = "journal+console";
    };
  };
}
