{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.tribler;
in
{
  options = with lib; {
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
        example = "/mnt/triblerdata";
        type = types.str;
      };

      apikeyFile = mkOption {
        description = ''
          A file outside of the nix store containing a single string to use as the API Key for API.
          If set, add '?key=<yourkeyhere>' to end of web-gui url.
          ex: http://localhost:10099/ui/#/downloads/all?key=<yourkeyhere>.'';
        default = null;
        type = types.nullOr types.path;
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

  config =
    with lib;
    mkIf cfg.enable {
      environment.systemPackages = [ cfg.package ];

      systemd.services.tribler = {
        description = "Tribler, a privacy enhanced BitTorrent client with P2P content discovery";

        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        environment = {
          APPDATA = cfg.dataDir;
          CORE_API_PORT = toString cfg.port;
          CORE_API_KEY = (if cfg.apikeyFile != null then lib.readFile cfg.apikeyFile else "");
        };

        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          StateDirectory = mkIf (lib.hasPrefix "/var/lib/" cfg.dataDir) "tribler";
          WorkingDirectory = cfg.dataDir;
          ReadWritePaths = cfg.dataDir;
          ExecStart = "${lib.getExe cfg.package} -s";
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

  meta.maintainers = with lib; [ maintainers.JollyDevelopment ];
  meta.doc = ./tribler.md;
}
