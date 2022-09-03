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
        description = lib.mdDoc ''
          Whether to run the Teamspeak3 voice communication server daemon.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/teamspeak3-server";
        description = lib.mdDoc ''
          Directory to store TS3 database and other state/data files.
        '';
      };

      logPath = mkOption {
        type = types.path;
        default = "/var/log/teamspeak3-server/";
        description = lib.mdDoc ''
          Directory to store log files in.
        '';
      };

      voiceIP = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "[::]";
        description = lib.mdDoc ''
          IP on which the server instance will listen for incoming voice connections. Defaults to any IP.
        '';
      };

      defaultVoicePort = mkOption {
        type = types.int;
        default = 9987;
        description = lib.mdDoc ''
          Default UDP port for clients to connect to virtual servers - used for first virtual server, subsequent ones will open on incrementing port numbers by default.
        '';
      };

      fileTransferIP = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "[::]";
        description = lib.mdDoc ''
          IP on which the server instance will listen for incoming file transfer connections. Defaults to any IP.
        '';
      };

      fileTransferPort = mkOption {
        type = types.int;
        default = 30033;
        description = lib.mdDoc ''
          TCP port opened for file transfers.
        '';
      };

      queryIP = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "0.0.0.0";
        description = lib.mdDoc ''
          IP on which the server instance will listen for incoming ServerQuery connections. Defaults to any IP.
        '';
      };

      queryPort = mkOption {
        type = types.int;
        default = 10011;
        description = lib.mdDoc ''
          TCP port opened for ServerQuery connections.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Open ports in the firewall for the TeamSpeak3 server.";
      };

      openFirewallServerQuery = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Open ports in the firewall for the TeamSpeak3 serverquery (administration) system. Requires openFirewall.";
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

    systemd.tmpfiles.rules = [
      "d '${cfg.logPath}' - ${user} ${group} - -"
    ];

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.fileTransferPort ] ++ optionals (cfg.openFirewallServerQuery) [ cfg.queryPort (cfg.queryPort + 11) ];
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
            dbsqlpath=${ts3}/lib/teamspeak/sql/ logpath=${cfg.logPath} \
            ${optionalString (cfg.voiceIP != null) "voice_ip=${cfg.voiceIP}"} \
            default_voice_port=${toString cfg.defaultVoicePort} \
            ${optionalString (cfg.fileTransferIP != null) "filetransfer_ip=${cfg.fileTransferIP}"} \
            filetransfer_port=${toString cfg.fileTransferPort} \
            ${optionalString (cfg.queryIP != null) "query_ip=${cfg.queryIP}"} \
            query_port=${toString cfg.queryPort} license_accepted=1
        '';
        WorkingDirectory = cfg.dataDir;
        User = user;
        Group = group;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ arobyn ];
}
