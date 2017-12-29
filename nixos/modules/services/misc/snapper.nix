{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.snapper;
in

{
  options.services.snapper = {

    snapshotInterval = mkOption {
      type = types.str;
      default = "hourly";
      description = ''
        Snapshot interval.

        The format is described in
        <citerefentry><refentrytitle>systemd.time</refentrytitle>
        <manvolnum>7</manvolnum></citerefentry>.
      '';
    };

    cleanupInterval = mkOption {
      type = types.str;
      default = "1d";
      description = ''
        Cleanup interval.

        The format is described in
        <citerefentry><refentrytitle>systemd.time</refentrytitle>
        <manvolnum>7</manvolnum></citerefentry>.
      '';
    };

    filters = mkOption {
      type = types.nullOr types.lines;
      default = null;
      description = ''
        Global display difference filter. See man:snapper(8) for more details.
      '';
    };

    configs = mkOption {
      default = { };
      example = literalExample {
        "home" = {
          subvolume = "/home";
          extraConfig = ''
            ALLOW_USERS="alice"
          '';
        };
      };

      description = ''
        Subvolume configuration
      '';

      type = types.attrsOf (types.submodule {
        options = {
          subvolume = mkOption {
            type = types.path;
            description = ''
              Path of the subvolume or mount point.
              This path is a subvolume and has to contain a subvolume named
              .snapshots.
              See also man:snapper(8) section PERMISSIONS.
            '';
          };

          fstype = mkOption {
            type = types.enum [ "btrfs" ];
            default = "btrfs";
            description = ''
              Filesystem type. Only btrfs is stable and tested.
            '';
          };

          extraConfig = mkOption {
            type = types.lines;
            default = "";
            description = ''
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

    systemd.services.snapper-timeline = {
      description = "Timeline of Snapper Snapshots";
      inherit documentation;
      serviceConfig.ExecStart = "${pkgs.snapper}/lib/snapper/systemd-helper --timeline";
    };

    systemd.timers.snapper-timeline = {
      description = "Timeline of Snapper Snapshots";
      inherit documentation;
      wantedBy = [ "basic.target" ];
      timerConfig.OnCalendar = cfg.snapshotInterval;
    };

    systemd.services.snapper-cleanup = {
      description = "Cleanup of Snapper Snapshots";
      inherit documentation;
      serviceConfig.ExecStart = "${pkgs.snapper}/lib/snapper/systemd-helper --cleanup";
    };

    systemd.timers.snapper-cleanup = {
      description = "Cleanup of Snapper Snapshots";
      inherit documentation;
      wantedBy = [ "basic.target" ];
      timerConfig.OnBootSec = "10m";
      timerConfig.OnUnitActiveSec = cfg.cleanupInterval;
    };
  });
}

