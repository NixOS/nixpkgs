{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.navidrome;
  configFile = "/etc/navidrome/settings.json";
  dataFolder = "/var/lib/navidrome";
in {
  options = {

    services.navidrome = {
      enable = mkEnableOption "Enable Navidrome music server and streamer";

      settings = lib.mkOption {
        type = types.attrs;
        default = {};
        example = {
          LogLevel = "INFO";
          BaseURL = "/music";
          ScanInterval = "10s";
          TranscodingCacheSize = "15MB";
          MusicFolder = "/Media/Music";
        };
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

      musicFolderPermissions = mkOption {
        type = types.str;
        default = "775";
        description = ''
        The permissions to set for the music folder.
        They will be applied on every service start.
        '';
      };

    };
  };

  config = mkIf cfg.enable {

    systemd.tmpfiles.rules = [
      "d '${cfg.settings.MusicFolder}' '${cfg.musicFolderPermissions}' '${cfg.user}' '${cfg.group}' - -"
    ];

    environment.etc."navidrome/settings.json".text = builtins.toJSON (cfg.settings // {
      # These settings are always overwritten by NixOS i.e. they are not settable
      DataFolder = dataFolder;
      ConfigFile = configFile;
    } // (if (attrsets.hasAttrByPath ["Port"] cfg.settings)
          then {Port = builtins.toString cfg.settings.Port;}
          else {})); 
    
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
      };
    };

    users.users = optionalAttrs (cfg.user == "navidrome") ({
      navidrome = {
        description = "Navidrome service user";
        name = cfg.user;
        group = cfg.group;
        home = dataFolder;
        createHome = true;
        isSystemUser = true;
      };
    });

    users.groups = optionalAttrs (cfg.group == "navidrome") ({
      navidrome = {
        name = "navidrome";
      };
    });
    
  };
}
