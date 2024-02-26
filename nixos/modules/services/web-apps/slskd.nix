{ lib, pkgs, config, ... }:

let
  settingsFormat = pkgs.formats.yaml {};
in {
  options.services.slskd = with lib; with types; {
    enable = mkEnableOption "slskd";

    rotateLogs = mkEnableOption "a unit and a timer that will rotate logs in /var/slskd/logs";

    package = mkPackageOption pkgs "slskd" { };

    nginx = mkOption {
      description = mdDoc "options for nginx";
      example = {
        enable = true;
        domain = "example.com";
        contextPath = "/slskd";
      };
      type = submodule {
        options = {
          enable = mkEnableOption "nginx as a reverse proxy";

          domainName = mkOption {
            type = str;
            description = "The domain to use";
          };
          contextPath = mkOption {
            type = path;
            default = "/";
            description = mdDoc ''
              The context path, i.e., the last part of the slskd
              URL. Typically '/' or '/slskd'. Default '/'
            '';
          };
          bindAddress = mkOption {
            type = str;
            default = "localhost";
            example = "10.0.0.1";
            description = mdDoc ''
              The address at which slskd serves its web interface.
            '';
          };
        };
      };
    };

    passwordFile = mkOption {
      type = path;
      example = "/var/lib/secrets/slskd_password";
      description = ''
        Password file for slskd; read at service startup.
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

    filteredSettings = lib.filterAttrsRecursive (_: value: value != null) cfg.settings;
    settingsFile = settingsFormat.generate "slskd.yml" filteredSettings;

    # Error redirection to /dev/null prevents unwanted password leak into the
    # logs through the error message of `jq`, should it happen
    slskd-prestart = pkgs.writeShellScript "slskd-prestart" ''
      set -eu
      ${pkgs.yq}/bin/yq -Y \
        --arg password "$(<'${cfg.passwordFile}')" \
        '.soulseek += $ARGS.named' \
        <'${settingsFile}' 2>/dev/null |
          install -D -m 600 -o slskd -g slskd /dev/stdin /var/lib/slskd/slskd.yml
    '';

  in lib.mkIf cfg.enable {

    users = {
      users.slskd = {
        isSystemUser = true;
        group = "slskd";
      };
      groups.slskd = {};
    };

    # Reverse proxy configuration
    services.nginx = lib.mkIf cfg.nginx.enable {
      enable = true;
      virtualHosts.${cfg.nginx.domainName}.locations.${cfg.nginx.contextPath} = {
        proxyPass =
          "http://${toString cfg.nginx.bindAddress}:${toString cfg.settings.web.port}";
        proxyWebsockets = true;
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
        StateDirectory = "slskd";
        ExecStartPre = "+" + slskd-prestart;
        ExecStart = "${cfg.package}/bin/slskd --app-dir /var/lib/slskd --config /var/lib/slskd/slskd.yml";
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
