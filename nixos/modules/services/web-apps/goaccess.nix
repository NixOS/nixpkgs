{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.goaccess;

  mapSiteCfg =
    fn: lib.mkMerge (builtins.attrValues (builtins.mapAttrs (name: value: fn name value) cfg.sites));

  siteOptions = {
    options = {
      port = lib.mkOption {
        type = lib.types.port;
        default = 7890;
        description = "Port number for the GoAccess";
      };

      logFile = lib.mkOption {
        type = lib.types.str;
        description = "Path to the log file";
        example = "/var/log/nginx/myapp-access.log";
      };

      wsHost = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Hostname for the WebSocket connection.
          You can use this hostname to access GoAccess via ssh tunneling.
          For example, if you are ssh tunneling with `ssh -L 8080:127.0.0.1:80 -N user@remote`.
          you need to set this option to `ws://127.0.0.1:8080`.
        '';
        example = "ws://127.0.0.1:8080";
      };

      configFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Path to the GoAccess configuration file
          See default configuration: https://github.com/allinurl/goaccess/blob/master/config/goaccess.conf
        '';
        example = "/etc/goaccess/goaccess.conf";
      };
    };
  };

in
{

  options.services.goaccess = {

    enable = lib.mkEnableOption ''
      GoAccess: Real-time web log analyzer and
            interactive viewer that runs in a terminal in *nix systems'';

    sites = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule siteOptions);
      description = "GoAccess sites configurations";
      default = { };
      example = lib.literalExpression ''
        {
          myapp = {
            port = 7890;
            logFile = "/var/log/nginx/myapp-access.log";
            wsHost = "ws://127.0.0.1:8080";
            configFile = pkgs.writeText "goaccess.conf" \'\'
              log-format COMBINED
              real-time-html true
              html-refresh 30
              no-query-string true
            \'\';
          };
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {

    users.users = mapSiteCfg (
      siteName: siteCfg: {
        "goaccess-${siteName}" = {
          isSystemUser = true;
          group = config.services.nginx.group;
        };
      }
    );

    systemd.services = mapSiteCfg (
      siteName: siteCfg: {

        "goaccess-${siteName}" = {
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart =
              ''
                ${lib.getExe pkgs.goaccess} \
                  --port=${builtins.toString siteCfg.port} \
                  --output=/var/lib/goaccess-${siteName}/index.html \
                  --log-file=${siteCfg.logFile} \
              ''
              + (lib.optionalString (
                siteCfg.wsHost != null
              ) " --ws-url=${siteCfg.wsHost}/goaccess/${siteName}/ws")
              + (lib.optionalString (siteCfg.configFile != null) " --config-file=${siteCfg.configFile}");
            Restart = "on-failure";
            User = "goaccess-${siteName}";
            StateDirectory = "goaccess-${siteName}";
            WorkingDirectory = "/var/lib/goaccess-${siteName}";
            NoNewPrivileges = true;
            PrivateDevices = "yes";
            PrivateTmp = true;
            ProtectHome = "read-only";
            ProtectKernelModules = "yes";
            ProtectKernelTunables = "yes";
            ProtectSystem = "strict";
            ReadOnlyPaths = [ siteCfg.logFile ];
            ReadWritePaths = [
              "/proc/self"
              "/var/lib/goaccess-${siteName}"
            ];
            SystemCallFilter = "~@clock @cpu-emulation @debug @keyring @memlock @module @mount @obsolete @privileged @reboot @resources @setuid @swap @raw-io";
          };
        };

      }
    );

    services.nginx.virtualHosts."localhost" = mapSiteCfg (
      siteName: siteCfg: {

        locations."/goaccess/${siteName}/" = {
          alias = "/var/lib/goaccess-${siteName}/";
          extraConfig = ''
            # Limit access to clients connecting from localhost
            allow 127.0.0.1;
            deny all;
          '';
        };

        locations."/goaccess/${siteName}/ws" = {
          proxyPass = "http://127.0.0.1:${builtins.toString siteCfg.port}";
          extraConfig = ''
            # Upgrade connection to WebSocket
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $connection_upgrade;
            proxy_buffering off;
            proxy_read_timeout 7d;

            # Limit access to clients connecting from localhost
            allow 127.0.0.1;
            deny all;
          '';
        };

      }
    );
  };

  meta.maintainers = with lib.maintainers; [ bhankas ];
}
