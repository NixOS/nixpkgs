{ config, lib, pkgs, ... }:

with lib;

let
  ts3 = pkgs.teamspeak_server;
  cfg = config.services.teamspeak3;
  user = "teamspeak";
  group = "teamspeak";
in

{

  ###### interface

  options = {

    services.teamspeak3 = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to run the Teamspeak3 voice communication server daemon.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/teamspeak3-server";
        description = ''
          Directory to store TS3 database and other state/data files.
        '';
      };

      logPath = mkOption {
        type = types.path;
        default = "/var/log/teamspeak3-server/";
        description = ''
          Directory to store log files in.
        '';
      };

      voiceIP = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = ''
          IP on which the server instance will listen for incoming voice connections. Defaults to any IP.
        '';
      };

      defaultVoicePort = mkOption {
        type = types.int;
        default = 9987;
        description = ''
          Default UDP port for clients to connect to virtual servers - used for first virtual server, subsequent ones will open on incrementing port numbers by default.
        '';
      };

      fileTransferIP = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = ''
          IP on which the server instance will listen for incoming file transfer connections. Defaults to any IP.
        '';
      };

      fileTransferPort = mkOption {
        type = types.int;
        default = 30033;
        description = ''
          TCP port opened for file transfers.
        '';
      };

      queryIP = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = ''
          IP on which the server instance will listen for incoming ServerQuery connections. Defaults to any IP.
        '';
      };

      queryPort = mkOption {
        type = types.int;
        default = 10011;
        description = ''
          TCP port opened for ServerQuery connections.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {
    users.users.teamspeak = {
      description = "Teamspeak3 voice communication server daemon";
      group = group;
      uid = config.ids.uids.teamspeak;
      home = cfg.dataDir;
      createHome = true;
    };

    users.groups.teamspeak = {
      gid = config.ids.gids.teamspeak;
    };

    systemd.services.teamspeak3-server = {
      description = "Teamspeak3 voice communication server daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        mkdir -p ${cfg.logPath}
        chown ${user}:${group} ${cfg.logPath}
      '';

      serviceConfig = {
        ExecStart = ''
          ${ts3}/bin/ts3server \
            dbsqlpath=${ts3}/lib/teamspeak/sql/ logpath=${cfg.logPath} \
            voice_ip=${cfg.voiceIP} default_voice_port=${toString cfg.defaultVoicePort} \
            filetransfer_ip=${cfg.fileTransferIP} filetransfer_port=${toString cfg.fileTransferPort} \
            query_ip=${cfg.queryIP} query_port=${toString cfg.queryPort}
        '';
        WorkingDirectory = cfg.dataDir;
        User = user;
        Group = group;
        PermissionsStartOnly = true;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ arobyn ];
}
