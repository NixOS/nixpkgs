{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.automx2;
  format = pkgs.formats.json { };
  imapSmtpServerType = lib.types.mkOptionType {
    name = "imapSmtpServerType";
    description = "automx2 settings: IMAP/SMTP server configuration";
    check =
      x:
      if !builtins.isAttrs x then
        false
      else if !lib.types.str.check x.type then
        false
      else if x.type != "imap" && x.type != "smtp" then
        false
      else if !lib.types.str.check x.name then
        false
      else if !lib.types.port.check x.port then
        false
      else
        true;
  };
  davServerType = lib.types.mkOptionType {
    name = "davServerType";
    description = "automx2 settings: CalDAV/CardDAV server configuration";
    check =
      x:
      if !builtins.isAttrs x then
        false
      else if
        !builtins.all (key: builtins.hasAttr key x) [
          "type"
          "url"
          "port"
        ]
      then
        false
      else if !lib.types.str.check x.type then
        false
      else if x.type != "caldav" && x.type != "carddav" then
        false
      else if !lib.types.str.check x.url then
        false
      else if !lib.types.port.check x.port then
        false
      else
        true;
  };
  serverType = lib.types.mkOptionType {
    name = "serverType";
    description = "The autoconfig values of mail and/or DAV services";
    check =
      x:
      if !lib.isList x then
        false
      else if builtins.length x < 1 then
        false
      else if !lib.all (item: imapSmtpServerType.check item || davServerType.check item) x then
        false
      else
        true;
  };
in
{
  options = {
    services.automx2 = {
      enable = lib.mkEnableOption "automx2";

      package = lib.mkPackageOption pkgs [
        "python3Packages"
        "automx2"
      ] { };

      domains = lib.mkOption {
        type = lib.types.nonEmptyListOf lib.types.str;
        example = [
          "example.org"
          "example.com"
        ];
        description = ''
          E-Mail-Domains for which mail client autoconfig/autoconfigure should be set up.
          The `autoconfig` and `autodiscover` subdomains are automatically prepended and set up with ACME.
          The names of those domains are hardcoded in the mail clients and are not configurable.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 4243;
        description = "Port used by automx2.";
      };

      settings = lib.mkOption {
        description = "Configuration of data provided by the automx2 service. Used to populate DB at service startup. See [docs](https://rseichter.github.io/automx2/#_sqlite) for details.";
        type = lib.types.submodule {
          freeformType = format.type;
          options = {
            provider = lib.mkOption {
              type = lib.types.str;
              example = "ACME Corp & Brothers Communication Services";
              description = "A description letting the user know, who provides the service.";
            };

            domains = lib.mkOption {
              type = lib.types.nonEmptyListOf lib.types.str;
              description = "The domains for which automx2 provides an autoconfiguration service";
              default = cfg.domains;
              defaultText = lib.literalExpression "services.automx2.domains";
              example = [
                "example.org"
                "example.com"
              ];
            };

            servers = lib.mkOption {
              type = serverType;
              description = "The offered services and their connection details";
              example = [
                {
                  name = "mail.example.org";
                  port = 993;
                  type = "imap";
                }
                {
                  url = "https://dav.example.com/cal/dav/";
                  port = 443;
                  type = "carddav";
                }
              ];
              default = [ ];
            };
          };
        };
      };

      logLevel = lib.mkOption {
        type = lib.types.enum [
          "INFO"
          "WARNING"
          "DEBUG"
          "ERROR"
          "CRITICAL"
        ];
        default = "WARNING";
        description = "Log level used for automx2 service.";
        example = "DEBUG";
      };

      webserver = lib.mkOption {
        type = lib.types.enum [
          "nginx"
          "caddy"
        ];
        default = "nginx";
        description = ''
          Whether to use nginx or caddy for virtual host management.

          Further nginx configuration can be done by adapting `services.nginx.virtualHosts.<name>`.
          See [](#opt-services.nginx.virtualHosts) for further information.

          Further caddy configuration can be done by adapting `services.caddy.virtualHosts.<name>`.
          See [](#opt-services.caddy.virtualHosts) for further information.
        '';
      };

    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        systemd.services.automx2 = {
          after = [ "network.target" ];
          postStart = "${lib.getExe pkgs.curl} -X POST --json @${format.generate "automx2.json" cfg.settings} http://127.0.0.1:${toString cfg.port}/initdb/";
          serviceConfig = {
            Environment = [
              "AUTOMX2_CONF=${pkgs.writeText "automx2-conf" ''
                [automx2]
                loglevel = ${cfg.logLevel}
                db_uri = sqlite:///:memory:
                proxy_count = 1
              ''}"
              "FLASK_APP=automx2.server:app"
              "FLASK_CONFIG=production"
            ];
            ExecStart = "${
              pkgs.python3.buildEnv.override { extraLibs = [ cfg.package ]; }
            }/bin/flask run --host=127.0.0.1 --port=${toString cfg.port}";
            Restart = "always";
            DynamicUser = true;
            User = "automx2";
            Type = "notify";
          };
          unitConfig = {
            Description = "Service to automatically configure mail clients";
            Documentation = "https://rseichter.github.io/automx2/";
          };
          wantedBy = [ "multi-user.target" ];
        };
      }
      (lib.mkIf (cfg.webserver == "nginx") {
        services.nginx = {
          enable = true;
          virtualHosts = builtins.listToAttrs (
            map (domain: {
              name = "autoconfig.${domain}";
              value = {
                enableACME = true;
                forceSSL = true;
                serverAliases = [ "autodiscover.${domain}" ];
                locations = {
                  "/".proxyPass = "http://127.0.0.1:${toString cfg.port}/";
                  "/initdb".extraConfig = ''
                    # Limit access to clients connecting from localhost
                    allow 127.0.0.1;
                    deny all;
                  '';
                };
              };
            }) cfg.domains
          );
        };
      })
      (lib.mkIf (cfg.webserver == "caddy") {
        services.caddy = {
          enable = true;
          virtualHosts = builtins.listToAttrs (
            map (domain: {
              name = "autoconfig.${domain}";
              value = {
                serverAliases = [ "autodiscover.${domain}" ];
                extraConfig = ''
                  route /initdb* {
                    respond 403 {
                      body "Access Denied"
                    }
                  }

                  route * {
                    reverse_proxy http://127.0.0.1:${toString cfg.port}
                  }
                '';
              };
            }) cfg.domains
          );
        };
      })
    ]
  );

  imports = [
    (lib.mkChangedOptionModule [ "services" "automx2" "domain" ] [ "services" "automx2" "domains" ]
      (config: [ config.services.automx2.domain ])
    )
  ];
}
