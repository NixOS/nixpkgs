{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.oauth2-proxy-multi;
  toml = pkgs.formats.toml { };
in

{
  options.services.oauth2-proxy-multi = {

    enable = lib.mkEnableOption "oauth2-proxy-multi";

    package = lib.mkPackageOption pkgs "oauth2-proxy" { };

    configureNginx = lib.mkOption {
      default = config.services.nginx.enable;
      defaultText = "services.nginx.enable";
      type = lib.types.bool;
      description = ''
        Automatic configuration of `services.nginx.virtualHosts.$${services.oauth2-proxy-multi.clients.<name>.domain}` to use oauth2-proxy, for every client defined in `services.oauth2-proxy-multi.clients`.

        Also sets `reverse-proxy` in oauth2-proxy settings.
      '';
    };

    configureCaddy = lib.mkOption {
      default = config.services.caddy.enable;
      defaultText = "services.caddy.enable";
      type = lib.types.bool;
      description = ''
        Automatic configuration of `services.caddy.virtualHosts.$${services.oauth2-proxy-multi.clients.<name>.domain}` to use oauth2-proxy, for every client defined in `services.oauth2-proxy-multi.clients`.

        Also sets `reverse-proxy` in oauth2-proxy settings.
      '';
    };

    kanidmDomain = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
      description = ''
        If kanidm is used as an oauth2 provider, this can be set to the domain kanidm manages. If this is set, `settings.oidc-issuer-url` is set accordingly for every client.
      '';
    };

    common = lib.mkOption {
      description = "Settings globally applied to all oauth2-proxy clients. Overridden by per-client settings.";
      type = lib.types.submodule {
        options = {

          settings = lib.mkOption {
            default = { };
            description = "Free-form settings written to the `config.toml` of every client's oauth2-proxy instance.";
            type = lib.types.submodule {
              freeformType = toml.type;
              options = {

                provider = lib.mkOption {
                  type = lib.types.enum [
                    "adfs"
                    "azure"
                    "bitbucket"
                    "digitalocean"
                    "facebook"
                    "github"
                    "gitlab"
                    "google"
                    "keycloak"
                    "keycloak-oidc"
                    "linkedin"
                    "login.gov"
                    "nextcloud"
                    "oidc"
                  ];
                  default = "oidc";
                  description = "OAuth provider.";
                };

                allowed_groups = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [ ];
                  description = ''
                    Restrict login to members of a group or list of groups. Furthermore, if you aren't setting the scope and use allowed_groups with the generic OIDC provider the scope groups gets added implicitly.
                  '';
                };

                email_domains = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [ "*" ];
                  description = "Authenticate emails with the specified domains. Use `*` to authenticate any email.";
                };

                oidc_issuer_url = lib.mkOption {
                  type = lib.types.str;
                  default = "";
                  description = "The OAuth issuer URL.";
                  example = "https://login.microsoftonline.com/{TENANT_ID}/v2.0";
                };

                trusted_proxy_ips = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [
                    "::1"
                    "127.0.0.1"
                  ];
                  description = ''
                    List of IPs or CIDR ranges allowed to supply X-Forwarded-* headers when reverseProxy is enabled.
                    If not set, OAuth2 Proxy preserves backwards compatibility by trusting all source IPs (0.0.0.0/0, ::/0) and logs a warning at startup.
                    Configure this to your reverse proxy addresses to prevent forwarded header spoofing.
                  '';
                };

                code_challenge_method = lib.mkOption {
                  type = lib.types.enum [
                    "S256"
                    "plain"
                  ];
                  default = "S256";
                  description = "Use PKCE code challenges with the specified method. Either 'S256' (recommended) or 'plain'.";
                };

                skip_provider_button = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                  description = "Will skip sign-in-page to directly reach the next step: `/oauth/start`.";
                };

                scope = lib.mkOption {
                  type = lib.types.str;
                  default = "openid email";
                  description = "OAuth scope specification.";
                };
              };
            };
          };
        };
      };
    };

    clients = lib.mkOption {
      default = { };
      description = "Set of oauth2 clients. An oauth2-proxy systemd unit with the name of the client will be run for every client in this set, with the provided settings overriding the common defaults.";
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {

            domain = lib.mkOption {
              type = lib.types.str;
              description = "The domain this oauth2-proxy runs under. Used e.g. for the `redirect-url` and to setup the correct nginx/caddy virtual host if `configureNginx = true` or `configureCaddy = true`.";
            };

            environmentFile = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = ''
                Environment file as defined in {manpage}`systemd.exec(5)`.

                The environment variables defined therein are passed to the oauth2-proxy instance protecting this client.
                You can use environment variables to pass secrets to the service without adding
                them to the world-redable nix store.
              '';
            };

            user = lib.mkOption {
              default = "oauth2-proxy";
              type = lib.types.str;
              description = "The unix user this oauth2-proxy instance runs as.";
            };

            group = lib.mkOption {
              default = "oauth2-proxy";
              type = lib.types.str;
              description = "The unix group this oauth2-proxy instance runs as.";
            };

            settings = lib.mkOption {
              default = { };
              description = "Free-form settings written to the `config.toml` of this client's oauth2-proxy instance.";
              type = lib.types.submodule {
                freeformType = toml.type;
                options = {

                  client_id = lib.mkOption {
                    type = lib.types.str;
                    default = "";
                    description = ''
                      The OAuth Client ID, e.g. \"123456.apps.googleusercontent.com\".

                      If left empty, this is set to the attribute name in `services.oauth2-proxy-multi.clients`.
                    '';
                  };

                  http_address = lib.mkOption {
                    type = lib.types.str;
                    default = "";
                    description = ''
                      The http address this oauth2-proxy instance listens on.

                      [http://]<addr>:<port> or unix://<path> or fd:<int> (case insensitive) to listen on for HTTP clients. Unix sockets are created with default system umask mode, which can be overridden, e.g. unix://my-socket,mode=0777. Square brackets are required for ipv6 address, e.g. http://[::1]:4180.

                      If left empty, this is set to `unix:///run/oauth2-proxy-''${settings.client_id}/oauth2-proxy-''${settings.client_id}.sock`.
                    '';
                  };

                  upstreams = lib.mkOption {
                    type = lib.types.str;
                    description = "The http url(s) of the upstream endpoint, file:// paths for static files or static://<status_code> for static response. Routing is based on the path.";
                  };

                  redirect_url = lib.mkOption {
                    type = lib.types.str;
                    default = "";
                    description = ''
                      The OAuth Redirect URL, e.g. "https://internalapp.yourcompany.com/oauth2/callback".

                      If left empty, this is set to `https://''${domain}/oauth2/callback`.
                    '';
                  };

                  client_secret_file = lib.mkOption {
                    type = lib.types.nullOr lib.types.path;
                    default = null;
                    description = "The path to a file containing the OAuth Client Secret.";
                    example = "/run/keys/oauth2-client-secret";
                  };

                  cookie_domains = lib.mkOption {
                    type = lib.types.str;
                    default = "";
                    description = ''
                      Optional cookie domains to force cookies to (ie: `.yourcompany.com`).
                      The longest domain matching the request's host will be used (or the shortest
                      cookie domain if there is no match).

                      If left empty, this is set to `''${domain}`.
                    '';
                    example = ".yourcompany.com";
                  };

                  cookie_secret_file = lib.mkOption {
                    type = lib.types.nullOr lib.types.path;
                    default = null;
                    description = "The path to a file containing the seed string for secure cookies.";
                    example = "/run/keys/oauth2-cookie-secret";
                  };

                  cookie_secure = lib.mkOption {
                    type = lib.types.bool;
                    default = true;
                    description = ''
                      Set secure (HTTPS) cookie flag.

                      Will be set to `false`, if `configureNginx = true` or `configureCaddy = true`.
                    '';
                  };

                  reverse_proxy = lib.mkOption {
                    type = lib.types.bool;
                    default = false;
                    description = ''
                      In case when running behind a reverse proxy, controls whether headers
                      like `X-Real-Ip` are accepted. Usage behind a reverse
                      proxy will require this flag to be set to avoid logging the reverse
                      proxy IP address.

                      Will be set to `true`, if `configureNginx = true` or `configureCaddy = true`.
                    '';
                  };

                };
              };
            };
          };
        }
      );
    };

  };

  config = lib.mkIf cfg.enable {

    systemd.services = lib.mapAttrs' (client: clientConfig: {
      name = "oauth2-proxy-${client}";
      value = {
        description = "OAuth2 Proxy";
        path = [ cfg.package ];
        wantedBy = [ "default.target" ];
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        serviceConfig = {
          Type = "simple";
          DynamicUser = true;
          User = clientConfig.user;
          Group = clientConfig.group;
          EnvironmentFile = lib.optional (clientConfig.environmentFile != null) clientConfig.environmentFile;
          LoadCredential =
            lib.optional (
              clientConfig.settings.client_secret_file != null
            ) "client_secret_file:${clientConfig.settings.client_secret_file}"
            ++ lib.optional (
              clientConfig.settings.cookie_secret_file != null
            ) "cookie_secret_file:${clientConfig.settings.cookie_secret_file}";
          ExecStart = "${lib.getExe cfg.package} --config ${
            toml.generate "config.toml" (
              cfg.common.settings
              // clientConfig.settings
              // {
                client_secret_file = "/run/credentials/oauth2-proxy-${client}.service/client_secret_file";
                cookie_secret_file = "/run/credentials/oauth2-proxy-${client}.service/cookie_secret_file";
              }
              // {
                reverse_proxy =
                  if cfg.configureNginx or cfg.configureCaddy then true else clientConfig.settings.reverse_proxy;
                cookie_secure =
                  if cfg.configureNginx or cfg.configureCaddy then true else clientConfig.settings.cookie_secure;
                oidc_issuer_url =
                  if cfg.kanidmDomain != null then
                    "https://${cfg.kanidmDomain}/oauth2/openid/${client}"
                  else
                    clientConfig.settings.oidc_issuer_url;
                client_id =
                  if clientConfig.settings.client_id == "" then "${client}" else clientConfig.settings.client_id;
                http_address =
                  if clientConfig.settings.http_address == "" then
                    "unix:///run/oauth2-proxy-${client}/oauth2-proxy-${client}.sock,mode=0666"
                  else
                    clientConfig.settings.http_address;
                redirect_url =
                  if clientConfig.settings.redirect_url == "" then
                    "https://${clientConfig.domain}/oauth2/callback"
                  else
                    clientConfig.settings.redirect_url;
                cookie_domains =
                  if clientConfig.settings.cookie_domains == "" then
                    clientConfig.domain
                  else
                    clientConfig.settings.cookie_domains;
              }
            )
          }";
          Restart = "always";
          RestartSec = 5;
          StartLimitBurst = 3;
          StateDirectory = "oauth2-proxy-${client}";
          RuntimeDirectory = "oauth2-proxy-${client}";
          WorkingDirectory = "/var/lib/oauth2-proxy-${client}";

          DevicePolicy = "closed";
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
      lib.mapAttrs' (client: clientConfig: {
        name = clientConfig.domain;
        value = {
          locations."/".proxyPass = lib.mkForce (
            if clientConfig.settings.http_address != "" then
              "http://${clientConfig.settings.http_address}"
            else
              "http://unix:/run/oauth2-proxy-${client}/oauth2-proxy-${client}.sock"
          );
        };
      }) cfg.clients
    );

    services.caddy.virtualHosts = lib.mkIf cfg.configureCaddy (
      lib.mapAttrs' (client: clientConfig: {
        name = clientConfig.domain;
        value = {
          extraConfig = lib.mkDefault (
            if clientConfig.settings.http_address != "" then
              "reverse_proxy ${clientConfig.settings.http_address}"
            else
              "reverse_proxy unix/run/oauth2-proxy-${client}/oauth2-proxy-${client}.sock"
          );
        };
      }) cfg.clients
    );
  };
}
