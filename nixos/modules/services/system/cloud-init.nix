{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.cloud-init;
    path = with pkgs; [ cloud-init nettools utillinux e2fsprogs shadow openssh iproute ];
in
{
  options = {

    services.cloud-init = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable the cloud-init service. This services reads
          configuration metadata in a cloud environment and configures
          the machine according to this metadata.

          This configuration is not completely compatible with the
          NixOS way of doing configuration, as configuration done by
          cloud-init might be overriden by a subsequent nixos-rebuild
          call. However, some parts of cloud-init fall outside of
          NixOS's responsibility, like filesystem resizing and ssh
          public key provisioning, and cloud-init is useful for that
          parts. Thus, be wary that using cloud-init in NixOS might
          come as some cost.
        '';
      };

      config = mkOption {
        type = types.str;
        default = ''
          system_info:
            distro: nixos
          users:
             - root

          disable_root: false
          preserve_hostname: false

          cloud_init_modules:
           - migrator
           - seed_random
           - bootcmd
           - write-files
           - growpart
           - resizefs
           - set_hostname
           - update_hostname
           - update_etc_hosts
           - ca-certs
           - rsyslog
           - users-groups

          cloud_config_modules:
           - disk_setup
           - mounts
           - ssh-import-id
           - set-passwords
           - timezone
           - disable-ec2-metadata
           - runcmd
           - ssh

          cloud_final_modules:
           - rightscale_userdata
           - scripts-vendor
           - scripts-per-once
           - scripts-per-boot
           - scripts-per-instance
           - scripts-user
           - ssh-authkey-fingerprints
           - keys-to-console
           - phone-home
           - final-message
           - power-state-change
          '';
        description = ''cloud-init configuration.'';
      };

    };

  };

  config = mkIf cfg.enable {

    environment.etc."cloud/cloud.cfg".text = cfg.config;

    systemd.services.cloud-init-local =
      { description = "Initial cloud-init job (pre-networking)";
        wantedBy = [ "multi-user.target" ];
        wants = [ "local-fs.target" ];
        after = [ "local-fs.target" ];
        path = path;
        serviceConfig =
          { Type = "oneshot";
            ExecStart = "${pkgs.cloud-init}/bin/cloud-init init --local";
            RemainAfterExit = "yes";
            TimeoutSec = "0";
            StandardOutput = "journal+console";
          };
      };

    systemd.services.cloud-init =
      { description = "Initial cloud-init job (metadata service crawler)";
        wantedBy = [ "multi-user.target" ];
        wants = [ "local-fs.target" "cloud-init-local.service" "sshd.service" "sshd-keygen.service" ];
        after = [ "local-fs.target" "network.target" "cloud-init-local.service" ];
        before = [ "sshd.service" "sshd-keygen.service" ];
        requires = [ "network.target "];
        path = path;
        serviceConfig =
          { Type = "oneshot";
            ExecStart = "${pkgs.cloud-init}/bin/cloud-init init";
            RemainAfterExit = "yes";
            TimeoutSec = "0";
            StandardOutput = "journal+console";
          };
      };

    systemd.services.cloud-config =
      { description = "Apply the settings specified in cloud-config";
        wantedBy = [ "multi-user.target" ];
        wants = [ "network.target" ];
        after = [ "network.target" "syslog.target" "cloud-config.target" ];

        path = path;
        serviceConfig =
          { Type = "oneshot";
            ExecStart = "${pkgs.cloud-init}/bin/cloud-init modules --mode=config";
            RemainAfterExit = "yes";
            TimeoutSec = "0";
            StandardOutput = "journal+console";
          };
      };

    systemd.services.cloud-final =
      { description = "Execute cloud user/final scripts";
        wantedBy = [ "multi-user.target" ];
        wants = [ "network.target" ];
        after = [ "network.target" "syslog.target" "cloud-config.service" "rc-local.service" ];
        requires = [ "cloud-config.target" ];
        path = path;
        serviceConfig =
          { Type = "oneshot";
            ExecStart = "${pkgs.cloud-init}/bin/cloud-init modules --mode=final";
            RemainAfterExit = "yes";
            TimeoutSec = "0";
            StandardOutput = "journal+console";
          };
      };

    systemd.targets.cloud-config =
      { description = "Cloud-config availability";
        requires = [ "cloud-init-local.service" "cloud-init.service" ];
      };
  };
}
