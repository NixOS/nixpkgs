{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;
  inherit (lib.attrsets) filterAttrsRecursive;
  cfg = config.services.headplane;
  settingsFile = (pkgs.formats.yaml { }).generate "headplane-config.yaml" (
    # Headplane config can't have `null` values.
    filterAttrsRecursive (n: v: v != null) cfg.settings
  );
in
{
  options.services.headplane = {
    enable = mkEnableOption "Headplane";
    package = mkPackageOption pkgs "headplane" { };

    debug = mkOption {
      type = types.bool;
      default = false;
      description = "Enable debug logging.";
    };

    settings = mkOption {
      description = ''
        Headplane configuration options. Generates a YAML config file.
        See: https://github.com/tale/headplane/blob/main/config.example.yaml
      '';
      type = types.submodule {
        options = {
          server = mkOption {
            type = types.submodule {
              options = {
                host = mkOption {
                  type = types.str;
                  default = "127.0.0.1";
                  description = "The host address to bind to.";
                  example = "0.0.0.0";
                };

                port = mkOption {
                  type = types.port;
                  default = 3000;
                  description = "The port to listen on.";
                };

                cookie_secret_path = mkOption {
                  type = types.nullOr types.path;
                  default = null;
                  description = ''
                    Path to a file containing the cookie secret.
                    The secret must be exactly 32 characters long.
                  '';
                  example = "config.sops.secrets.headplane_cookie.path";
                };

                cookie_secure = mkOption {
                  type = types.bool;
                  default = true;
                  description = ''
                    Should the cookies only work over HTTPS?
                    Set to false if running via HTTP without a proxy.
                    Recommended to be true in production.
                  '';
                };

                data_path = mkOption {
                  type = types.path;
                  default = "/var/lib/headplane";
                  description = ''
                    The path to persist Headplane specific data.
                    All data going forward is stored in this directory, including the internal database and any cache related files.
                    Data formats prior to 0.6.1 will automatically be migrated.
                  '';
                  example = "/var/lib/headplane";
                };
              };
            };
            default = { };
            description = "Server configuration for Headplane web application.";
          };

          headscale = mkOption {
            type = types.submodule {
              options = {
                url = mkOption {
                  type = types.str;
                  default = "http://127.0.0.1:${toString config.services.headscale.port}";
                  defaultText = lib.literalExpression "http://127.0.0.1:\${toString config.services.headscale.port}";
                  description = ''
                    The URL to your Headscale instance.
                    All API requests are routed through this URL.
                    THIS IS NOT the gRPC endpoint, but the HTTP endpoint.
                    IMPORTANT: If you are using TLS this MUST be set to `https://`.
                  '';
                  example = "https://headscale.example.com";
                };

                tls_cert_path = mkOption {
                  type = types.nullOr types.path;
                  default = null;
                  description = ''
                    Path to a file containing the TLS certificate.
                  '';
                  example = "config.sops.secrets.tls_cert.path";
                };

                public_url = mkOption {
                  type = types.nullOr types.str;
                  default = config.services.headscale.settings.server_url;
                  defaultText = lib.literalExpression "config.services.headscale.settings.server_url";
                  description = "Public URL if different. This affects certain parts of the web UI.";
                  example = "https://headscale.example.com";
                };

                config_path = mkOption {
                  type = types.nullOr types.path;
                  default = config.services.headscale.configFile;
                  defaultText = lib.literalExpression "config.services.headscale.configFile";
                  description = ''
                    Path to the Headscale configuration file.
                    This is optional, but HIGHLY recommended for the best experience.
                    If this is read only, Headplane will show your configuration settings
                    in the Web UI, but they cannot be changed.
                  '';
                  example = "/etc/headscale/config.yaml";
                };

                config_strict = mkOption {
                  type = types.bool;
                  default = false;
                  description = ''
                    Headplane internally validates the Headscale configuration
                    to ensure that it changes the configuration in a safe way.
                    If you want to disable this validation, set this to false.
                  '';
                };

                dns_records_path = mkOption {
                  type = types.nullOr types.path;
                  default = null;
                  description = ''
                    If you are using `dns.extra_records_path` in your Headscale configuration, you need to set this to the path for Headplane to be able to read the DNS records.
                    Ensure that the file is both readable and writable by the Headplane process.
                    When using this, Headplane will no longer need to automatically restart Headscale for DNS record changes.
                  '';
                  example = "/var/lib/headplane/extra_records.json";
                };
              };
            };
            default = { };
            description = "Headscale specific settings for Headplane integration.";
          };

          integration = mkOption {
            type = types.submodule {
              options = {
                agent = mkOption {
                  type = types.submodule {
                    options = {
                      enabled = mkOption {
                        type = types.bool;
                        default = false;
                        description = ''
                          The Headplane agent allows retrieving information about nodes.
                          This allows the UI to display version, OS, and connectivity data.
                          You will see the Headplane agent in your Tailnet as a node when it connects.
                        '';
                      };

                      executable_path = mkOption {
                        type = types.path;
                        readOnly = true;
                        default = "${cfg.settings.integration.agent.package}/bin/hp_agent";
                        defaultText = lib.literalExpression ''"''\${config.services.headplane.settings.integration.agent.package}/bin/hp_agent"'';
                        description = ''
                          Path to the headplane agent binary.
                        '';
                      };

                      pre_authkey_path = mkOption {
                        type = types.nullOr types.path;
                        default = null;
                        description = ''
                          Path to a file containing the agent preauth key.
                          To connect to your Tailnet, you need to generate a pre-auth key.
                          This can be done via the web UI or through the `headscale` CLI.
                        '';
                        example = "config.sops.secrets.agent_pre_authkey.path";
                      };

                      host_name = mkOption {
                        type = types.str;
                        default = "headplane-agent";
                        description = "Optionally change the name of the agent in the Tailnet";
                      };

                      cache_ttl = mkOption {
                        type = types.ints.positive;
                        default = 180000;
                        description = ''
                          How long to cache agent information (in milliseconds).
                          If you want data to update faster, reduce the TTL, but this will increase the frequency of requests to Headscale.
                        '';
                      };

                      cache_path = mkOption {
                        type = types.path;
                        default = "/var/lib/headplane/agent_cache.json";
                        description = "Where to store the agent cache.";
                      };

                      work_dir = mkOption {
                        type = types.path;
                        default = "/var/lib/headplane/agent";
                        description = ''
                          Do not change this unless you are running a custom deployment.
                          The work_dir represents where the agent will store its data to be able to automatically reauthenticate with your Tailnet.
                          It needs to be writable by the user running the Headplane process.
                        '';
                      };

                      package = mkPackageOption pkgs "headplane-agent" { };
                    };
                  };
                  default = { };
                  description = "Agent configuration for the Headplane agent.";
                };

                proc = mkOption {
                  type = types.submodule {
                    options = {
                      enabled = mkOption {
                        type = types.bool;
                        default = true;
                        description = ''
                          Enable "Native" integration that works when Headscale and
                          Headplane are running outside of a container. There is no additional
                          configuration, but you need to ensure that the Headplane process
                          can terminate the Headscale process.
                        '';
                      };
                    };
                  };
                  default = { };
                  description = "Native process integration settings.";
                };
              };
            };
            default = { };
            description = "Integration configurations for Headplane to interact with Headscale.";
          };

          oidc = mkOption {
            type = types.submodule {
              options = {
                issuer = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  description = "URL to OpenID issuer.";
                  example = "https://provider.example.com/issuer-url";
                };

                client_id = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  description = "The client ID for the OIDC client.";
                  example = "your-client-id";
                };

                client_secret_path = mkOption {
                  type = types.nullOr types.path;
                  default = null;
                  description = ''
                    Path to a file containing the OIDC client secret.
                  '';
                  example = "config.sops.secrets.oidc_client_secret.path";
                };

                disable_api_key_login = mkOption {
                  type = types.bool;
                  default = false;
                  description = "Whether to disable API key login.";
                };

                token_endpoint_auth_method = mkOption {
                  type = types.enum [
                    "client_secret_post"
                    "client_secret_basic"
                    "client_secret_jwt"
                  ];
                  default = "client_secret_post";
                  description = "The token endpoint authentication method.";
                };

                headscale_api_key_path = mkOption {
                  type = types.nullOr types.path;
                  default = null;
                  description = ''
                    Path to a file containing the Headscale API key.
                  '';
                  example = "config.sops.secrets.headscale_api_key.path";
                };

                redirect_uri = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  description = ''
                    This should point to your publicly accessible URL
                    for your Headplane instance with /admin/oidc/callback.
                  '';
                  example = "https://headscale.example.com/admin/oidc/callback";
                };

                user_storage_file = mkOption {
                  type = types.path;
                  default = "/var/lib/headplane/users.json";
                  description = ''
                    Path to a file containing the users and their permissions for Headplane.
                  '';
                  example = "/var/lib/headplane/users.json";
                };

                profile_picture_source = mkOption {
                  type = types.enum [
                    "oidc"
                    "gravatar"
                  ];
                  default = "oidc";
                  description = "Source for user profile pictures.";
                };

                strict_validation = mkOption {
                  type = types.bool;
                  default = true;
                  description = "Enable strict validation of OIDC configuration.";
                };

                scope = mkOption {
                  type = types.str;
                  default = "openid email profile";
                  description = "OIDC scope to request.";
                };

                extra_params = mkOption {
                  type = types.nullOr (types.attrsOf types.str);
                  default = null;
                  description = "Extra parameters to send to the OIDC provider.";
                  example = {
                    prompt = "consent";
                  };
                };

                authorization_endpoint = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  description = "Custom authorization endpoint URL.";
                  example = "https://provider.example.com/authorize";
                };

                token_endpoint = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  description = "Custom token endpoint URL.";
                  example = "https://provider.example.com/token";
                };

                userinfo_endpoint = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  description = "Custom userinfo endpoint URL.";
                  example = "https://provider.example.com/userinfo";
                };
              };
            };
            default = { };
            description = "OIDC Configuration for authentication.";
          };
        };
      };
      default = { };
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];
      etc."headplane/config.yaml".source = "${settingsFile}";
    };

    systemd.services.headplane = {
      description = "Headscale Web UI";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
        config.systemd.services.headscale.name
      ];
      requires = [ config.systemd.services.headscale.name ];

      environment = {
        HEADPLANE_DEBUG_LOG = toString cfg.debug;
      };
      serviceConfig = {
        User = config.services.headscale.user;
        Group = config.services.headscale.group;
        StateDirectory = "headplane";

        ExecStart = lib.getExe cfg.package;
        Restart = "always";
        RestartSec = 5;

        # TODO: Harden `systemd` security according to the "The Principle of Least Power".
        # See: `$ systemd-analyze security headplane`.
      };
    };
  };
}
