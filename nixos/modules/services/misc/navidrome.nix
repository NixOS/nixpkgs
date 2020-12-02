{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.navidrome;
  configFile = "/etc/navidrome/settings.json";
  dataFolder = "/var/lib/navidrome";
in {
  options = {

    services.navidrome = {
      enable = mkEnableOption "Navidrome music server and streamer";

      settings = lib.mkOption {
        type = with types; attrsOf (oneOf [ int str ]);
        default = {};
        example = literalExample ''
          {
            LogLevel = "INFO";
            BaseURL = "/music";
            ScanInterval = "10s";
            TranscodingCacheSize = "15MB";
            MusicFolder = "/Media/Music";
          };
        '';
        description = ''
          Configuration for Navidrome, see <link xlink:href="https://www.navidrome.org/docs/usage/configuration-options/"/> for supported values.
      '';
      };

      user = mkOption {
        type = types.str;
        default = "navidrome";
        description = "User account under which Navidrome runs.";
      };

      group = mkOption {
        type = types.str;
        default = "navidrome";
        description = "Group account under which Navidrome runs.";
      };

    };
  };

  config = mkIf cfg.enable {

    environment.etc."navidrome/settings.json".text = builtins.toJSON cfg.settings;

    services.navidrome.settings = {
      DataFolder = dataFolder;
      ConfigFile = configFile;
    };
    
    systemd.services.navidrome = {
      description = "Navidrome Music Server and Streamer compatible with Subsonic/Airsonic";
      after = [ "remote-fs.target" "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        ND_CONFIGFILE = configFile;
      };
      serviceConfig = {
        ExecStart = "${pkgs.navidrome}/bin/navidrome";
        WorkingDirectory = dataFolder;
        TimeoutStopSec = "20";
        KillMode = "process";
        Restart = "on-failure";
        User = cfg.user;
        Group = cfg.group;
        DevicePolicy = "closed";
        NoNewPrivileges= " yes";
        PrivateTmp = "yes";
        PrivateUsers = "yes";
        ProtectControlGroups = "yes";
        ProtectKernelModules = "yes";
        ProtectKernelTunables = "yes";
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
        RestrictNamespaces = "yes";
        RestrictRealtime = "yes";
        SystemCallFilter = "~@clock @debug @module @mount @obsolete @privileged @reboot @setuid @swap";
        ReadWritePaths = dataFolder;
        StateDirectory = baseNameOf dataFolder;
      };
    };

    users.users = optionalAttrs (cfg.user == "navidrome") ({
      navidrome = {
        description = "Navidrome service user";
        name = cfg.user;
        group = cfg.group;
        isSystemUser = true;
      };
    });

    users.groups = optionalAttrs (cfg.group == "navidrome") ({
      navidrome = {};
    });
    
  };
}
