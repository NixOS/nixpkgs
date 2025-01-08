{ config, lib, pkgs, ... }:

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
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to run the Teamspeak3 voice communication server daemon.
        '';
      };

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/teamspeak3-server";
        description = ''
          Directory to store TS3 database and other state/data files.
        '';
      };

      logPath = lib.mkOption {
        type = lib.types.path;
        default = "/var/log/teamspeak3-server/";
        description = ''
          Directory to store log files in.
        '';
      };

      voiceIP = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "[::]";
        description = ''
          IP on which the server instance will listen for incoming voice connections. Defaults to any IP.
        '';
      };

      defaultVoicePort = lib.mkOption {
        type = lib.types.port;
        default = 9987;
        description = ''
          Default UDP port for clients to connect to virtual servers - used for first virtual server, subsequent ones will open on incrementing port numbers by default.
        '';
      };

      fileTransferIP = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "[::]";
        description = ''
          IP on which the server instance will listen for incoming file transfer connections. Defaults to any IP.
        '';
      };

      fileTransferPort = lib.mkOption {
        type = lib.types.port;
        default = 30033;
        description = ''
          TCP port opened for file transfers.
        '';
      };

      queryIP = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "0.0.0.0";
        description = ''
          IP on which the server instance will listen for incoming ServerQuery connections. Defaults to any IP.
        '';
      };

      queryPort = lib.mkOption {
        type = lib.types.port;
        default = 10011;
        description = ''
          TCP port opened for ServerQuery connections using the raw telnet protocol.
        '';
      };

      querySshPort = lib.mkOption {
        type = lib.types.port;
        default = 10022;
        description = ''
          TCP port opened for ServerQuery connections using the SSH protocol.
        '';
      };

      queryHttpPort = lib.mkOption {
        type = lib.types.port;
        default = 10080;
        description = ''
          TCP port opened for ServerQuery connections using the HTTP protocol.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open ports in the firewall for the TeamSpeak3 server.";
      };

      openFirewallServerQuery = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open ports in the firewall for the TeamSpeak3 serverquery (administration) system. Requires openFirewall.";
      };

    };

  };


  ###### implementation

  config = lib.mkIf cfg.enable {
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

    systemd.tmpfiles.rules = [
      "d '${cfg.logPath}' - ${user} ${group} - -"
    ];

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.fileTransferPort ] ++ (map (port:
        lib.mkIf cfg.openFirewallServerQuery port
      ) [cfg.queryPort cfg.querySshPort cfg.queryHttpPort]);
      # subsequent vServers will use the incremented voice port, let's just open the next 10
      allowedUDPPortRanges = [ { from = cfg.defaultVoicePort; to = cfg.defaultVoicePort + 10; } ];
    };

    systemd.services.teamspeak3-server = {
      description = "Teamspeak3 voice communication server daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = ''
          ${ts3}/bin/ts3server \
            dbsqlpath=${ts3}/lib/teamspeak/sql/ \
            logpath=${cfg.logPath} \
            license_accepted=1 \
            default_voice_port=${toString cfg.defaultVoicePort} \
            filetransfer_port=${toString cfg.fileTransferPort} \
            query_port=${toString cfg.queryPort} \
            query_ssh_port=${toString cfg.querySshPort} \
            query_http_port=${toString cfg.queryHttpPort} \
            ${lib.optionalString (cfg.voiceIP != null) "voice_ip=${cfg.voiceIP}"} \
            ${lib.optionalString (cfg.fileTransferIP != null) "filetransfer_ip=${cfg.fileTransferIP}"} \
            ${lib.optionalString (cfg.queryIP != null) "query_ip=${cfg.queryIP}"} \
            ${lib.optionalString (cfg.queryIP != null) "query_ssh_ip=${cfg.queryIP}"} \
            ${lib.optionalString (cfg.queryIP != null) "query_http_ip=${cfg.queryIP}"} \
        '';
        WorkingDirectory = cfg.dataDir;
        User = user;
        Group = group;
        Restart = "on-failure";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ arobyn ];
}
