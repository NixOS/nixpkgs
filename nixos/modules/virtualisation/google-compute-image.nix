{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.virtualisation.googleComputeImage;
  defaultConfigFile = pkgs.writeText "configuration.nix" ''
    { ... }:
    {
      imports = [
        <nixpkgs/nixos/modules/virtualisation/google-compute-image.nix>
      ];
    }
  '';
in
{

  imports = [ ./google-compute-config.nix ];

  options = {
    virtualisation.googleComputeImage.diskSize = mkOption {
      type = with types; int;
      default = 1536;
      description = ''
        Size of disk image. Unit is MB.
      '';
    };

    virtualisation.googleComputeImage.configFile = mkOption {
      type = with types; nullOr str;
      default = null;
      description = ''
        A path to a configuration file which will be placed at `/etc/nixos/configuration.nix`
        and be used when switching to a new configuration.
        If set to `null`, a default configuration is used, where the only import is
        `<nixpkgs/nixos/modules/virtualisation/google-compute-image.nix>`.
      '';
    };
  };

  #### implementation
  config = {

    system.build.googleComputeImage = import ../../lib/make-disk-image.nix {
      name = "google-compute-image";
      postVM = ''
        PATH=$PATH:${with pkgs; stdenv.lib.makeBinPath [ gnutar gzip ]}
        pushd $out
        mv $diskImage disk.raw
        tar -Szcf nixos-image-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}.raw.tar.gz disk.raw
        rm $out/disk.raw
        popd
      '';
      format = "raw";
      configFile = if isNull cfg.configFile then defaultConfigFile else cfg.configFile;
      inherit (cfg) diskSize;
      inherit config lib pkgs;
    };

    # TODO: remove this, NixOS/nixpkgs#33004
    # systemd.services.fetch-ssh-keys =
    #   { description = "Fetch host keys and authorized_keys for root user";

    #     wantedBy = [ "sshd.service" ];
    #     before = [ "sshd.service" ];
    #     after = [ "network-online.target" ];
    #     wants = [ "network-online.target" ];

    #     script = let wget = "${pkgs.wget}/bin/wget --retry-connrefused -t 15 --waitretry=10 --header='Metadata-Flavor: Google'";
    #                  mktemp = "mktemp --tmpdir=/run"; in
    #       ''
    #         # When dealing with cryptographic keys, we want to keep things private.
    #         umask 077
    #         # Don't download the SSH key if it has already been downloaded
    #         echo "Obtaining SSH keys..."
    #         mkdir -m 0700 -p /root/.ssh
    #         AUTH_KEYS=$(${mktemp})
    #         ${wget} -O $AUTH_KEYS http://metadata.google.internal/computeMetadata/v1/instance/attributes/sshKeys
    #         if [ -s $AUTH_KEYS ]; then

    #           # Read in key one by one, split in case Google decided
    #           # to append metadata (it does sometimes) and add to
    #           # authorized_keys if not already present.
    #           touch /root/.ssh/authorized_keys
    #           NEW_KEYS=$(${mktemp})
    #           # Yes this is a nix escape of two single quotes.
    #           while IFS=''' read -r line || [[ -n "$line" ]]; do
    #             keyLine=$(echo -n "$line" | cut -d ':' -f2)
    #             IFS=' ' read -r -a array <<< "$keyLine"
    #             if [ ''${#array[@]} -ge 3 ]; then
    #               echo ''${array[@]:0:3} >> $NEW_KEYS
    #               echo "Added ''${array[@]:2} to authorized_keys"
    #             fi
    #           done < $AUTH_KEYS
    #           mv $NEW_KEYS /root/.ssh/authorized_keys
    #           chmod 600 /root/.ssh/authorized_keys
    #           rm -f $KEY_PUB
    #         else
    #           echo "Downloading http://metadata.google.internal/computeMetadata/v1/project/attributes/sshKeys failed."
    #           false
    #         fi
    #         rm -f $AUTH_KEYS
    #         SSH_HOST_KEYS_DIR=$(${mktemp} -d)
    #         ${wget} -O $SSH_HOST_KEYS_DIR/ssh_host_ed25519_key http://metadata.google.internal/computeMetadata/v1/instance/attributes/ssh_host_ed25519_key
    #         ${wget} -O $SSH_HOST_KEYS_DIR/ssh_host_ed25519_key.pub http://metadata.google.internal/computeMetadata/v1/instance/attributes/ssh_host_ed25519_key_pub
    #         if [ -s $SSH_HOST_KEYS_DIR/ssh_host_ed25519_key -a -s $SSH_HOST_KEYS_DIR/ssh_host_ed25519_key.pub ]; then
    #             mv -f $SSH_HOST_KEYS_DIR/ssh_host_ed25519_key* /etc/ssh/
    #             chmod 600 /etc/ssh/ssh_host_ed25519_key
    #             chmod 644 /etc/ssh/ssh_host_ed25519_key.pub
    #         else
    #             echo "Setup of ssh host keys from http://metadata.google.internal/computeMetadata/v1/instance/attributes/ failed."
    #             false
    #         fi
    #         rm -rf $SSH_HOST_KEYS_DIR
    #       '';
    #     serviceConfig.Type = "oneshot";
    #     serviceConfig.RemainAfterExit = true;
    #     serviceConfig.StandardError = "journal+console";
    #     serviceConfig.StandardOutput = "journal+console";
    #   };

  };
}
