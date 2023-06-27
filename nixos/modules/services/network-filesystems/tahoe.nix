{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.tahoe;
  format = pkgs.formats.ini { };
in
  {
    options.services.tahoe = {
      introducers = mkOption {
        default = {};
        type = with types; attrsOf (submodule {
          options = {
            settings = mkOption {
              type = types.submodule {
                freeformType = format.type;
                options = {
                  node.nickname = mkOption {
                    type = types.str;
                    description = "The nickname of this Tahoe introducer.";
                  };
                  node."tub.port" = mkOption {
                    default = 3458;
                    type = types.port;
                    description = "The port on which the introducer will listen.";
                  };
                  node."tub.location" = mkOption {
                    type = types.nullOr types.str;
                    description = ''
                      The external location that the introducer should listen on.
                      If specified, the port should be included.
                    '';
                  };
                };
              };
              description = "Freeform settings for the introducer";
            };
            package = mkOption {
              default = pkgs.tahoe-lafs;
              defaultText = literalExpression "pkgs.tahoe-lafs";
              type = types.package;
              description = "The package to use for the Tahoe LAFS daemon.";
            };
          };
        });
        description = lib.mdDoc "The Tahoe introducers.";
      };
      nodes = mkOption {
        default = {};
        type = with types; attrsOf (submodule ({name, config, ...}: {
          options = {
            settings = mkOption {
              type = types.submodule {
                freeformType = format.type;
                options = {
                  node.nickname = mkOption {
                    type = types.str;
                    description = "Value to display in management tools.";
                    default = name;
                  };
                  node."tub.port" = mkOption {
                    type = types.oneOf [ types.str types.port (types.enum [ "disabled" null ]) ];
                    description = "A twisted server endpoint specification for receiving connections from other nodes.";
                    example = "tcp:12345:interface=127.0.0.1";
                    default = 3457;
                  };
                  node."tub.location" = mkOption {
                    type = types.either types.str (types.enum [ "disabled" null ]);
                    description = "comma separated connection strings that can be reached publically.";
                    example = "tcp:mynode.example.com:3457,AUTO";
                    default = "AUTO";
                  };
                  node."web.port" = mkOption {
                    type = types.nullOr (types.either types.str types.port);
                    description = "Twisted strport specification for webui and REST-api.";
                    example = "tcp:3456:interface=127.0.0.1";
                    default = 3456;
                  };
                  client."shares.needed" = mkOption {
                    type = types.ints.between 1 256;
                    description = "Default amount of shares needed to reconstruct an uploaded file.";
                    default = 3;
                  };
                  client."shares.total" = mkOption {
                    type = types.ints.between 1 256;
                    description = "Default amount of shares a file is split into.";
                    default = 10;
                  };
                  client."shares.happy" = mkOption {
                    type = types.ints.positive;
                    description = ''
                      How spread out should your shares be.
                      Can be smaller than needed, but not more than amount of servers available.";
                    '';
                    default = 7;
                  };
                  client."mutable.format" = mkOption {
                    type = types.enum [ "sdmf" "mdmf" ];
                    description = ''
                      What format to save mutable files in.
                      SDMF is useful when some nodes on your network run an older version of Tahoe-LAFS.
                      MDMF supports inplace modification and streaming downloads.
                    '';
                    default = "sdmf";
                  };
                  storage.enabled = mkEnableOption "storage service";
                  storage.anonymous = mkOption {
                    type = types.bool;
                    description = "Whether to expose storage with just the FURL and no other authentication.";
                    default = true;
                  };
                  storage.reserved_space = mkOption {
                    type = types.str;
                    description = "The minimum amount of free disk space to keep.";
                    default = "1G";
                  };
                  helper.enabled = mkEnableOption "helper service";
                  sftpd.enabled = mkEnableOption "sftpd service";
                  sftpd.port = mkOption {
                    type = types.nullOr types.str;
                    description = "A twisted connection string to listen on for the sftpd service.";
                    example = "tcp:8022:interface=127.0.0.1";
                    default = null;
                  };
                  sftpd.host_pubkey_file = mkOption {
                    type = types.nullOr types.path;
                    description = "Path to ssh public key to use for the service.";
                    default = null;
                  };
                  sftpd.host_privkey_file = mkOption {
                    type = types.nullOr types.path;
                    description = "Path to ssh private key to use for the service.";
                    default = null;
                  };
                };
              };
              description = "freeform options for a normal tahoe-lafs node";
            };
            client.introducersFile = mkOption {
              type = types.nullOr types.path;
              description = "Path to a secret file containing introducers, will be placed in private/introducers.yaml";
              default = null;
            };
            client.helperFile = mkOption {
              type = types.nullOr types.path;
              description = "Secret file containing a furl to use as a helper.";
              default = null;
            };
            sftpd.accountsFile = mkOption {
              type = types.nullOr types.path;
              description = "Path to the accounts file. Will be copied to private/accounts";
              default = null;
            };
            package = mkOption {
              default = pkgs.tahoe-lafs;
              defaultText = literalExpression "pkgs.tahoelafs";
              type = types.package;
              description = lib.mdDoc ''
                The package to use for the Tahoe LAFS daemon.
              '';
            };
          };
        }));
        description = "The Tahoe nodes.";
      };
    };
    config = mkMerge [
      (mkIf (cfg.introducers != {}) {
        environment = {
          etc = flip mapAttrs' cfg.introducers (node: settings:
            nameValuePair "tahoe-lafs/introducer-${node}.cfg" {
              mode = "0444";
              source = format.generate "tahoe-lafs-introducer" settings.settings;
            });
          # Actually require Tahoe, so that we will have it installed.
          systemPackages = flip mapAttrsToList cfg.introducers (node: settings:
            settings.package
          );
        };
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
              # Believe it or not, Tahoe is very brittle about the order of
              # arguments to $(tahoe run). The node directory must come first,
              # and arguments which alter Twisted's behavior come afterwards.
              ExecStart = ''
                ${settings.package}/bin/tahoe run ${lib.escapeShellArg nodedir} --pidfile=${lib.escapeShellArg pidfile}
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
            group = "tahoe.introducer-${node}";
          });
        users.groups = flip mapAttrs' cfg.nodes (node: _:
          nameValuePair "tahoe.introducer-${node}" { });
      })
      (mkIf (cfg.nodes != {}) {
        environment = {
          etc = flip mapAttrs' cfg.nodes (node: settings:
            nameValuePair "tahoe-lafs/${node}.cfg" {
              mode = "0444";
              source = let placeholderFile = lib.pipe settings.settings [
                (s: lib.recursiveUpdate
                  (lib.optionalAttrs (settings.client.helperFile != null) { client."helper.furl" = "@CLIENT_HELPER_FURL@"; })
                  s)
              ];
              in format.generate "tahoe-lafs-node" placeholderFile;
            });
          # Actually require Tahoe, so that we will have it installed.
#          systemPackages = flip mapAttrsToList cfg.nodes (node: settings:
#            settings.package
#          );
        };
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
              # Believe it or not, Tahoe is very brittle about the order of
              # arguments to $(tahoe run). The node directory must come first,
              # and arguments which alter Twisted's behavior come afterwards.
              ExecStart = ''
                ${settings.package}/bin/tahoe run ${lib.escapeShellArg nodedir} --pidfile=${lib.escapeShellArg pidfile}
              '';
            };
            preStart = ''
              if [ ! -d ${lib.escapeShellArg nodedir} ]; then
                mkdir -p /var/db/tahoe-lafs
                tahoe create-node --hostname=localhost ${lib.escapeShellArg nodedir}
              fi

              cp /etc/tahoe-lafs/${lib.escapeShellArg node}.cfg ${lib.escapeShellArg nodedir}/tahoe.cfg
            '' + lib.optionalString (settings.client.helperFile != null) ''
              ${pkgs.replace-secret}/bin/replace-secret '@CLIENT_HELPER_FURL@' ${settings.client.helperFile} ${lib.escapeShellArg nodedir}/tahoe.cfg
            '' + lib.optionalString (settings.client.introducersFile != null) ''
              cp "${config.settings.client.introducersFile}" ${lib.escapeShellArg nodedir}/private/introducers.yaml
            '' + lib.optionalString (settings.sftpd.accountsFile != null) ''
              cp "${config.settings.client.introducersFile}" ${lib.escapeShellArg nodedir}/private/accounts
            '';
          });
        users.users = flip mapAttrs' cfg.nodes (node: _:
          nameValuePair "tahoe.${node}" {
            description = "Tahoe node user for node ${node}";
            isSystemUser = true;
            group = "tahoe.${node}";
          });
        users.groups = flip mapAttrs' cfg.nodes (node: _:
          nameValuePair "tahoe.${node}" { });
      })
    ];
  }
