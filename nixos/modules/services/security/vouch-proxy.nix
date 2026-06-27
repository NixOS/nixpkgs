{
  options,
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.vouch-proxy;
  yaml = pkgs.formats.yaml { };
in

{
  options.services.vouch-proxy = {
    enable = lib.mkEnableOption "vouch-proxy";

    package = lib.mkPackageOption pkgs "vouch-proxy" { };

    configureNginx = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = ''
        Automatic configuration of `services.nginx.virtualHosts.''${services.vouch-proxy.clients.<name>.domain}` to use vouch-proxy, for every client defined in `services.vouch-proxy.clients`.
      '';
    };

    kanidmDomain = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
      description = ''
        If kanidm is used as an oauth2 provider, this can be set to the domain kanidm manages. From this setting, `settings.oauth.auth_url`, `settings.oauth.token_url` and `settings.oauth.user_info_url` are set accordingly for every client.
      '';
    };

    domain = lib.mkOption {
      type = lib.types.str;
      description = "The domain vouch-proxy runs under in the oauth2-login-flow, used e.g. in the callback_url.";
    };

    clients = lib.mkOption {
      default = { };
      description = ''
        Set of oauth2 clients. One vouch-proxy systemd unit with the name of the client, prefixed by `vouch-proxy.clientPrefix`, will be run for every client in this set.
        Each of these sets should at least define the `port` attribute that defines the port this client's specific vouch-proxy instance listens on.

        If `configureNginx` is set to `true`, the `domain` attribute defining the name of the nginx virtualHost (`services.nginx.virtualHost.<name>`) that this client is running under should also be set.
      '';
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            port = lib.mkOption {
              type = lib.types.port;
              description = ''
                The port the vouch-proxy instance protecting this client is listening on.
              '';
            };
            domain = lib.mkOption {
              type = lib.types.str;
              description = ''
                The domain of the nginx.virtualHost this client is running under. This should match the corresponding attribute name in `services.nginx.virtualHost.<name>`.
              '';
            };
            environmentFile = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = ''
                Environment file as defined in {manpage}`systemd.exec(5)`.

                The environment variables definid therein are passed to the vouch-proxy instance protecting this client.
                You can use environment variables to pass secrets to the service without adding
                them to the world-redable nix store.
              '';
            };
            settings = lib.mkOption {
              default = {
              };
              description = ''
                Free-form settings written to the `config.yml` file used by vouch-proxy.
                These settings override the global settings set in `services.vouch-proxy.settings` for this specific client.
                A sample config can be found at <https://github.com/vouch/vouch-proxy/blob/master/config/config.yml_example>.
              '';
              type = lib.types.submodule {
                freeformType = yaml.type;
                options = { };
              };
            };
          };
        }
      );
    };

    clientPrefix = lib.mkOption {
      type = lib.types.str;
      default = "vouch-";
      description = ''
        A prefix added to the name of every systemd unit and every oauth2 client-id managed by vouch-proxy. The attribute name in `vouch-proxy.clients` is added to this prefix to give the full names.
      '';
    };

    user = lib.mkOption {
      default = "vouch-proxy";
      type = lib.types.str;
      description = "The unix user all vouch-proxy instances run as.";
    };

    group = lib.mkOption {
      default = "vouch-proxy";
      type = lib.types.str;
      description = "The unix group all vouch-proxy instances run as.";
    };

    settings = lib.mkOption {
      default = {
      };
      description = ''
        Free-form settings written to the `config.yml` file used by vouch-proxy.
        These settings will be used globally for all clients running behind vouch-proxy.
        A sample config can be found at <https://github.com/vouch/vouch-proxy/blob/master/config/config.yml_example>.
      '';
      type = lib.types.submodule {
        freeformType = yaml.type;
        options = {
          vouch = {
            listen = lib.mkOption {
              default = "[::1]";
              type = lib.types.str;
              description = "The address vouch-proxy listens on.";
            };
            document_root = lib.mkOption {
              default = "/vouch";
              type = lib.types.str;
              description = "The location within every client's host where its corresponding vouch-proxy is served.";
            };
            allowAllUsers = lib.mkOption {
              default = cfg.settings.vouch.domains == null;
              type = lib.types.bool;
              description = "Accept anyone who can authenticate at the configured provider. This is the fallback if no granular configuration is defined in `services.vouch-proxy.settings.vouch.domains`.";
            };
            domains = lib.mkOption {
              default = null;
              type = lib.types.nullOr (lib.types.listOf lib.types.str);
              description = ''
                List of domains protected by vouch-proxy. Each $domain in this list must serve the url `https://vouch.$domain`.
              '';
            };
          };
          oauth = {
            provider = lib.mkOption {
              default = "oidc";
              type = lib.types.enum [
                "adfs"
                "google"
                "github"
                "indieauth"
                "oidc"
              ];
              description = "The oauth2 provider to use.";
            };
            code_challenge_method = lib.mkOption {
              default = "S256";
              type = lib.types.str;
              description = "PKCE method if enabled, S256 is currently supported.";
            };
            scopes = lib.mkOption {
              default = [
                "openid"
                "email"
              ];
              type = lib.types.listOf lib.types.str;
              description = "List of oauth2 scopes requested by vouch-proxy.";
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {

    users.users."${cfg.user}" = {
      isSystemUser = true;
      group = "${cfg.group}";
    };
    users.groups."${cfg.group}" = { };

    systemd.services = lib.mapAttrs' (client: clientAttrs: {
      name = "${cfg.clientPrefix}${client}";
      value = {
        description = "Vouch Proxy for ${client}.";
        after = [ "network.target" ];
        wantedBy = [ "default.target" ];
        serviceConfig = {
          Type = "simple";
          DevicePolicy = "closed";
          DynamicUser = true;
          User = cfg.user;
          Group = cfg.group;
          EnvironmentFile = clientAttrs.environmentFile;
          ExecStart = "${cfg.package}/bin/vouch-proxy -config ${
            yaml.generate "config.yml" (
              lib.recursiveUpdate (lib.recursiveUpdate cfg.settings {
                vouch = {
                  port = clientAttrs.port;
                }
                // (lib.optionalAttrs cfg.settings.vouch.allowAllUsers {
                  cookie.domain = clientAttrs.domain;
                });
                oauth = {
                  client_id = "${cfg.clientPrefix}${client}";
                  callback_url = "https://${clientAttrs.domain}${cfg.settings.vouch.document_root}/auth";
                }
                // (lib.optionalAttrs (cfg.kanidmDomain != null) {
                  auth_url = "https://${cfg.kanidmDomain}/ui/oauth2";
                  token_url = "https://${cfg.kanidmDomain}/oauth2/token";
                  user_info_url = "https://${cfg.kanidmDomain}/oauth2/openid/${cfg.clientPrefix}${client}/userinfo";
                });
              }) cfg.clients.${client}.settings
            )
          }";
          Restart = "on-failure";
          RestartSec = 5;
          StartLimitBurst = 3;
          StateDirectory = "${cfg.clientPrefix}${client}";
          RuntimeDirectory = "${cfg.clientPrefix}${client}";
          WorkingDirectory = "/var/lib/${cfg.clientPrefix}${client}";

          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          PrivateDevices = true;
          PrivateMounts = true;
          PrivateTmp = true;
          PrivateUsers = true;
          PrivateIPC = true;
          RemoveIPC = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service @resources"
            "~@clock @debug @module @mount @reboot @swap @cpu-emulation @obsolete @timer @chown @setuid @privileged @keyring @ipc"
          ];
          SystemCallErrorNumber = "EPERM";
        };
      };
    }) cfg.clients;

    services.nginx.virtualHosts = lib.mkIf cfg.configureNginx (
      lib.mapAttrs' (_: clientAttrs: {
        name = clientAttrs.domain;
        value = {
          extraConfig = ''
            error_page 401 = @error401;
          '';
          locations."@error401".return = ''
            302 https://${clientAttrs.domain}${cfg.settings.vouch.document_root}/login?url=$scheme://$http_host$request_uri&vouch-failcount=$auth_resp_failcount&X-Vouch-Token=$auth_resp_jwt&error=$auth_resp_err
          '';

          locations."/".extraConfig = ''
            auth_request /vouch/validate;
          '';

          locations."${cfg.settings.vouch.document_root}" = {
            proxyPass = "http://[::1]:${builtins.toString clientAttrs.port}";
            extraConfig = ''
              proxy_set_header X-Forwarded-Host $host;
              proxy_pass_request_body off;
              proxy_set_header Content-Length "";

              auth_request_set $auth_resp_jwt $upstream_http_x_vouch_jwt;
              auth_request_set $auth_resp_err $upstream_http_x_vouch_err;
              auth_request_set $auth_resp_failcount $upstream_http_x_vouch_failcount;
            '';
          };
        };
      }) cfg.clients
    );

  };
  meta.maintainers = with lib.maintainers; [ boogiewoogit ]; 
}
