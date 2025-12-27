{
  config,
  lib,
  pkgs,
  ...
}:
with lib;

let
  cfg = config.services.tribler;
in
{
  options = {
    services.tribler = {
      enable = mkEnableOption "Tribler, a privacy enhanced BitTorrent client with P2P content discovery";

      package = mkPackageOption pkgs "tribler" { };

      port = mkOption {
        description = ''
          The TCP port Tribler WebUI/API will listen on.
          Default host is 127.0.0.1. Host can be configured in the
          <dataDir>/.Tribler/8.0/configuration.json file's
          api/http_host setting.
        '';
        default = 10099;
        type = types.port;
      };

      dataDir = mkOption {
        description = ''
          Tribler's internal data storage, must be an absolute path that
          already exists if set. The download location is set in the tribler web-gui's Settings.
        '';
        default = "/var/lib/tribler";
        example = "/home/myuser/.local/share/tribler";
        type = types.str;
      };

      apiKey = mkOption {
        description = ''
          API Key for API. If set, add '?key=<yourkeyhere>' to end of web-gui url.
          ex: http://localhost:10099/ui/#/downloads/all?key=<yourkeyhere>.'';
        default = "";
        type = types.str;
      };

      user = mkOption {
        description = "User account under which tribler runs.";
        default = "tribler";
        type = types.str;
      };

      group = mkOption {
        description = "Group under which tribler runs.";
        default = "tribler";
        type = types.str;
      };

      openFirewall = mkOption {
        description = "Open port in the firewall for the tribler web interface.";
        default = false;
        type = types.bool;
      };

    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.tribler = {
      description = "Tribler, a privacy enhanced BitTorrent client with P2P content discovery";

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        APPDATA = cfg.dataDir;
        CORE_API_PORT = "${toString cfg.port}";
        CORE_API_KEY = "${cfg.apiKey}";
      };

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = mkIf (cfg.dataDir == "/var/lib/tribler") "tribler";
        WorkingDirectory = cfg.dataDir;
        ReadWritePaths = cfg.dataDir;
        ExecStart = "${cfg.package}/bin/tribler -s";
        Restart = "on-failure";
      };
    };

    users.users = mkIf (cfg.user == "tribler") {
      tribler = {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.dataDir;
      };
    };

    users.groups = mkIf (cfg.group == "tribler") {
      tribler = { };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };

  meta.maintainers = with maintainers; [ JollyDevelopment ];
  meta.doc = ./tribler.md;
}
