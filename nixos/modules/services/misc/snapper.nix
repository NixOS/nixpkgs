{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.snapper;

  mkValue =
    v:
    if lib.isList v then
      "\"${
        lib.concatMapStringsSep " " (lib.escape [
          "\\"
          " "
        ]) v
      }\""
    else if v == true then
      "yes"
    else if v == false then
      "no"
    else if lib.isString v then
      "\"${v}\""
    else
      builtins.toJSON v;

  mkKeyValue = k: v: "${k}=${mkValue v}";

  # "it's recommended to always specify the filesystem type"  -- man snapper-configs
  defaultOf = k: if k == "FSTYPE" then null else configOptions.${k}.default or null;

  safeStr = lib.types.strMatching "[^\n\"]*" // {
    description = "string without line breaks or quotes";
    descriptionClass = "conjunction";
  };

  intOrNumberOrRange = lib.types.either lib.types.ints.unsigned (
    lib.types.strMatching "[[:digit:]]+(-[[:digit:]]+)?"
    // {
      description = "string containing either a number or a range";
      descriptionClass = "conjunction";
    }
  );

  configOptions = {
    SUBVOLUME = lib.mkOption {
      type = lib.types.path;
      description = ''
        Path of the subvolume or mount point.
        This path is a subvolume and has to contain a subvolume named
        .snapshots.
        See also man:snapper(8) section PERMISSIONS.
      '';
    };

    FSTYPE = lib.mkOption {
      type = lib.types.enum [
        "btrfs"
        "bcachefs"
      ];
      default = "btrfs";
      description = ''
        Filesystem type. Only btrfs is stable and tested.

        bcachefs support is experimental.
      '';
    };

    ALLOW_GROUPS = lib.mkOption {
      type = lib.types.listOf safeStr;
      default = [ ];
      description = ''
        List of groups allowed to operate with the config.

        Also see the PERMISSIONS section in man:snapper(8).
      '';
    };

    ALLOW_USERS = lib.mkOption {
      type = lib.types.listOf safeStr;
      default = [ ];
      example = [ "alice" ];
      description = ''
        List of users allowed to operate with the config. "root" is always
        implicitly included.

        Also see the PERMISSIONS section in man:snapper(8).
      '';
    };

    TIMELINE_CLEANUP = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Defines whether the timeline cleanup algorithm should be run for the config.
      '';
    };

    TIMELINE_CREATE = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Defines whether hourly snapshots should be created.
      '';
    };

    TIMELINE_LIMIT_HOURLY = lib.mkOption {
      type = intOrNumberOrRange;
      default = 10;
      description = ''
        Limits for timeline cleanup.
      '';
    };

    TIMELINE_LIMIT_DAILY = lib.mkOption {
      type = intOrNumberOrRange;
      default = 10;
      description = ''
        Limits for timeline cleanup.
      '';
    };

    TIMELINE_LIMIT_WEEKLY = lib.mkOption {
      type = intOrNumberOrRange;
      default = 0;
      description = ''
        Limits for timeline cleanup.
      '';
    };

    TIMELINE_LIMIT_MONTHLY = lib.mkOption {
      type = intOrNumberOrRange;
      default = 10;
      description = ''
        Limits for timeline cleanup.
      '';
    };

    TIMELINE_LIMIT_QUARTERLY = lib.mkOption {
      type = intOrNumberOrRange;
      default = 0;
      description = ''
        Limits for timeline cleanup.
      '';
    };

    TIMELINE_LIMIT_YEARLY = lib.mkOption {
      type = intOrNumberOrRange;
      default = 10;
      description = ''
        Limits for timeline cleanup.
      '';
    };
  };
in

{
  options.services.snapper = {

    snapshotRootOnBoot = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to snapshot root on boot
      '';
    };

    snapshotInterval = lib.mkOption {
      type = lib.types.str;
      default = "hourly";
      description = ''
        Snapshot interval.

        The format is described in
        {manpage}`systemd.time(7)`.
      '';
    };

    persistentTimer = lib.mkOption {
      default = false;
      type = lib.types.bool;
      example = true;
      description = ''
        Set the `Persistent` option for the
        {manpage}`systemd.timer(5)`
        which triggers the snapshot immediately if the last trigger
        was missed (e.g. if the system was powered down).
      '';
    };

    cleanupInterval = lib.mkOption {
      type = lib.types.str;
      default = "1d";
      description = ''
        Cleanup interval.

        The format is described in
        {manpage}`systemd.time(7)`.
      '';
    };

    filters = lib.mkOption {
      type = lib.types.nullOr lib.types.lines;
      default = null;
      description = ''
        Global display difference filter. See man:snapper(8) for more details.
      '';
    };

    configs = lib.mkOption {
      default = { };
      example = lib.literalExpression ''
        {
          home = {
            SUBVOLUME = "/home";
            ALLOW_USERS = [ "alice" ];
            TIMELINE_CREATE = true;
            TIMELINE_CLEANUP = true;
          };
        }
      '';

      description = ''
        Subvolume configuration. Any option mentioned in man:snapper-configs(5)
        is valid here, even if NixOS doesn't document it.
      '';

      type = lib.types.attrsOf (
        lib.types.submodule {
          freeformType = lib.types.attrsOf (
            lib.types.oneOf [
              (lib.types.listOf safeStr)
              lib.types.bool
              safeStr
              lib.types.number
            ]
          );

          options = configOptions;
        }
      );
    };
  };

  config = lib.mkIf (cfg.configs != { }) (
    let
      documentation = [
        "man:snapper(8)"
        "man:snapper-configs(5)"
      ];
    in
    {
      environment = {

        systemPackages = [ pkgs.snapper ];

        # Note: snapper/config-templates/default is only needed for create-config
        #       which is not the NixOS way to configure.
        etc = {

          "sysconfig/snapper".text = ''
            SNAPPER_CONFIGS="${lib.concatStringsSep " " (builtins.attrNames cfg.configs)}"
          '';
        }
        // (lib.mapAttrs' (
          name: subvolume:
          lib.nameValuePair "snapper/configs/${name}" ({
            text = lib.generators.toKeyValue { inherit mkKeyValue; } (
              lib.filterAttrs (k: v: v != defaultOf k) subvolume
            );
          })
        ) cfg.configs)
        // (lib.optionalAttrs (cfg.filters != null) { "snapper/filters/default.txt".text = cfg.filters; });
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
      };

      systemd.timers.snapper-timeline = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          Persistent = cfg.persistentTimer;
          OnCalendar = cfg.snapshotInterval;
        };
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

      systemd.services.snapper-boot = lib.mkIf cfg.snapshotRootOnBoot {
        description = "Take snapper snapshot of root on boot";
        inherit documentation;
        serviceConfig.ExecStart = "${pkgs.snapper}/bin/snapper --config root create --cleanup-algorithm number --description boot";
        serviceConfig.Type = "oneshot";
        requires = [ "local-fs.target" ];
        wantedBy = [ "multi-user.target" ];
        unitConfig.ConditionPathExists = "/etc/snapper/configs/root";
      };

      assertions = lib.concatMap (
        name:
        let
          sub = cfg.configs.${name};
        in
        [
          {
            assertion = !(sub ? extraConfig);
            message = ''
              The option definition `services.snapper.configs.${name}.extraConfig' no longer has any effect; please remove it.
              The contents of this option should be migrated to attributes on `services.snapper.configs.${name}'.
            '';
          }
        ]
        ++
          map
            (attr: {
              assertion = !(lib.hasAttr attr sub);
              message = ''
                The option definition `services.snapper.configs.${name}.${attr}' has been renamed to `services.snapper.configs.${name}.${lib.toUpper attr}'.
              '';
            })
            [
              "fstype"
              "subvolume"
            ]
      ) (lib.attrNames cfg.configs);
    }
  );

  meta.maintainers = with lib.maintainers; [ Djabx ];
}
