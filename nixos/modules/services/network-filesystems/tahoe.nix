{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.tahoe;
in
  {
    options.services.tahoe = {
      introducers = mkOption {
        default = {};
        type = types.loaOf types.optionSet;
        description = ''
          The Tahoe introducers.
        '';
        options = {
          nickname = mkOption {
            type = types.str;
            description = ''
              The nickname of this Tahoe introducer.
            '';
          };
          tub.port = mkOption {
            default = 3458;
            type = types.int;
            description = ''
              The port on which the introducer will listen.
            '';
          };
          tub.location = mkOption {
            default = null;
            type = types.nullOr types.str;
            description = ''
              The external location that the introducer should listen on.

              If specified, the port should be included.
            '';
          };
          package = mkOption {
            default = pkgs.tahoelafs;
            defaultText = "pkgs.tahoelafs";
            type = types.package;
            example = literalExample "pkgs.tahoelafs";
            description = ''
              The package to use for the Tahoe LAFS daemon.
            '';
          };
        };
      };
      nodes = mkOption {
        default = {};
        type = types.loaOf types.optionSet;
        description = ''
          The Tahoe nodes.
        '';
        options = {
          nickname = mkOption {
            type = types.str;
            description = ''
              The nickname of this Tahoe node.
            '';
          };
          tub.port = mkOption {
            default = 3457;
            type = types.int;
            description = ''
              The port on which the tub will listen.

              This is the correct setting to tweak if you want Tahoe's storage
              system to listen on a different port.
            '';
          };
          tub.location = mkOption {
            default = null;
            type = types.nullOr types.str;
            description = ''
              The external location that the node should listen on.

              This is the setting to tweak if there are multiple interfaces
              and you want to alter which interface Tahoe is advertising.

              If specified, the port should be included.
            '';
          };
          web.port = mkOption {
            default = 3456;
            type = types.int;
            description = ''
              The port on which the Web server will listen.

              This is the correct setting to tweak if you want Tahoe's WUI to
              listen on a different port.
            '';
          };
          client.introducer = mkOption {
            default = null;
            type = types.nullOr types.str;
            description = ''
              The furl for a Tahoe introducer node.

              Like all furls, keep this safe and don't share it.
            '';
          };
          client.helper = mkOption {
            default = null;
            type = types.nullOr types.str;
            description = ''
              The furl for a Tahoe helper node.

              Like all furls, keep this safe and don't share it.
            '';
          };
          client.shares.needed = mkOption {
            default = 3;
            type = types.int;
            description = ''
              The number of shares required to reconstitute a file.
            '';
          };
          client.shares.happy = mkOption {
            default = 7;
            type = types.int;
            description = ''
              The number of distinct storage nodes required to store
              a file.
            '';
          };
          client.shares.total = mkOption {
            default = 10;
            type = types.int;
            description = ''
              The number of shares required to store a file.
            '';
          };
          storage.enable = mkEnableOption "storage service";
          storage.reservedSpace = mkOption {
            default = "1G";
            type = types.str;
            description = ''
              The amount of filesystem space to not use for storage.
            '';
          };
          helper.enable = mkEnableOption "helper service";
          package = mkOption {
            default = pkgs.tahoelafs;
            defaultText = "pkgs.tahoelafs";
            type = types.package;
            example = literalExample "pkgs.tahoelafs";
            description = ''
              The package to use for the Tahoe LAFS daemon.
            '';
          };
        };
      };
    };
    config = mkMerge [
      (mkIf (cfg.introducers != {}) {
        environment = {
          etc = flip mapAttrs' cfg.introducers (node: settings:
            nameValuePair "tahoe-lafs/introducer-${node}.cfg" {
              mode = "0444";
              text = ''
                # This configuration is generated by Nix. Edit at your own
                # peril; here be dragons.

                [node]
                nickname = ${settings.nickname}
                tub.port = ${toString settings.tub.port}
                ${optionalString (settings.tub.location != null)
                  "tub.location = ${settings.tub.location}"}
              '';
            });
          # Actually require Tahoe, so that we will have it installed.
          systemPackages = flip mapAttrsToList cfg.introducers (node: settings:
            settings.package
          );
        };
        # Open up the firewall.
        # networking.firewall.allowedTCPPorts = flip mapAttrsToList cfg.introducers
        #   (node: settings: settings.tub.port);
        systemd.services = flip mapAttrs' cfg.introducers (node: settings:
          let
            pidfile = "/run/tahoe.introducer-${node}.pid";
            # This is a directory, but it has no trailing slash. Tahoe commands
            # get antsy when there's a trailing slash.
            nodedir = "/var/db/tahoe-lafs/introducer-${node}";
          in nameValuePair "tahoe.introducer-${node}" {
            description = "Tahoe LAFS node ${node}";
            wantedBy = [ "multi-user.target" ];
            path = [ settings.package ];
            restartTriggers = [
              config.environment.etc."tahoe-lafs/introducer-${node}.cfg".source ];
            serviceConfig = {
              Type = "simple";
              PIDFile = pidfile;
            };
            preStart = ''
              if [ \! -d ${nodedir} ]; then
                mkdir -p /var/db/tahoe-lafs
                tahoe create-introducer ${nodedir}
              fi

              # Tahoe has created a predefined tahoe.cfg which we must now
              # scribble over.
              # XXX I thought that a symlink would work here, but it doesn't, so
              # we must do this on every prestart. Fixes welcome.
              # rm ${nodedir}/tahoe.cfg
              # ln -s /etc/tahoe-lafs/introducer-${node}.cfg ${nodedir}/tahoe.cfg
              cp /etc/tahoe-lafs/introducer-${node}.cfg ${nodedir}/tahoe.cfg
            '';
            # Believe it or not, Tahoe is very brittle about the order of
            # arguments to $(tahoe start). The node directory must come first,
            # and arguments which alter Twisted's behavior come afterwards.
            script = ''
              tahoe start ${nodedir} -n -l- --pidfile=${pidfile}
            '';
          });
        users.extraUsers = flip mapAttrs' cfg.introducers (node: _:
          nameValuePair "tahoe.introducer-${node}" {
            description = "Tahoe node user for introducer ${node}";
            isSystemUser = true;
          });
      })
      (mkIf (cfg.nodes != {}) {
        environment = {
          etc = flip mapAttrs' cfg.nodes (node: settings:
            nameValuePair "tahoe-lafs/${node}.cfg" {
              mode = "0444";
              text = ''
                # This configuration is generated by Nix. Edit at your own
                # peril; here be dragons.

                [node]
                nickname = ${settings.nickname}
                tub.port = ${toString settings.tub.port}
                ${optionalString (settings.tub.location != null)
                  "tub.location = ${settings.tub.location}"}
                # This is a Twisted endpoint. Twisted Web doesn't work on
                # non-TCP. ~ C.
                web.port = tcp:${toString settings.web.port}

                [client]
                ${optionalString (settings.client.introducer != null)
                  "introducer.furl = ${settings.client.introducer}"}
                ${optionalString (settings.client.helper != null)
                  "helper.furl = ${settings.client.helper}"}

                shares.needed = ${toString settings.client.shares.needed}
                shares.happy = ${toString settings.client.shares.happy}
                shares.total = ${toString settings.client.shares.total}

                [storage]
                enabled = ${if settings.storage.enable then "true" else "false"}
                reserved_space = ${settings.storage.reservedSpace}

                [helper]
                enabled = ${if settings.helper.enable then "true" else "false"}
              '';
            });
          # Actually require Tahoe, so that we will have it installed.
          systemPackages = flip mapAttrsToList cfg.nodes (node: settings:
            settings.package
          );
        };
        # Open up the firewall.
        # networking.firewall.allowedTCPPorts = flip mapAttrsToList cfg.nodes
        #   (node: settings: settings.tub.port);
        systemd.services = flip mapAttrs' cfg.nodes (node: settings:
          let
            pidfile = "/run/tahoe.${node}.pid";
            # This is a directory, but it has no trailing slash. Tahoe commands
            # get antsy when there's a trailing slash.
            nodedir = "/var/db/tahoe-lafs/${node}";
          in nameValuePair "tahoe.${node}" {
            description = "Tahoe LAFS node ${node}";
            wantedBy = [ "multi-user.target" ];
            path = [ settings.package ];
            restartTriggers = [
              config.environment.etc."tahoe-lafs/${node}.cfg".source ];
            serviceConfig = {
              Type = "simple";
              PIDFile = pidfile;
            };
            preStart = ''
              if [ \! -d ${nodedir} ]; then
                mkdir -p /var/db/tahoe-lafs
                tahoe create-node ${nodedir}
              fi

              # Tahoe has created a predefined tahoe.cfg which we must now
              # scribble over.
              # XXX I thought that a symlink would work here, but it doesn't, so
              # we must do this on every prestart. Fixes welcome.
              # rm ${nodedir}/tahoe.cfg
              # ln -s /etc/tahoe-lafs/${node}.cfg ${nodedir}/tahoe.cfg
              cp /etc/tahoe-lafs/${node}.cfg ${nodedir}/tahoe.cfg
            '';
            # Believe it or not, Tahoe is very brittle about the order of
            # arguments to $(tahoe start). The node directory must come first,
            # and arguments which alter Twisted's behavior come afterwards.
            script = ''
              tahoe start ${nodedir} -n -l- --pidfile=${pidfile}
            '';
          });
        users.extraUsers = flip mapAttrs' cfg.nodes (node: _:
          nameValuePair "tahoe.${node}" {
            description = "Tahoe node user for node ${node}";
            isSystemUser = true;
          });
      })
    ];
  }
