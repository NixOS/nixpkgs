{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.snapper;
in

{
  options.services.snapper = {

    snapshotRootOnBoot = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to snapshot root on boot
      '';
    };

    snapshotInterval = mkOption {
      type = types.str;
      default = "hourly";
      description = lib.mdDoc ''
        Snapshot interval.

        The format is described in
        {manpage}`systemd.time(7)`.
      '';
    };

    cleanupInterval = mkOption {
      type = types.str;
      default = "1d";
      description = lib.mdDoc ''
        Cleanup interval.

        The format is described in
        {manpage}`systemd.time(7)`.
      '';
    };

    filters = mkOption {
      type = types.nullOr types.lines;
      default = null;
      description = lib.mdDoc ''
        Global display difference filter. See man:snapper(8) for more details.
      '';
    };

    configs = mkOption {
      default = { };
      example = literalExpression ''
        {
          home = {
            subvolume = "/home";
            extraConfig = '''
              ALLOW_USERS="alice"
              TIMELINE_CREATE=yes
              TIMELINE_CLEANUP=yes
            ''';
          };
        }
      '';

      description = lib.mdDoc ''
        Subvolume configuration
      '';

      type = types.attrsOf (types.submodule {
        options = {
          subvolume = mkOption {
            type = types.path;
            description = lib.mdDoc ''
              Path of the subvolume or mount point.
              This path is a subvolume and has to contain a subvolume named
              .snapshots.
              See also man:snapper(8) section PERMISSIONS.
            '';
          };

          fstype = mkOption {
            type = types.enum [ "btrfs" ];
            default = "btrfs";
            description = lib.mdDoc ''
              Filesystem type. Only btrfs is stable and tested.
            '';
          };

          extraConfig = mkOption {
            type = types.lines;
            default = "";
            description = lib.mdDoc ''
              Additional configuration next to SUBVOLUME and FSTYPE.
              See man:snapper-configs(5).
            '';
          };
        };
      });
    };
  };

  config = mkIf (cfg.configs != {}) (let
    documentation = [ "man:snapper(8)" "man:snapper-configs(5)" ];
  in {

    environment = {

      systemPackages = [ pkgs.snapper ];

      # Note: snapper/config-templates/default is only needed for create-config
      #       which is not the NixOS way to configure.
      etc = {

        "sysconfig/snapper".text = ''
          SNAPPER_CONFIGS="${lib.concatStringsSep " " (builtins.attrNames cfg.configs)}"
        '';

      }
      // (mapAttrs' (name: subvolume: nameValuePair "snapper/configs/${name}" ({
        text = ''
          ${subvolume.extraConfig}
          FSTYPE="${subvolume.fstype}"
          SUBVOLUME="${subvolume.subvolume}"
        '';
      })) cfg.configs)
      // (lib.optionalAttrs (cfg.filters != null) {
        "snapper/filters/default.txt".text = cfg.filters;
      });

    };

    services.dbus.packages = [ pkgs.snapper ];

    systemd.services.snapperd = {
      description = "DBus interface for snapper";
      inherit documentation;
      serviceConfig = {
        Type = "dbus";
        BusName = "org.opensuse.Snapper";
        ExecStart = "${pkgs.snapper}/bin/snapperd";
        CapabilityBoundingSet = "CAP_DAC_OVERRIDE CAP_FOWNER CAP_CHOWN CAP_FSETID CAP_SETFCAP CAP_SYS_ADMIN CAP_SYS_MODULE CAP_IPC_LOCK CAP_SYS_NICE";
        LockPersonality = true;
        NoNewPrivileges = false;
        PrivateNetwork = true;
        ProtectHostname = true;
        RestrictAddressFamilies = "AF_UNIX";
        RestrictRealtime = true;
      };
    };

    systemd.services.snapper-timeline = {
      description = "Timeline of Snapper Snapshots";
      inherit documentation;
      requires = [ "local-fs.target" ];
      serviceConfig.ExecStart = "${pkgs.snapper}/lib/snapper/systemd-helper --timeline";
      startAt = cfg.snapshotInterval;
    };

    systemd.services.snapper-cleanup = {
      description = "Cleanup of Snapper Snapshots";
      inherit documentation;
      serviceConfig.ExecStart = "${pkgs.snapper}/lib/snapper/systemd-helper --cleanup";
    };

    systemd.timers.snapper-cleanup = {
      description = "Cleanup of Snapper Snapshots";
      inherit documentation;
      wantedBy = [ "timers.target" ];
      requires = [ "local-fs.target" ];
      timerConfig.OnBootSec = "10m";
      timerConfig.OnUnitActiveSec = cfg.cleanupInterval;
    };

    systemd.services.snapper-boot = lib.optionalAttrs cfg.snapshotRootOnBoot {
      description = "Take snapper snapshot of root on boot";
      inherit documentation;
      serviceConfig.ExecStart = "${pkgs.snapper}/bin/snapper --config root create --cleanup-algorithm number --description boot";
      serviceConfig.type = "oneshot";
      requires = [ "local-fs.target" ];
      wantedBy = [ "multi-user.target" ];
      unitConfig.ConditionPathExists = "/etc/snapper/configs/root";
    };

  });
}
