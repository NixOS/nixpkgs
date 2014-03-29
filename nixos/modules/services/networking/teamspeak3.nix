{ config, pkgs, ... }:

with pkgs.lib;

let
  ts3 = pkgs.teamspeak_server;
  cfg = config.services.teamspeak3;
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

      user = mkOption {
        type = types.str;
        default = "teamspeak";
        description = "User account under which TeamSpeak 3 runs.";
      };

      group = mkOption {
        type = types.str;
        default = "teamspeak";
        description = "Group under which TeamSpeak 3 runs.";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers = optionalAttrs (cfg.user == "teamspeak") (singleton 
      { name = "teamspeak";
        description = "Teamspeak3 voice communication server daemon";
        group = "teamspeak";
        uid = config.ids.uids.teamspeak;
      });

    users.extraGroups = optionalAttrs (cfg.group == "teamspeak") (singleton 
      { name = "teamspeak";
        gid = config.ids.gids.teamspeak;
      });

    systemd.services.teamspeak3-server = { 
      description = "Teamspeak3 voice communication server daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        mkdir -p ${cfg.dataDir}
        mkdir -p ${cfg.logPath}
        chown ${cfg.user}:${cfg.group} ${cfg.dataDir}
        chown ${cfg.user}:${cfg.group} ${cfg.logPath}
      '';

      serviceConfig =
        { ExecStart = ''
            ${pkgs.su}/bin/su -s ${pkgs.stdenv.shell} ${cfg.user} -c '${ts3}/bin/ts3server \
              dbsqlpath=${ts3}/lib/teamspeak/sql/ logpath=${cfg.logPath} \
              voice_ip=${cfg.voiceIP} default_voice_port=${toString cfg.defaultVoicePort} \
              filetransfer_ip=${cfg.fileTransferIP} filetransfer_port=${toString cfg.fileTransferPort} \
              query_ip=${cfg.queryIP} query_port=${toString cfg.queryPort} \
            '
          '';
          WorkingDirectory = "${cfg.dataDir}";
        };
      };

  };

}
