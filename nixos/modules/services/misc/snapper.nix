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
      default = {};
      example = literalExample {
        home = {
          subvolume = "/home";
          extraConfig = ''
            ALLOW_USERS="alice"
          '';
        };
      };

      description = ''
        Subvolume configuration
      '';

      type = types.attrsOf (
        types.submodule {
          options = {
            subvolume = mkOption {
              type = types.path;
              description = ''
                Path of the subvolume or mount point.
                A child subvolume with required permissions will be created at .snapshots
                if it does not exist yet.
              '';
            };

            fstype = mkOption {
              type = types.enum [ "btrfs" ];
              default = "btrfs";
              description = ''
                Filesystem type. Only btrfs is stable and tested.
              '';
            };

            allowUsers = mkOption {
              type = types.listOf types.str;
              default = [];
              description = ''
                List of users allowed to operate the configuration. root is always
                implicitely contained in this list.
                These users must have permissions to traverse directories up
                to the specified subvolume.
              '';
            };

            allowGroups = mkOption {
              type = types.listOf types.str;
              default = [];
              description = ''
                List of groups allowed to operate the configuration.
                These groups must have permissions to traverse directories up
                to the specified subvolume.
              '';
            };

            extraConfig = mkOption {
              type = types.lines;
              default = "";
              description = ''
                Additional configuration next to SUBVOLUME, ALLOW_USERS, ALLOW_GROUPS, and FSTYPE.
                See man:snapper-configs(5).
              '';
            };
          };
        }
      );
    };
  };

  config = mkIf (cfg.configs != {}) (
    let
      documentation = [ "man:snapper(8)" "man:snapper-configs(5)" ];
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
          // (
            mapAttrs' (
              name: subvolume: nameValuePair "snapper/configs/${name}" (
                {
                  text = ''
                    ${subvolume.extraConfig}
                    FSTYPE="${subvolume.fstype}"
                    SUBVOLUME="${subvolume.subvolume}"
                    ALLOW_USERS=${lib.concatStringsSep " " subvolume.allowUsers}
                    ALLOW_GROUPS=${lib.concatStringsSep " " subvolume.allowGroups}
                  '';
                }
              )
            ) cfg.configs
          )
          // (
            lib.optionalAttrs (cfg.filters != null) {
              "snapper/filters/default.txt".text = cfg.filters;
            }
          );

        };

        systemd.services.snapper-subvolume-setup = {
          description = "Creates .snapshots subvolumes for Snapper Snapshots";
          inherit documentation;
          script = let
            config = cfg: "v /.snapshots 0770 root root\n" + (
              let
                acl = lib.concatMapStringsSep "," (x: "${x}:r-x") ((map (u: "u:${u}") cfg.allowUsers) ++ (map (g: "g:${g}") cfg.allowGroups));
              in
                optionalString (acl != "") "a /.snapshots - - - - ${acl}"
            );
            cmd = cfg: "systemd-tmpfiles --create --root ${cfg.subvolume} ${builtins.toFile "snapper-subvolume-setup.conf" (config cfg)}";
          in
          lib.concatStringsSep "\n" (lib.mapAttrsToList (name: cfg: cmd cfg) cfg.configs);
          wantedBy = [ "multi-user.target" ];
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
      }
  );
}
