{ config, lib, pkgs, ... }:

let
  cfg = config.services.zeronet;

  zConfFile = pkgs.writeTextFile {
    name = "zeronet.conf";
    
    text = ''
      [global]
      data_dir = ${cfg.dataDir}
      log_dir = ${cfg.logDir}
    '' + lib.optionalString (cfg.port != null) ''
      ui_port = ${toString cfg.port}
    '' + lib.optionalString (cfg.torAlways) ''
      tor = always
    '' + cfg.extraConfig;
  };
in with lib; {
  options.services.zeronet = {
    enable = mkEnableOption "zeronet";

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/zeronet";
      example = "/home/okina/zeronet";
      description = "Path to the zeronet data directory.";
    };

    logDir = mkOption {
      type = types.path;
      default = "/var/log/zeronet";
      example = "/home/okina/zeronet/log";
      description = "Path to the zeronet log directory.";
    };

    port = mkOption {
      type = types.nullOr types.int;
      default = null;
      example = 43110;
      description = "Optional zeronet web UI port.";
    };

    tor = mkOption {
      type = types.bool;
      default = false;
      description = "Use TOR for zeronet traffic where possible.";
    };

    torAlways = mkOption {
      type = types.bool;
      default = false;
      description = "Use TOR for all zeronet traffic.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";

      description = ''
        Extra configuration. Contents will be added verbatim to the
        configuration file at the end.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.tor = mkIf cfg.tor {
      enable = true;
      controlPort = 9051;
      extraConfig = ''
        CacheDirectoryGroupReadable 1
        CookieAuthentication 1
        CookieAuthFileGroupReadable 1
      '';
    };

    systemd.services.zeronet = {
      description = "zeronet";
      after = [ "network.target" (optionalString cfg.tor "tor.service") ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        # Ensure folder exists or create it and permissions are correct
        mkdir -p ${escapeShellArg cfg.dataDir} ${escapeShellArg cfg.logDir}
        chmod 750 ${escapeShellArg cfg.dataDir} ${escapeShellArg cfg.logDir}
        chown zeronet:zeronet ${escapeShellArg cfg.dataDir} ${escapeShellArg cfg.logDir}
      '';

      serviceConfig = {
        PermissionsStartOnly = true;
        PrivateTmp = "yes";
        User = "zeronet";
        Group = "zeronet";
        ExecStart = "${pkgs.zeronet}/bin/zeronet --config_file ${zConfFile}";
      };
    };

    users = {
      groups.zeronet.gid = config.ids.gids.zeronet;

      users.zeronet = {
        description = "zeronet service user";
        home = cfg.dataDir;
        createHome = true;
        group = "zeronet";
        extraGroups = mkIf cfg.tor [ "tor" ];
        uid = config.ids.uids.zeronet;
      };
    };
  };

  meta.maintainers = with maintainers; [ chiiruno ];
}
