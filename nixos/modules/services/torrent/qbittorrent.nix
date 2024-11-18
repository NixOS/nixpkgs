{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.services.qbittorrent-nox;
  settingsFormat = pkgs.formats.ini { };

  confirmLegalNoticeString = if cfg.confirmLegalNotice then "--confirm-legal-notice" else "";

in
{
  options = {
    services.qbittorrent-nox = {
      enable = lib.mkEnableOption "Enable qBittorrent-nox service";

      settings = lib.mkOption {
        type = lib.types.submodule { freeformType = settingsFormat.type; };
        default = { };
        description = lib.mdDoc ''
          qBittorrent settings. These will be merged with the default settings.
          Settings defined here will override the defaults.
          Se https://github.com/qbittorrent/qBittorrent/wiki/Explanation-of-Options-in-qBittorrent
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8080;
        description = "Port for the web UI.";
      };

      torrentPort = lib.mkOption {
        type = lib.types.port;
        default = 6881;
        description = "Port for torrenting.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "qbittorrent";
        description = "User to run the service.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "qbittorrent";
        description = "Group to run the service.";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.qbittorrent-nox;
        description = "Package to use for the service.";
      };

      stateDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/qbittorrent";
        description = "Directory for qBittorrent-nox data.";
      };

      confirmLegalNotice = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          qBittorrent is a file sharing program. When you run a torrent, its data will be made available to others by means of upload. Any content you share is your sole responsibility.

          If you confirm the legal notice you can enable this option.
        '';
      };

    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.qbittorrent-nox = {
      description = "qBittorrent-nox Service";
      wants = [ "network-online.target" ];
      after = [
        "network.target"
        "network-online.target"
        "nss-lookup.target"
      ];
      wantedBy = [ "multi-user.target" ];
      path = [
        cfg.package
        cfg.stateDir
      ];

      preStart = ''
        # Ensure proper permissions on directories
        mkdir -p ${cfg.stateDir}
        chown ${cfg.user}:${cfg.group} ${cfg.stateDir}

        # Create config directory if it doesn't exist
        mkdir -p ${cfg.stateDir}/qBittorrent/config
        chown ${cfg.user}:${cfg.group} ${cfg.stateDir}/qBittorrent
        chown ${cfg.user}:${cfg.group} ${cfg.stateDir}/qBittorrent/config

        # Generate config file if settings are provided
        ${lib.optionalString (cfg.settings != { }) ''
          cp ${settingsFormat.generate "qBittorrent.conf" cfg.settings} ${cfg.stateDir}/qBittorrent/config/qBittorrent.conf
          chown ${cfg.user}:${cfg.group} ${cfg.stateDir}/qBittorrent/config/qBittorrent.conf
          chmod 600 ${cfg.stateDir}/qBittorrent/config/qBittorrent.conf
        ''}
      '';

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.stateDir;
        Restart = "always";
        RuntimeDirectory = "qbittorrent";
        RuntimeDirectoryMode = "0755";
        StateDirectory = "qbittorrent";
        StateDirectoryMode = "0755";
        ReadWritePaths = [ cfg.stateDir ];
        ExecStart = "${cfg.package}/bin/qbittorrent-nox --profile=${cfg.stateDir} --webui-port=${builtins.toString cfg.port} --torrenting-port=${builtins.toString cfg.torrentPort} ${confirmLegalNoticeString}";
      };

    };

    users.users = lib.mkIf (cfg.user == "qbittorrent") {
      qbittorrent = {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.stateDir;
        useDefaultShell = true;
        createHome = true;
      };
    };

    users.groups = lib.mkIf (cfg.group == "qbittorrent") { qbittorrent = { }; };

  };
}
