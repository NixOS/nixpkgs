{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.cloud-init;
  path = with pkgs; [
    cloud-init
    iproute2
    nettools
    openssh
    shadow
    util-linux
    busybox
  ]
  ++ optional cfg.btrfs.enable btrfs-progs
  ++ optional cfg.ext4.enable e2fsprogs
  ++ optional cfg.xfs.enable xfsprogs
  ++ cfg.extraPackages
  ;
  hasFs = fsName: lib.any (fs: fs.fsType == fsName) (lib.attrValues config.fileSystems);
  settingsFormat = pkgs.formats.yaml { };
  cfgfile = settingsFormat.generate "cloud.cfg" cfg.settings;
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
          cloud-init might be overridden by a subsequent nixos-rebuild
          call. However, some parts of cloud-init fall outside of
          NixOS's responsibility, like filesystem resizing and ssh
          public key provisioning, and cloud-init is useful for that
          parts. Thus, be wary that using cloud-init in NixOS might
          come as some cost.
        '';
      };

      btrfs.enable = mkOption {
        type = types.bool;
        default = hasFs "btrfs";
        defaultText = literalExpression ''hasFs "btrfs"'';
        description = ''
          Allow the cloud-init service to operate `btrfs` filesystem.
        '';
      };

      ext4.enable = mkOption {
        type = types.bool;
        default = hasFs "ext4";
        defaultText = literalExpression ''hasFs "ext4"'';
        description = ''
          Allow the cloud-init service to operate `ext4` filesystem.
        '';
      };

      xfs.enable = mkOption {
        type = types.bool;
        default = hasFs "xfs";
        defaultText = literalExpression ''hasFs "xfs"'';
        description = ''
          Allow the cloud-init service to operate `xfs` filesystem.
        '';
      };

      network.enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Allow the cloud-init service to configure network interfaces
          through systemd-networkd.
        '';
      };

      extraPackages = mkOption {
        type = types.listOf types.package;
        default = [ ];
        description = ''
          List of additional packages to be available within cloud-init jobs.
        '';
      };

      settings = mkOption {
        description = ''
          Structured cloud-init configuration.
        '';
        type = types.submodule {
          freeformType = settingsFormat.type;
        };
        default = { };
      };

      config = mkOption {
        type = types.str;
        default = "";
        description = ''
          raw cloud-init configuration.

          Takes precedence over the `settings` option if set.
        '';
      };

    };

  };

  config = mkIf cfg.enable {
    services.cloud-init.settings = {
      system_info = mkDefault {
        distro = "nixos";
        network = {
          renderers = [ "networkd" ];
        };
      };

      users = mkDefault [ "root" ];
      disable_root = mkDefault false;
      preserve_hostname = mkDefault false;

      cloud_init_modules = mkDefault [
        "migrator"
        "seed_random"
        "bootcmd"
        "write-files"
        "growpart"
        "resizefs"
        "update_hostname"
        "resolv_conf"
        "ca-certs"
        "rsyslog"
        "users-groups"
      ];

      cloud_config_modules = mkDefault [
        "disk_setup"
        "mounts"
        "ssh-import-id"
        "set-passwords"
        "timezone"
        "disable-ec2-metadata"
        "runcmd"
        "ssh"
      ];

      cloud_final_modules = mkDefault [
        "rightscale_userdata"
        "scripts-vendor"
        "scripts-per-once"
        "scripts-per-boot"
        "scripts-per-instance"
        "scripts-user"
        "ssh-authkey-fingerprints"
        "keys-to-console"
        "phone-home"
        "final-message"
        "power-state-change"
      ];
    };

    environment.etc."cloud/cloud.cfg" =
      if cfg.config == "" then
        { source = cfgfile; }
      else
        { text = cfg.config; }
    ;

    systemd.network.enable = mkIf cfg.network.enable true;

    systemd.services.cloud-init-local = {
      description = "Initial cloud-init job (pre-networking)";
      wantedBy = [ "multi-user.target" ];
      # In certain environments (AWS for example), cloud-init-local will
      # first configure an IP through DHCP, and later delete it.
      # This can cause race conditions with anything else trying to set IP through DHCP.
      before = [ "systemd-networkd.service" "dhcpcd.service" ];
      path = path;
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.cloud-init}/bin/cloud-init init --local";
        RemainAfterExit = "yes";
        TimeoutSec = "infinity";
        StandardOutput = "journal+console";
      };
    };

    systemd.services.cloud-init = {
      description = "Initial cloud-init job (metadata service crawler)";
      wantedBy = [ "multi-user.target" ];
      wants = [
        "network-online.target"
        "cloud-init-local.service"
        "sshd.service"
        "sshd-keygen.service"
      ];
      after = [ "network-online.target" "cloud-init-local.service" ];
      before = [ "sshd.service" "sshd-keygen.service" ];
      requires = [ "network.target" ];
      path = path;
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.cloud-init}/bin/cloud-init init";
        RemainAfterExit = "yes";
        TimeoutSec = "infinity";
        StandardOutput = "journal+console";
      };
    };

    systemd.services.cloud-config = {
      description = "Apply the settings specified in cloud-config";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" "cloud-config.target" ];

      path = path;
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.cloud-init}/bin/cloud-init modules --mode=config";
        RemainAfterExit = "yes";
        TimeoutSec = "infinity";
        StandardOutput = "journal+console";
      };
    };

    systemd.services.cloud-final = {
      description = "Execute cloud user/final scripts";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" "cloud-config.service" "rc-local.service" ];
      requires = [ "cloud-config.target" ];
      path = path;
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.cloud-init}/bin/cloud-init modules --mode=final";
        RemainAfterExit = "yes";
        TimeoutSec = "infinity";
        StandardOutput = "journal+console";
      };
    };

    systemd.targets.cloud-config = {
      description = "Cloud-config availability";
      requires = [ "cloud-init-local.service" "cloud-init.service" ];
    };
  };

  meta.maintainers = [ maintainers.zimbatm ];
}
