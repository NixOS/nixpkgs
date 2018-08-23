{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.lizardfs;

  # default ports
  cgiservPort = 9425;
  masterMetaloggerPort = 9419;
  masterChunkserverPort = 9420;

  masterGoals = pkgs.writeText "mfsgoals.cfg" cfg.master.goals;
  masterExports = pkgs.writeText "mfsexports.cfg" cfg.master.exports;

  masterConfig = pkgs.writeText "mfsmaster.cfg" ''
    DATA_PATH = /var/lib/mfs
    CUSTOM_GOALS_FILENAME = ${masterGoals}
    EXPORTS_FILENAME = ${masterExports}
    ${cfg.master.config}
  '';

  metaloggerConfig = pkgs.writeText "mfsmetalogger.cfg" ''
    MASTER_HOST = ${cfg.metalogger.masterHost}
    MASTER_PORT = ${toString cfg.metalogger.masterPort}
    DATA_PATH = /var/lib/mfs
    ${cfg.metalogger.config}
  '';

  createChunkserverHdds = serv:
    nameValuePair serv.name (pkgs.writeText "mfshdd-${serv.name}.cfg" ''
      ${concatStringsSep "\n" serv.storageDirectories}
    '');

  chunkserverHdds = listToAttrs (map createChunkserverHdds cfg.chunkservers.servers);

  createChunkserverConfig = serv:
    nameValuePair serv.name (pkgs.writeText "mfschunkserver-${serv.name}.cfg" ''
        MASTER_HOST = ${cfg.chunkservers.masterHost}
        MASTER_PORT = ${toString cfg.chunkservers.masterPort}
        HDD_CONF_FILENAME = ${chunkserverHdds."${serv.name}"}
        CSSERV_LISTEN_PORT = ${toString serv.port}
        DATA_PATH = /var/lib/mfs-${serv.name}
        ${serv.config}
      '');

  chunkserverConfigs = listToAttrs (map createChunkserverConfig cfg.chunkservers.servers);
in
{
  options = {
    services.lizardfs = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = ''
          LizardFS configuration.
        '';
      };
      cgiserv = {
        enable = mkOption {
          default = false;
          type = with types; bool;
          description = ''
            Start LizardFS cgi server daemon.
          '';
        };
        host = mkOption {
          default = "0.0.0.0";
          type = with types; str;
          description = ''
            Hostname/IP to bind to.
          '';
        };
        port = mkOption {
          default = cgiservPort;
          type = with types; int;
          description = ''
            CGI server port.
          '';
        };
      };
      master = {
        enable = mkOption {
          default = false;
          type = with types; bool;
          description = ''
            Start LizardFS master service.
          '';
        };
        config = mkOption {
          default = "";
          type = with types; str;
          description = ''
            LizardFS master config. See mfsmaster.cfg(5) for details.
          '';
        };
        exports = mkOption {
          default = null;
          type = with types; str;
          description = ''
            LizardFS master exports.
          '';
        };
        goals = mkOption {
          default = "";
          type = with types; str;
          description = ''
            LizardFS master goals.
          '';
        };
      };
      metalogger = {
        enable = mkOption {
          default = false;
          type = with types; bool;
          description = ''
            Start LizardFS metadata logger service.
          '';
        };
        config = mkOption {
          default = "";
          type = types.str;
          description = "Text to be put in mfsmetalogger.cfg. See mfsmetalogger.cfg(5) for details.";
        };
        masterHost = mkOption {
          default = null;
          type = with types; string;
          description = ''
            Master host for metalogger to connect to.
          '';
        };
        masterPort = mkOption {
          default = masterMetaloggerPort;
          type = with types; int;
          description = ''
            Master port for metalogger to connect to.
          '';
        };
      };
      chunkservers = {
        servers = mkOption {
          default = [];
          type = types.listOf (types.submodule {
            options = {
              name = mkOption {
                default = null;
                type = types.str;
                description = "Chunkserver name for systemd.";
              };
              port = mkOption {
                default = 9422;
                type = types.int;
                description = "Port to listen on.";
              };
              storageDirectories = mkOption {
                default = null;
                type = types.listOf types.str;
                description = "List of LizardFS storage directories.";
              };
              config = mkOption {
                default = "";
                type = types.str;
                description = "Text to be put in mfschunkserver.cfg. See mfschunkserver.cfg(5) for details.";
              };
            };
          });
          description = ''
            List of LizardFS chunkservers to run on this node.
          '';
        };
        masterHost = mkOption {
          default = null;
          type = with types; string;
          description = ''
            Master host for chunkservers to connect to.
          '';
        };
        masterPort = mkOption {
          default = masterChunkserverPort;
          type = with types; int;
          description = ''
            Master port for chunkservers to connect to.
          '';
        };
      };
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.lizardfs ]; # admin tools

    users.users.mfs = {
      group = "mfs";
      description = "LizardFS daemon user";
      uid = config.ids.uids.mfs;
    };

    users.groups.mfs.gid = config.ids.gids.mfs;

    systemd.tmpfiles.rules = [ "d /var/lib/mfs 0770 mfs mfs -" ] ++
      (map (serv: "d /var/lib/mfs-${serv.name} 0770 mfs mfs -") cfg.chunkservers.servers);

    systemd.services =
      let
        createChunkserverService = serv:
          nameValuePair "lizardfs-chunkserver-${serv.name}" {
            description = "LizardFS Chunkserver for ${serv.name}";
            documentation = [ "man:mfschunkserver" ];
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            restartIfChanged = false;
            serviceConfig = {
              Type = "forking";
              ExecStart = ''${pkgs.lizardfs}/bin/mfschunkserver  -c ${chunkserverConfigs."${serv.name}"} start'';
              ExecStop = ''${pkgs.lizardfs}/bin/mfschunkserver  -c ${chunkserverConfigs."${serv.name}"} stop'';
              ExecReload = ''${pkgs.lizardfs}/bin/mfschunkserver  -c ${chunkserverConfigs."${serv.name}"} reload'';
              Restart = "on-abort";
            };
          };
        in listToAttrs (
          (map createChunkserverService cfg.chunkservers.servers)
          ++ optional cfg.cgiserv.enable (nameValuePair "lizardfs-cgiserv" {
            wantedBy = [ "multi-user.target" ];
            after = [ "network.target" ];
            description = "LizardFS CGI server daemon";
            documentation = [ "man:lizardfs-cgiserver" ];
            restartIfChanged = false;
            serviceConfig = {
              ExecStart = "${pkgs.lizardfs}/bin/lizardfs-cgiserver -H ${cfg.cgiserv.host} -P ${toString cfg.cgiserv.port}";
              Restart = "on-abort";
              User = "nobody";
            };
          })
          ++ optional cfg.master.enable (nameValuePair "lizardfs-master" {
            wantedBy = [ "multi-user.target" ];
            after = [ "network.target" ];
            description = "LizardFS master server daemon";
            documentation = [ "man:mfsmaster" ];
            restartIfChanged = false;
            serviceConfig = {
              Type = "forking";
              TimeoutSec = 0;
              ExecStart = ''${pkgs.lizardfs}/bin/mfsmaster -c ${masterConfig} start'';
              ExecStop = ''${pkgs.lizardfs}/bin/mfsmaster -c ${masterConfig} stop'';
              ExecReload = ''${pkgs.lizardfs}/bin/mfsmaster -c ${masterConfig} reload'';
              Restart = "no";
            };
          })
          ++ optional cfg.metalogger.enable (nameValuePair "lizardfs-metalogger" {
            wantedBy = [ "multi-user.target" ];
            after = [ "network.target" ];
            description = "LizardFS metalogger server daemon";
            documentation = [ "man:mfsmetalogger" ];
            restartIfChanged = false;
            serviceConfig = {
              Type = "forking";
              ExecStart = ''${pkgs.lizardfs}/bin/mfsmetalogger -c ${metaloggerConfig} start'';
              ExecStop = ''${pkgs.lizardfs}/bin/mfsmetalogger -c ${metaloggerConfig} stop'';
              ExecReload = ''${pkgs.lizardfs}/bin/mfsmetalogger -c ${metaloggerConfig} reload'';
              Restart = "on-abort";
            };
          }));
  };
}
