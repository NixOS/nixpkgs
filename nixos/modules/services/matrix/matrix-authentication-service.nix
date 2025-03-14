{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    concatMapStringsSep
    filterAttrsRecursive
    getExe
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optional
    optionalAttrs
    types
    ;

  cfg = config.services.matrix-authentication-service;
  format = pkgs.formats.yaml { };

  # remove null values from the final configuration
  finalSettings = filterAttrsRecursive (_: v: v != null) cfg.settings;
  configFile = format.generate "config.yaml" finalSettings;
in
{
  options.services.matrix-authentication-service = {
    enable = mkEnableOption "matrix authentication service";

    package = mkPackageOption pkgs "matrix-authentication-service" { };

    settings = mkOption {
      default = { };
      description = ''
        The primary mas configuration. See the
        [configuration reference](https://element-hq.github.io/matrix-authentication-service/usage/configuration.html)
        for possible values.

        Secrets should be passed in by using the `extraConfigFiles` option.
      '';
      type = types.submodule {
        freeformType = format.type;

        options = {
          http.public_base = mkOption {
            type = types.str;
            default = "http://[::]:8080/";
            description = ''
              Public URL base used when building absolute public URLs.
            '';
          };
          http.issuer = mkOption {
            type = types.str;
            default = "http://[::]:8080/";
            description = ''
              OIDC issuer advertised by the service.
            '';
          };
          http.trusted_proxies = mkOption {
            type = types.listOf (types.str);
            default = [
              "127.0.0.1/8"
              "::1/128"
            ];
            description = ''
              MAS can infer the client IP address from the X-Forwarded-For header. It will trust the value for this header only if the request comes from a trusted reverse proxy listed here.
            '';
          };
          http.listeners = mkOption {
            type = types.listOf (
              types.submodule {
                freeformType = format.type;
                options = {
                  name = mkOption {
                    type = types.str;
                    example = "web";
                    description = ''
                      The name of the listener, used in logs and metrics.
                    '';
                  };
                  proxy_protocol = mkOption {
                    type = types.bool;
                    description = ''
                      Whether to enable the PROXY protocol on the listener.
                    '';
                  };
                  resources = mkOption {
                    type = types.listOf (
                      types.submodule {
                        freeformType = format.type;
                        options = {
                          name = mkOption {
                            type = types.str;
                            description = ''
                              Serve the given folder.
                            '';
                          };
                          path = mkOption {
                            type = types.str;
                            default = "";
                            description = ''
                              Serve the folder on the given path.
                            '';
                          };
                        };
                      }
                    );
                    description = ''
                      List of resources to serve.
                    '';
                  };
                  binds = mkOption {
                    type = types.listOf (
                      types.submodule {
                        freeformType = format.type;
                        options = {
                          host = mkOption {
                            type = types.str;
                            description = ''
                              Listen on the given host.
                            '';
                          };
                          port = mkOption {
                            type = types.ints.unsigned;
                            description = ''
                              Listen on the given port.
                            '';
                          };
                        };
                      }
                    );
                    description = ''
                      List of addresses and ports to listen to.
                    '';
                  };
                };
              }
            );
            defaultText = ''
              {
                name = "web";
                resources = [
                  { name = "discovery"; }
                  { name = "human"; }
                  { name = "oauth"; }
                  { name = "compat"; }
                  { name = "graphql"; }
                  {
                    name = "assets";
                    path = "''${cfg.package}/share/matrix-authentication-service/assets";
                  }
                ];
                binds = [
                  {
                    host = "0.0.0.0";
                    port = 8080;
                  }
                ];
                proxy_protocol = false;
              }
              {
                name = "internal";
                resources = [
                  { name = "health"; }
                ];
                binds = [
                  {
                    host = "0.0.0.0";
                    port = 8081;
                  }
                ];
                proxy_protocol = false;
              }
            '';
            description = ''
              Each listener can serve multiple resources, and listen on multiple TCP ports or UNIX sockets.
            '';
          };

          database.uri = mkOption {
            type = types.str;
            default = "postgresql:///matrix-authentication-service?host=/run/postgresql";
            description = ''
              The postgres connection string.
              Refer to <https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING>.
            '';
          };

          database.max_connections = mkOption {
            type = types.ints.unsigned;
            default = 10;
            description = ''
              Maximum number of connections for the connection pool.
            '';
          };

          database.min_connections = mkOption {
            type = types.ints.unsigned;
            default = 0;
            description = ''
              Minimum number of connections for the connection pool.
            '';
          };

          database.connect_timeout = mkOption {
            type = types.ints.unsigned;
            default = 30;
            description = ''
              Connection timeout for the connection pool.
            '';
          };

          database.idle_timeout = mkOption {
            type = types.ints.unsigned;
            default = 600;
            description = ''
              Idle timeout for the connection pool.
            '';
          };

          database.max_lifetime = mkOption {
            type = types.ints.unsigned;
            default = 1800;
            description = ''
              Maximum lifetime for the connection pool.
            '';
          };

          passwords.enabled = mkOption {
            type = types.bool;
            default = true;
            description = ''
              Whether to enable the password database. If disabled, users will only be able to log in using upstream OIDC providers.
            '';
          };

          passwords.schemes = mkOption {
            type = types.listOf (
              types.submodule {
                freeformType = format.type;
                options = {
                  version = mkOption {
                    type = types.ints.unsigned;
                    description = ''
                      Password scheme version.
                    '';
                  };
                  algorithm = mkOption {
                    type = types.str;
                    description = ''
                      Password scheme algorithm.
                    '';
                  };
                };
              }
            );
            default = [
              {
                version = 1;
                algorithm = "argon2id";
              }
            ];
            description = ''
              List of password hashing schemes being used. Only change this if you know what you're doing.
            '';
          };

          passwords.minimum_complexity = mkOption {
            type = types.ints.unsigned;
            default = 3;
            description = ''
              Minimum complexity required for passwords, estimated by the zxcvbn algorithm. Must be between 0 and 4, default is 3. See https://github.com/dropbox/zxcvbn#usage for more information.
            '';
          };

          matrix.homeserver = mkOption {
            type = types.str;
            default = "";
            description = ''
              Corresponds to the server_name in the Synapse configuration file.
            '';
          };
          matrix.secret = mkOption {
            type = types.str;
            default = "";
            description = ''
              A shared secret the service will use to call the homeserver admin API.
            '';
          };
          matrix.endpoint = mkOption {
            type = types.str;
            default = "";
            description = ''
              The URL to which the homeserver is accessible from the service.
            '';
          };
          upstream_oauth2.providers = mkOption {
            default = null;
            type = types.nullOr (
              types.listOf (
                types.submodule {
                  freeformType = format.type;
                  options = {
                    id = mkOption {
                      type = types.nullOr types.str;
                      example = "01H8PKNWKKRPCBW4YGH1RWV279";
                      default = null;
                      description = ''
                        Unique id for the provider, must be a ULID, and can be generated using online tools like https://www.ulidtools.com
                      '';
                    };
                  };
                }
              )
            );
            description = ''
              Configuration of upstream providers
            '';
          };
        };
      };
    };

    createDatabase = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable and configure `services.postgres` to ensure that the database user `matrix-authentication-service`
        and the database `matrix-authentication-service` exist.
      '';
    };

    extraConfigFiles = mkOption {
      type = types.listOf types.path;
      default = [ ];
      description = ''
        Extra config files to include.

        The configuration files will be included based on the command line
        argument --config. This allows to configure secrets without
        having to go through the Nix store, e.g. based on deployment keys if
        NixOps is in use.
      '';
    };

    serviceDependencies = mkOption {
      type = with types; listOf str;
      default = optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit;
      defaultText = lib.literalExpression ''
        lib.optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit
      '';
      description = ''
        List of Systemd services to require and wait for when starting the application service,
        such as the Matrix homeserver if it's running on the same host.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.postgresql = optionalAttrs cfg.createDatabase {
      enable = true;
      ensureDatabases = [ "matrix-authentication-service" ];
      ensureUsers = [
        {
          name = "matrix-authentication-service";
          ensureDBOwnership = true;
        }
      ];
    };

    users.users.matrix-authentication-service = {
      group = "matrix-authentication-service";
      isSystemUser = true;
    };
    users.groups.matrix-authentication-service = { };

    services.matrix-authentication-service.settings.http.listeners = mkDefault [
      {
        name = "web";
        resources = [
          { name = "discovery"; }
          { name = "human"; }
          { name = "oauth"; }
          { name = "compat"; }
          { name = "graphql"; }
          {
            name = "assets";
            path = "${cfg.package}/share/matrix-authentication-service/assets";
          }
        ];
        binds = [
          {
            host = "0.0.0.0";
            port = 8080;
          }
        ];
        proxy_protocol = false;
      }
      {
        name = "internal";
        resources = [
          { name = "health"; }
        ];
        binds = [
          {
            host = "0.0.0.0";
            port = 8081;
          }
        ];
        proxy_protocol = false;
      }
    ];

    systemd.services.matrix-authentication-service = rec {
      after = optional cfg.createDatabase "postgresql.service" ++ cfg.serviceDependencies;
      wants = after;
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "matrix-authentication-service";
        Group = "matrix-authentication-service";
        ExecStartPre = [
          (
            "+"
            + (pkgs.writeShellScript "matrix-authentication-service-check-config" ''
              ${getExe cfg.package} config check \
                ${concatMapStringsSep " " (x: "--config ${x}") ([ configFile ] ++ cfg.extraConfigFiles)}
            '')
          )
        ];
        ExecStart = ''
          ${getExe cfg.package} server \
            ${concatMapStringsSep " " (x: "--config ${x}") ([ configFile ] ++ cfg.extraConfigFiles)}
        '';
        Restart = "on-failure";
        RestartSec = "1s";
      };
    };
  };
}
