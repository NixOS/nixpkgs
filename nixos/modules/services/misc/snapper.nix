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

    configs = mkOption {
      default = { };
      example = literalExample {
        "home" = {
          mountPoint = "/home";
          extraConfig = ''
            ALLOW_USERS="alice"
          '';
        };
      };

      type = types.attrsOf (types.submodule {
        options = {
          mountPoint = mkOption {
            type = types.string;
          };

          extraConfig = mkOption {
            type = types.lines;
            default = "";
            description = ''
              see man:snapper(8)

              Note: FSTYPE and SUBVOLUME are already set
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

      # Note: snapper/config-templates/default is not needed
      etc = {

        "sysconfig/snapper".text = ''
          SNAPPER_CONFIGS="${lib.concatStringsSep " " (builtins.attrNames cfg.configs)}"
        '';

      } // mapAttrs' (name: subvolume: nameValuePair "snapper/configs/${name}" (
      {
        text = ''
          ${subvolume.extraConfig}

          # mandatory for rollback!
          FSTYPE="${(builtins.getAttr subvolume.mountPoint config.fileSystems).fsType}"

          SUBVOLUME="${subvolume.mountPoint}"
        '';
      })) cfg.configs;

    };

    # TODO: automatically create subvolume .snapshots for each config
    #
    # Only possible if filesystem is mounted
    #   system.activationScripts is executed during boot before mounting
    #   systemd.mounts.<mountPoint> could be a way to go

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
      timerConfig.OnCalender = cfg.snapshotInterval;
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

