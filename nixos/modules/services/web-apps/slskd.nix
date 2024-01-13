{ lib, pkgs, config, ... }:

let
  settingsFormat = pkgs.formats.yaml {};
in {
  options.services.slskd = with lib; with types; {
    enable = mkEnableOption "enable slskd";

    rotateLogs = mkEnableOption "enable an unit and timer that will rotate logs in /var/slskd/logs";

    package = mkPackageOption pkgs "slskd" { };

    nginx = mkOption {
      description = lib.mdDoc "options for nginx";
      example = {
        enable = true;
        domain = "example.com";
        contextPath = "/slskd";
      };
      type = submodule ({name, config, ...}: {
        options = {
          enable = mkEnableOption "enable nginx as a reverse proxy";

          domainName = mkOption {
            type = str;
            description = "Domain you want to use";
          };
          contextPath = mkOption {
            type = types.path;
            default = "/";
            description = lib.mdDoc ''
              The context path, i.e., the last part of the slskd
              URL. Typically '/' or '/slskd'. Default '/'
            '';
          };
        };
      });
    };

    environmentFile = mkOption {
      type = path;
      description = ''
        Path to a file containing secrets.
        It must at least contain the variable `SLSKD_SLSK_PASSWORD`
      '';
    };

    openFirewall = mkOption {
      type = bool;
      description = ''
        Whether to open the firewall for services.slskd.settings.listen_port";
      '';
      default = false;
    };

    settings = mkOption {
      description = lib.mdDoc ''
        Configuration for slskd, see
        [available options](https://github.com/slskd/slskd/blob/master/docs/config.md)
        `APP_DIR` is set to /var/lib/slskd, where default download & incomplete directories,
        log and databases will be created.
      '';
      default = {};
      type = submodule {
        freeformType = settingsFormat.type;
        options = {

          soulseek = {
            username = mkOption {
              type = str;
              description = "Username on the Soulseek Network";
            };
            listen_port = mkOption {
              type = port;
              description = "Port to use for communication on the Soulseek Network";
              default = 50000;
            };
          };

          web = {
            port = mkOption {
              type = port;
              default = 5001;
              description = "The HTTP listen port";
            };
            url_base = mkOption {
              type = path;
              default = config.services.slskd.nginx.contextPath;
              defaultText = "config.services.slskd.nginx.contextPath";
              description = lib.mdDoc ''
                The context path, i.e., the last part of the slskd URL
              '';
            };
          };

          shares = {
            directories = mkOption {
              type = listOf str;
              description = lib.mdDoc ''
                Paths to your shared directories. See
                [documentation](https://github.com/slskd/slskd/blob/master/docs/config.md#directories)
                for advanced usage
              '';
            };
          };

          directories = {
            incomplete = mkOption {
              type = nullOr path;
              description = "Directory where downloading files are stored";
              defaultText = "<APP_DIR>/incomplete";
              default = null;
            };
            downloads = mkOption {
              type = nullOr path;
              description = "Directory where downloaded files are stored";
              defaultText = "<APP_DIR>/downloads";
              default = null;
            };
          };
        };
      };
    };
  };

  config = let
    cfg = config.services.slskd;

    confWithoutNullValues = (lib.filterAttrs (key: value: value != null) cfg.settings);

    configurationYaml = settingsFormat.generate "slskd.yml" confWithoutNullValues;

  in lib.mkIf cfg.enable {

    users = {
      users.slskd = {
        isSystemUser = true;
        group = "slskd";
      };
      groups.slskd = {};
    };

    # Reverse proxy configuration
    services.nginx.enable = true;
    services.nginx.virtualHosts."${cfg.nginx.domainName}" = {
      forceSSL = true;
      enableACME = true;
      locations = {
        "${cfg.nginx.contextPath}" = {
          proxyPass = "http://localhost:${toString cfg.settings.web.port}";
          proxyWebsockets = true;
        };
      };
    };

    # Hide state & logs
    systemd.tmpfiles.rules = [
      "d /var/lib/slskd/data 0750 slskd slskd - -"
      "d /var/lib/slskd/logs 0750 slskd slskd - -"
    ];

    systemd.services.slskd = {
      description = "A modern client-server application for the Soulseek file sharing network";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        User = "slskd";
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
        StateDirectory = "slskd";
        ExecStart = "${cfg.package}/bin/slskd --app-dir /var/lib/slskd --config ${configurationYaml}";
        Restart = "on-failure";
        ReadOnlyPaths = map (d: builtins.elemAt (builtins.split "[^/]*(/.+)" d) 1) cfg.settings.shares.directories;
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictSUIDSGID = true;
      };
    };

    networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.settings.soulseek.listen_port;

    systemd.services.slskd-rotatelogs = lib.mkIf cfg.rotateLogs {
      description = "Rotate slskd logs";
      serviceConfig = {
        Type = "oneshot";
        User = "slskd";
        ExecStart = [
          "${pkgs.findutils}/bin/find /var/lib/slskd/logs/ -type f -mtime +10 -delete"
          "${pkgs.findutils}/bin/find /var/lib/slskd/logs/ -type f -mtime +1  -exec ${pkgs.gzip}/bin/gzip -q {} ';'"
        ];
      };
      startAt = "daily";
    };

  };
}
