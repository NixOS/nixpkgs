{ config, pkgs, lib, utils, ... }:

with lib;

let
  cfg = config.services.jackett;

  settingsFormat = pkgs.formats.json {};
in
{
  options = {
    services.jackett = {
      enable = mkEnableOption "Jackett, API support for your favorite torrent trackers";

      port = mkOption {
        default = 9117;
        type = types.port;
        description = ''
          Port serving the web interface
        '';
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/jackett/.config/Jackett";
        description = "The directory where Jackett stores its data files.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Open ports in the firewall for the Jackett web interface.";
      };

      user = mkOption {
        type = types.str;
        default = "jackett";
        description = "User account under which Jackett runs.";
      };

      group = mkOption {
        type = types.str;
        default = "jackett";
        description = "Group under which Jackett runs.";
      };

      package = mkPackageOption pkgs "jackett" { };

      settings = mkOption {
        description = "Settings for Jackett";
        default = {};
        type = types.submodule {
          freeformType = settingsFormat.type;
          options = {
            APIKey = mkOption {
              type = types.outOfBand;
              description = "Secret API Key.";
            };
            FlareSolverrUrl = mkOption {
              type = types.nullOr lib.types.str;
              description = "FlareSolverr endpoint.";
              default = null;
            };
            OmdbApiKey = mkOption {
              type = types.nullOr types.outOfBand;
              description = "Open Movie Database API Key.";
              default = null;
            };
            ProxyType = mkOption {
              type = types.enum [ "-1" "0" "1" "2" ];
              default = "-1";
              description = ''
                -1 = disabled
                0 = HTTP
                1 = SOCKS4
                2 = SOCKS5
                '';
            };
            ProxyUrl = mkOption {
              type = types.nullOr lib.types.str;
              description = "URL of the proxy. Ignored if ProxyType is set to -1";
              default = null;
            };
            ProxyPort = mkOption {
              type = types.nullOr lib.types.port;
              description = "Port of the proxy. Ignored if ProxyType is set to -1";
              default = null;
            };
            AllowExternal = mkOption {
              type = types.bool;
              description = "Allow external unprotected connection. Enable this if behind a reverse proxy that provides authentication.";
              default = false;
            };
            UpdateDisabled = mkOption {
              type = types.bool;
              description = "Disable updates. Updates are done through NixOS so enabling them serves no purpose.";
              default = true;
            };
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0700 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.jackett = {
      description = "Jackett";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/Jackett --NoUpdates --DataFolder '${cfg.dataDir}'";
        Restart = "on-failure";
      };

      preStart = utils.genConfigOutOfBand {
        config = cfg.settings // {
          Port = cfg.port;
        };
        configLocation = "${cfg.dataDir}/ServerConfig.json";
        generator = utils.genConfigOutOfBandFormatAdapter settingsFormat;
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    users.users = mkIf (cfg.user == "jackett") {
      jackett = {
        group = cfg.group;
        home = cfg.dataDir;
        uid = config.ids.uids.jackett;
      };
    };

    users.groups = mkIf (cfg.group == "jackett") {
      jackett.gid = config.ids.gids.jackett;
    };
  };
}
