{
  lib,
  pkgs,
  config,
  ...
}:
let
  format = pkgs.formats.hcl1 { };
  cfg = config.services.spire.server;
in
{
  meta.maintainers = [ lib.maintainers.arianvp ];

  imports = [ ./server-tpm.nix ];

  options.services.spire.server = {
    enable = lib.mkEnableOption "SPIRE Server";

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to open firewall";
      default = false;
    };

    settings = lib.mkOption {
      description = ''
        SPIRE Server configuration file options. See [the documentation](https://spiffe.io/docs/latest/deploying/spire_server/) for all available options.
      '';
      type = lib.types.submodule {
        freeformType = format.type;
        options = {
          server = {
            trust_domain = lib.mkOption {
              type = lib.types.str;
              description = "The trust domain that this server belongs to";
              example = "example.com";
            };
            data_dir = lib.mkOption {
              type = lib.types.str;
              description = "The directory where SPIRE server stores its data";
              default = "$STATE_DIRECTORY";
            };
            socket_path = lib.mkOption {
              type = lib.types.str;
              default = "/run/spire/server/private/api.sock";
              description = "Path to bind the SPIRE Server API Socket to";
            };
            bind_address = lib.mkOption {
              type = lib.types.str;
              default = "[::]";
              description = "The address on which the SPIRE server is listening";
            };
            bind_port = lib.mkOption {
              type = lib.types.port;
              default = 8081;
              description = "The port on which the SPIRE server is listening";
            };
          };
          plugins = lib.mkOption {
            description = ''
              Built-in plugin types can be found at [the plugin types documentation](https://spiffe.io/docs/latest/deploying/spire_server/#plugin-types).
              See [plugin configuration](https://spiffe.io/docs/latest/deploying/spire_server/#plugin-configuration) for options and how to configure external plugins.
            '';
            type = lib.types.submodule {
              freeformType = format.type;
              options.NodeAttestor = lib.mkOption {
                default = { };
                description = ''
                  NodeAttestor plugins implement validation logic for nodes attempting to assert their identity.
                  They are generally paired with an agent plugin of the same type.
                  See [the documentation](https://spiffe.io/docs/latest/deploying/spire_server/#nodeattestor)
                  for the list of built-in NodeAttestor plugins.
                '';
                type = lib.types.submodule {
                  freeformType = format.type;
                  options.join_token = lib.mkOption {
                    default = null;
                    description = "Join token based node attestation.";
                    type = lib.types.nullOr (
                      lib.types.submodule {
                        freeformType = format.type;
                        options.plugin_data = lib.mkOption {
                          type = format.type;
                          default = { };
                          description = "Plugin data for the join_token NodeAttestor.";
                        };
                      }
                    );
                  };
                };
              };
            };
            example = {
              KeyManager.memory.plugin_data = { };
              DataStore.sql.plugin_data = {
                database_type = "sqlite3";
                connection_string = "$STATE_DIRECTORY/datastore.sqlite3";
              };
              NodeAttestor.join_token.plugin_data = { };
            };
          };
        };
      };
    };

    configFile = lib.mkOption {
      type = lib.types.path;
      default = format.generate "server.conf" (lib.filterAttrsRecursive (_: v: v != null) cfg.settings);
      defaultText = "Config file generated from services.spire.server.settings";
      description = ''
        Path to the SPIRE server configuration file. See [the documentation](https://spiffe.io/docs/latest/deploying/spire_server/) for more information.
      '';
    };

    expandEnv = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Expand environment variables in services.spire.server.settings and services.spire.server.configFile";
    };

    package = lib.mkPackageOption pkgs "spire" { };

  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.settings.server.bind_port ];
    environment.systemPackages = [ cfg.package ];
    systemd.services.spire-server = {
      wantedBy = [ "multi-user.target" ];
      description = "SPIRE Server";
      documentation = [ "https://spiffe.io/docs/latest/deploying/spire_server/" ];
      serviceConfig = {
        ExecStart =
          "${lib.getExe' cfg.package "spire-server"} run "
          + lib.cli.toCommandLineShellGNU { } {
            inherit (cfg) expandEnv;
            config = cfg.configFile;
          };
        Restart = "on-failure";
        StateDirectory = "spire/server";
        StateDirectoryMode = "0700";
        RuntimeDirectory = "spire/server";
        DynamicUser = true;
        UMask = "0027";
        # TODO: hardening
      };
    };
  };
}
