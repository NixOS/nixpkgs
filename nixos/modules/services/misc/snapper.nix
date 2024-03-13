{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.snapper;

  mkValue = v:
    if isList v then "\"${concatMapStringsSep " " (escape [ "\\" " " ]) v}\""
    else if v == true then "yes"
    else if v == false then "no"
    else if isString v then "\"${v}\""
    else builtins.toJSON v;

  mkKeyValue = k: v: "${k}=${mkValue v}";

  # "it's recommended to always specify the filesystem type"  -- man snapper-configs
  defaultOf = k: if k == "FSTYPE" then null else configOptions.${k}.default or null;

  safeStr = types.strMatching "[^\n\"]*" // {
    description = "string without line breaks or quotes";
    descriptionClass = "conjunction";
  };

  configOptions = {
    SUBVOLUME = mkOption {
      type = types.path;
      description = lib.mdDoc ''
        Path of the subvolume or mount point.
        This path is a subvolume and has to contain a subvolume named
        .snapshots.
        See also man:snapper(8) section PERMISSIONS.
      '';
    };

    FSTYPE = mkOption {
      type = types.enum [ "btrfs" ];
      default = "btrfs";
      description = lib.mdDoc ''
        Filesystem type. Only btrfs is stable and tested.
      '';
    };

    ALLOW_GROUPS = mkOption {
      type = types.listOf safeStr;
      default = [];
      description = lib.mdDoc ''
        List of groups allowed to operate with the config.

        Also see the PERMISSIONS section in man:snapper(8).
      '';
    };

    ALLOW_USERS = mkOption {
      type = types.listOf safeStr;
      default = [];
      example = [ "alice" ];
      description = lib.mdDoc ''
        List of users allowed to operate with the config. "root" is always
        implicitly included.

        Also see the PERMISSIONS section in man:snapper(8).
      '';
    };

    TIMELINE_CLEANUP = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Defines whether the timeline cleanup algorithm should be run for the config.
      '';
    };

    TIMELINE_CREATE = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Defines whether hourly snapshots should be created.
      '';
    };
  };
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
            SUBVOLUME = "/home";
            ALLOW_USERS = [ "alice" ];
            TIMELINE_CREATE = true;
            TIMELINE_CLEANUP = true;
          };
        }
      '';

      description = lib.mdDoc ''
        Subvolume configuration. Any option mentioned in man:snapper-configs(5)
        is valid here, even if NixOS doesn't document it.
      '';

      type = types.attrsOf (types.submodule {
        freeformType = types.attrsOf (types.oneOf [ (types.listOf safeStr) types.bool safeStr types.number ]);

        options = configOptions;
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
        text = lib.generators.toKeyValue { inherit mkKeyValue; } (filterAttrs (k: v: v != defaultOf k) subvolume);
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
      serviceConfig.Type = "oneshot";
      requires = [ "local-fs.target" ];
      wantedBy = [ "multi-user.target" ];
      unitConfig.ConditionPathExists = "/etc/snapper/configs/root";
    };

    assertions =
      concatMap
        (name:
          let
            sub = cfg.configs.${name};
          in
          [ { assertion = !(sub ? extraConfig);
              message = ''
                The option definition `services.snapper.configs.${name}.extraConfig' no longer has any effect; please remove it.
                The contents of this option should be migrated to attributes on `services.snapper.configs.${name}'.
              '';
            }
          ] ++
          map
            (attr: {
              assertion = !(hasAttr attr sub);
              message = ''
                The option definition `services.snapper.configs.${name}.${attr}' has been renamed to `services.snapper.configs.${name}.${toUpper attr}'.
              '';
            })
            [ "fstype" "subvolume" ]
        )
        (attrNames cfg.configs);
  });
}
