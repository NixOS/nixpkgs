{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.tahoe;
in
  {
    options.services.tahoe = {
      introducers = mkOption {
        default = {};
        type = with types; attrsOf (submodule {
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
            settings = mkOption {
              type = types.attrs;
              default = {};
              description = ''
                Introducer configuration. Refer to
                <link xlink:href="https://tahoe-lafs.readthedocs.io/en/latest/configuration.html#running-an-introducer">
                the official documentation</link> for details on supported values.
              '';
            };
          };
        });
        description = ''
          The Tahoe introducers.
        '';
      };
      nodes = mkOption {
        default = {};
        type = with types; attrsOf (submodule {
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
            client.introducers = mkOption {
              default = {};
              type = with types; attrsOf (submodule {
                furl = mkOption {
                  type = types.str;
                  description = ''
                    The furl for a Tahoe introducer node.

                    Like all furls, keep this safe and don't share it.
                  '';
                };
              });
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
            sftpd.enable = mkEnableOption "SFTP service";
            sftpd.port = mkOption {
              default = null;
              type = types.nullOr types.int;
              description = ''
                The port on which the SFTP server will listen.

                This is the correct setting to tweak if you want Tahoe's SFTP
                daemon to listen on a different port.
              '';
            };
            sftpd.hostPublicKeyFile = mkOption {
              default = null;
              type = types.nullOr types.path;
              description = ''
                Path to the SSH host public key.
              '';
            };
            sftpd.hostPrivateKeyFile = mkOption {
              default = null;
              type = types.nullOr types.path;
              description = ''
                Path to the SSH host private key.
              '';
            };
            sftpd.accounts.file = mkOption {
              default = null;
              type = types.nullOr types.path;
              description = ''
                Path to the accounts file.
              '';
            };
            sftpd.accounts.url = mkOption {
              default = null;
              type = types.nullOr types.str;
              description = ''
                URL of the accounts server.
              '';
            };
            servers = mkOption {
              type = types.attrs;
              default = {};
              description = ''
                Contents of private/servers.yaml for each node.
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
            settings = mkOption {
              type = types.attrs;
              default = {};
              description = ''
                Node configuration, which generates a tahoe.cfg for
                each node's process. Refer to
                <link xlink:href="https://tahoe-lafs.readthedocs.io/en/latest/configuration.html#overall-node-configuration">
                the official documentation</link> for details on supported values.
              '';
            };
          };
        });
        description = ''
          The Tahoe nodes.
        '';
      };
    };
    config = mkMerge [
      (mkIf (cfg.introducers != {}) {
        environment = {
          etc = flip mapAttrs' cfg.introducers (node: val:
            nameValuePair "tahoe-lafs/introducer-${node}.cfg" {
              mode = "0444";
              text = generators.toINI {} (recursiveUpdate {
                node = {
                  inherit (val) nickname;
                  "tub.port" = val.tub.port;
                } // (optionalAttrs (val.tub.location != null) {
                  "tub.location" = val.tub.location;
                });
              } val.settings);
            });
          # Actually require Tahoe, so that we will have it installed.
          systemPackages = flip mapAttrsToList cfg.introducers (node: val:
            val.package
          );
        };
        # Open up the firewall.
        # networking.firewall.allowedTCPPorts = flip mapAttrsToList cfg.introducers
        #   (node: settings: settings.tub.port);
        systemd.services = flip mapAttrs' cfg.introducers (node: val:
          let
            pidfile = "/run/tahoe.introducer-${node}.pid";
            # This is a directory, but it has no trailing slash. Tahoe commands
            # get antsy when there's a trailing slash.
            nodedir = "/var/db/tahoe-lafs/introducer-${node}";
          in nameValuePair "tahoe.introducer-${node}" {
            description = "Tahoe LAFS node ${node}";
            wantedBy = [ "multi-user.target" ];
            path = [ val.package ];
            restartTriggers = [
              config.environment.etc."tahoe-lafs/introducer-${node}.cfg".source ];
            serviceConfig = {
              Type = "simple";
              PIDFile = pidfile;
              # Believe it or not, Tahoe is very brittle about the order of
              # arguments to $(tahoe run). The node directory must come first,
              # and arguments which alter Twisted's behavior come afterwards.
              ExecStart = ''
                ${val.package}/bin/tahoe run ${lib.escapeShellArg nodedir} --pidfile=${lib.escapeShellArg pidfile}
              '';
            };
            preStart = ''
              if [ ! -d ${lib.escapeShellArg nodedir} ]; then
                mkdir -p /var/db/tahoe-lafs
                # See https://github.com/NixOS/nixpkgs/issues/25273
                tahoe create-introducer \
                  --hostname="${config.networking.hostName}" \
                  ${lib.escapeShellArg nodedir}
              fi

              # Tahoe has created a predefined tahoe.cfg which we must now
              # scribble over.
              # XXX I thought that a symlink would work here, but it doesn't, so
              # we must do this on every prestart. Fixes welcome.
              # rm ${nodedir}/tahoe.cfg
              # ln -s /etc/tahoe-lafs/introducer-${node}.cfg ${nodedir}/tahoe.cfg
              cp /etc/tahoe-lafs/introducer-"${node}".cfg ${lib.escapeShellArg nodedir}/tahoe.cfg
            '';
          });
        users.users = flip mapAttrs' cfg.introducers (node: _:
          nameValuePair "tahoe.introducer-${node}" {
            description = "Tahoe node user for introducer ${node}";
            isSystemUser = true;
          });
      })
      (mkIf (cfg.nodes != {}) {
        environment = {
          etc = builtins.listToAttrs (builtins.concatLists (flip mapAttrsToList cfg.nodes (node: val: [
            (nameValuePair "tahoe-lafs/${node}.cfg" {
              mode = "0444";
              text = generators.toINI {} (recursiveUpdate {
                node = {
                  inherit (val) nickname;
                  "tub.port" = val.tub.port;
                  "web.port" = "tcp:${toString val.web.port}";
                } // (optionalAttrs (val.tub.location != null) {
                  "tub.location" = val.tub.location;
                });
                client = {
                  "shares.needed" = val.client.shares.needed;
                  "shares.happy" = val.client.shares.happy;
                  "shares.total" = val.client.shares.total;
                } // (optionalAttrs (val.client.helper != null) {
                  "helper.furl" = val.client.helper;
                });
                storage = {
                  enabled = val.storage.enable;
                  reserved_space = val.storage.reservedSpace;
                };
                helper = {
                  enabled = val.helper.enable;
                };
                sftpd = {
                  enabled = val.sftpd.enable;
                } // (optionalAttrs (val.sftpd.port != null) {
                  port = val.sftpd.port;
                }) // (optionalAttrs (val.sftpd.hostPublicKeyFile != null) {
                  host_pubkey_file = val.sftpd.hostPublicKeyFile;
                }) // (optionalAttrs (val.sftpd.hostPrivateKeyFile != null) {
                  host_privkey_file = val.sftpd.hostPrivateKeyFile;
                }) // (optionalAttrs (val.sftpd.accounts.file != null) {
                  "accounts.file" = val.sftpd.accounts.file;
                }) // (optionalAttrs (val.sftpd.accounts.url != null) {
                  "accounts.url" = val.sftpd.accounts.url;
                });
              } val.settings);
            })
            (nameValuePair "tahoe-lafs/introducers-for-${node}.yaml" {
              mode = "0444";
              text = generators.toYAML {} { inherit (val) introducers; };
            })
            (nameValuePair "tahoe-lafs/servers-for-${node}.yaml" {
              mode = "0444";
              text = generators.toYAML {} val.servers;
            })
          ]))); 
          # Actually require Tahoe, so that we will have it installed.
          systemPackages = flip mapAttrsToList cfg.nodes (node: val:
            val.package
          );
        };
        # Open up the firewall.
        # networking.firewall.allowedTCPPorts = flip mapAttrsToList cfg.nodes
        #   (node: val: val.tub.port);
        systemd.services = flip mapAttrs' cfg.nodes (node: val:
          let
            pidfile = "/run/tahoe.${node}.pid";
            # This is a directory, but it has no trailing slash. Tahoe commands
            # get antsy when there's a trailing slash.
            nodedir = "/var/db/tahoe-lafs/${node}";
          in nameValuePair "tahoe.${node}" {
            description = "Tahoe LAFS node ${node}";
            wantedBy = [ "multi-user.target" ];
            path = [ val.package ];
            restartTriggers = [
              config.environment.etc."tahoe-lafs/${node}.cfg".source ];
            serviceConfig = {
              Type = "simple";
              PIDFile = pidfile;
              # Believe it or not, Tahoe is very brittle about the order of
              # arguments to $(tahoe run). The node directory must come first,
              # and arguments which alter Twisted's behavior come afterwards.
              ExecStart = ''
                ${val.package}/bin/tahoe run ${lib.escapeShellArg nodedir} --pidfile=${lib.escapeShellArg pidfile}
              '';
            };
            preStart = ''
              if [ ! -d ${lib.escapeShellArg nodedir} ]; then
                mkdir -p /var/db/tahoe-lafs
                tahoe create-node --hostname=localhost ${lib.escapeShellArg nodedir}
              fi

              # Tahoe has created a predefined tahoe.cfg which we must now
              # scribble over.
              # XXX I thought that a symlink would work here, but it doesn't, so
              # we must do this on every prestart. Fixes welcome.
              # rm ${nodedir}/tahoe.cfg
              # ln -s /etc/tahoe-lafs/${lib.escapeShellArg node}.cfg ${nodedir}/tahoe.cfg
              cp /etc/tahoe-lafs/${lib.escapeShellArg node}.cfg ${lib.escapeShellArg nodedir}/tahoe.cfg
              mkdir -p ${lib.escapeShellArg nodedir}/private
              cp /etc/tahoe-lafs/introducers-for-${lib.escapeShellArg node}.yaml ${lib.escapeShellArg nodedir}/private/introducers.yaml
              cp /etc/tahoe-lafs/servers-for-${lib.escapeShellArg node}.yaml ${lib.escapeShellArg nodedir}/private/servers.yaml
            '';
          });
        users.users = flip mapAttrs' cfg.nodes (node: _:
          nameValuePair "tahoe.${node}" {
            description = "Tahoe node user for node ${node}";
            isSystemUser = true;
          });
      })
    ];
  }
