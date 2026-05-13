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
  settingsFormat = pkgs.formats.yaml { };
  filterSettings = lib.converge (
    filterAttrsRecursive (
      _: v:
      !lib.elem v [
        { }
        null
      ]
    )
  );
  agentSettings = cfg.settings.integration.agent;
  settings = cfg.settings // {
    integration = cfg.settings.integration // {
      agent = if agentSettings == null || !agentSettings.enabled then null else agentSettings;
    };
  };
  settingsFile = settingsFormat.generate "headplane-config.yaml" (filterSettings settings);
in
{
  options.services.headplane = {
    enable = mkEnableOption "Headplane";
    package = mkPackageOption pkgs "headplane" { };

    agent.package = mkPackageOption pkgs "headplane-agent" { };

    debug = mkEnableOption "debug logging";

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

                base_url = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  description = ''
                    The base URL for Headplane. Used for OIDC redirect callback URL
                    detection. Should not include the dashboard prefix (/admin).
                  '';
                  example = "https://headplane.example.com";
                };

                cookie_secret_path = mkOption {
                  type = types.nullOr types.path;
                  default = null;
                  description = ''
                    Path to a file containing the cookie secret.
                    The secret must be exactly 32 characters long.
                  '';
                  example = lib.literalExpression "config.sops.secrets.headplane_cookie.path";
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

                cookie_max_age = mkOption {
                  type = types.ints.positive;
                  default = 86400;
                  description = "The maximum age of the session cookie in seconds.";
                };

                cookie_domain = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  description = ''
                    Restrict the cookie to a specific domain.
                    This may not work as expected if not using a reverse proxy.
                  '';
                  example = "example.com";
                };

                data_path = mkOption {
                  type = types.path;
                  default = "/var/lib/headplane";
                  description = ''
                    The path to persist Headplane specific data.
                    All data going forward is stored in this directory, including the internal database and any cache related files.
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
                  example = lib.literalExpression "config.sops.secrets.tls_cert.path";
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

                config_strict = mkEnableOption ''
                  Headplane internally validates the Headscale configuration
                  to ensure that it changes the configuration in a safe way.
                  Disabled by default because it clashes with how the Headplane works in NixOS.
                '';

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
                  type = types.nullOr (
                    types.submodule {
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

                        pre_authkey_path = mkOption {
                          type = types.nullOr types.path;
                          default = null;
                          description = ''
                            Path to a file containing a Headscale pre-auth key for the agent.
                          '';
                          example = lib.literalExpression "config.sops.secrets.headplane_pre_authkey.path";
                        };

                        executable_path = mkOption {
                          type = types.path;
                          readOnly = true;
                          default = "${cfg.agent.package}/bin/hp_agent";
                          defaultText = lib.literalExpression ''"''${config.services.headplane.agent.package}/bin/hp_agent"'';
                          description = ''
                            Path to the headplane agent binary.
                          '';
                        };

                        host_name = mkOption {
                          type = types.str;
                          default = "headplane-agent";
                          description = "Optionally change the name of the agent in the Tailnet.";
                        };

                        cache_ttl = mkOption {
                          type = types.nullOr types.int;
                          default = null;
                          description = ''
                            Deprecated cache TTL for the agent. This option is accepted
                            by Headplane 0.6.2 but has no effect.
                          '';
                        };

                        cache_path = mkOption {
                          type = types.path;
                          default = "/var/lib/headplane/agent_cache.json";
                          description = "The path to store the agent's cache.";
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
                      };
                    }
                  );
                  default = null;
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
            type = types.nullOr (
              types.submodule {
                options = {
                  enabled = mkOption {
                    type = types.bool;
                    default = true;
                    description = ''
                      Explicitly control OIDC availability.
                      Set to false to define OIDC config without enabling it.
                    '';
                  };

                  issuer = mkOption {
                    type = types.str;
                    description = "URL to OpenID issuer.";
                    example = "https://provider.example.com/issuer-url";
                  };

                  client_id = mkOption {
                    type = types.str;
                    description = "The client ID for the OIDC client.";
                    example = "your-client-id";
                  };

                  client_secret_path = mkOption {
                    type = types.nullOr types.path;
                    default = null;
                    description = ''
                      Path to a file containing the OIDC client secret.
                    '';
                    example = lib.literalExpression "config.sops.secrets.oidc_client_secret.path";
                  };

                  headscale_api_key_path = mkOption {
                    type = types.nullOr types.path;
                    default = null;
                    description = ''
                      Path to a file containing the Headscale API key.
                      Required for OIDC authentication.
                    '';
                    example = lib.literalExpression "config.sops.secrets.headscale_api_key.path";
                  };

                  disable_api_key_login = mkOption {
                    type = types.bool;
                    default = false;
                    description = "Whether to disable API key login.";
                  };

                  token_endpoint_auth_method = mkOption {
                    type = types.nullOr (
                      types.enum [
                        "client_secret_post"
                        "client_secret_basic"
                        "client_secret_jwt"
                      ]
                    );
                    default = null;
                    description = ''
                      The token endpoint authentication method.
                      If not set, Headplane will auto-detect the best method
                      and fall back to client_secret_basic.
                    '';
                  };

                  use_pkce = mkOption {
                    type = types.bool;
                    default = false;
                    description = ''
                      Whether to use PKCE when authenticating users.
                      Your OIDC provider must support PKCE and it must be enabled on the client.
                    '';
                  };

                  redirect_uri = mkOption {
                    type = types.nullOr types.str;
                    default = null;
                    description = ''
                      Deprecated OIDC redirect URI. Use services.headplane.settings.server.base_url
                      instead; Headplane derives the callback URL from it.
                    '';
                    example = "https://headplane.example.com/admin/oidc/callback";
                  };

                  strict_validation = mkOption {
                    type = types.nullOr types.bool;
                    default = null;
                    description = ''
                      Deprecated OIDC validation setting. This option is accepted
                      by Headplane 0.6.2 but has no effect.
                    '';
                  };

                  profile_picture_source = mkOption {
                    type = types.enum [
                      "oidc"
                      "gravatar"
                    ];
                    default = "oidc";
                    description = "Source for user profile pictures.";
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

                  user_storage_file = mkOption {
                    type = types.nullOr types.path;
                    default = null;
                    description = ''
                      Deprecated path to the pre-0.6.2 JSON user database.
                      Headplane uses this once to migrate users into its internal database.
                    '';
                    example = "/var/lib/headplane/users.json";
                  };
                };
              }
            );
            default = null;
            description = "OIDC Configuration for authentication.";
          };
        };
      };
      default = { };
    };
  };

  config = mkIf cfg.enable {
    warnings =
      lib.optionals (cfg.settings.oidc != null && cfg.settings.oidc.redirect_uri != null) [
        ''
          services.headplane.settings.oidc.redirect_uri is deprecated by Headplane 0.6.2.
          Use services.headplane.settings.server.base_url instead; Headplane derives
          the OIDC callback URL from it.
        ''
      ]
      ++ lib.optionals (cfg.settings.oidc != null && cfg.settings.oidc.strict_validation != null) [
        ''
          services.headplane.settings.oidc.strict_validation is deprecated and has no effect
          in Headplane 0.6.2.
        ''
      ]
      ++ lib.optionals (cfg.settings.oidc != null && cfg.settings.oidc.user_storage_file != null) [
        ''
          services.headplane.settings.oidc.user_storage_file is deprecated. Headplane 0.6.2
          uses it only to migrate the pre-0.6.2 JSON user database into the internal database.
        ''
      ]
      ++ lib.optionals (agentSettings != null && agentSettings.cache_ttl != null) [
        ''
          services.headplane.settings.integration.agent.cache_ttl is deprecated and has no
          effect in Headplane 0.6.2.
        ''
      ];

    assertions = [
      {
        assertion = config.services.headscale.enable;
        message = ''
          services.headplane requires services.headscale.enable = true.
          The headplane module references the headscale systemd unit
          (in `after`/`requires`) and reads its configFile, port, user,
          and group. Enable headscale or disable headplane.
        '';
      }
      {
        assertion = cfg.settings.server.cookie_secret_path != null;
        message = ''
          services.headplane.settings.server.cookie_secret_path must be set.
          Headplane refuses to start without either `cookie_secret` or
          `cookie_secret_path` (validated at startup, see upstream
          app/server/config/schema.ts). The NixOS module only exposes the
          *_path form to keep secrets out of the world-readable /nix/store.
          Provide a path to a file containing a 32-character secret, e.g.
          via systemd `LoadCredential` or sops-nix.
        '';
      }
      {
        assertion = cfg.settings.oidc == null || cfg.settings.oidc.headscale_api_key_path != null;
        message = ''
          services.headplane.settings.oidc.headscale_api_key_path must be set
          when services.headplane.settings.oidc is non-null. Headplane's OIDC
          flow requires a Headscale API key to mint sessions.
        '';
      }
      {
        assertion =
          agentSettings == null || !agentSettings.enabled || agentSettings.pre_authkey_path != null;
        message = ''
          services.headplane.settings.integration.agent.pre_authkey_path must be set
          when the agent is enabled.
        '';
      }
    ];

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
