{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.deemix;
in
{
  options = {
    services.deemix = {
      enable = lib.mkEnableOption "Deemix";

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/deemix/data";
        description = "The directory where Deemix stores its data files";
      };

      musicDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/deemix/downloads";
        description = "The directory where Deemix stores downloads";
      };

      package = lib.mkPackageOption pkgs "deemix" { };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Open ports in the firewall for Deemix
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "deemix";
        description = ''
          User account under which Deemix runs.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "deemix";
        description = ''
          Group under which Deemix runs.
        '';
      };

      listenPort = lib.mkOption {
        type = lib.types.port;
        default = 6595;
        description = ''
          Port under which Deemix runs.
        '';
      };

      listenHost = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0";
        description = ''
          Host which Deemix uses to run. Change to 127.0.0.1 if using a reverse proxy
        '';
      };
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0700 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.deemix = {
      description = "Deemix is a tool that facilitates downloading music from Deezer";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        DEEMIX_DATA_DIR = cfg.dataDir;
        DEEMIX_MUSIC_DIR = cfg.musicDir;
        DEEMIX_SERVER_PORT = toString cfg.listenPort;
        DEEMIX_SERVER_HOST = cfg.listenHost;
        NODE_ENV = "production";
      };
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = lib.getExe cfg.package;
        Restart = "on-failure";
        StateDirectory = "deemix";
        PrivateTmp = true;
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.listenPort ];
    };

    users.users = lib.mkIf (cfg.user == "deemix") {
      deemix = {
        group = cfg.group;
        home = cfg.dataDir;
        uid = config.ids.uids.deemix;
      };
    };

    users.groups = lib.mkIf (cfg.group == "deemix") {
      deemix = {
        gid = config.ids.gids.deemix;
      };
    };
  };
}
