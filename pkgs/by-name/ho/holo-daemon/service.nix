# Non-module dependencies (`importApply`)
{ pkgs }:

# Service module
{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkPackageOption
    mkOption
    types
    ;
  cfg = config.holo-daemon;
  format = pkgs.formats.toml { };
  configFile = format.generate "holod.toml" cfg.settings;
in
{
  _class = "service";

  options.holo-daemon = {
    package = mkPackageOption pkgs "holo-daemon" { };
    settings = mkOption {
      type = types.submodule {
        freeformType = format.type;
        options = {
          user = mkOption {
            type = types.str;
            description = "User for the holo daemon";
            default = "holo";
          };
          group = mkOption {
            type = types.str;
            description = "Group for the holo daemon";
            default = "holo";
          };
          # Needs to be writable by @user or @group
          database_path = mkOption {
            type = types.str;
            description = "Path to the holo database";
            default = "/var/run/holod/holod.db";
          };
          logging = mkOption {
            type = types.submodule {
              freeformType = format.type;
              options = {
                journald = mkOption {
                  type = types.submodule {
                    options = {
                      enabled = mkOption {
                        type = types.bool;
                        description = "Enable or disable journald logging";
                        default = true;
                      };
                    };
                  };
                  description = "Journald logging configuration";
                  default = { };
                };
                file = mkOption {
                  type = types.submodule {
                    options = {
                      enabled = mkOption {
                        type = types.bool;
                        description = "Enable or disable file logging";
                        default = true;
                      };
                      dir = mkOption {
                        type = types.str;
                        description = "Directory for log files";
                        default = "/var/log/";
                      };
                      name = mkOption {
                        type = types.str;
                        description = "Name of the log file";
                        default = "holod.log";
                      };
                    };
                  };
                  description = "File logging configuration";
                  default = { };
                };
              };
            };
            description = "Logging configuration for the holo daemon";
            default = { };
          };
          plugins = mkOption {
            type = types.submodule {
              freeformType = format.type;
              options = {
                grpc = mkOption {
                  type = types.submodule {
                    options = {
                      enabled = mkOption {
                        type = types.bool;
                        description = "Enable or disable gRPC plugin";
                        default = true;
                      };
                      address = mkOption {
                        type = types.str;
                        description = "gRPC server listening address";
                        default = "[::]:50051";
                      };
                    };
                  };
                  description = "gRPC plugin configuration";
                  default = { };
                };
              };
            };
            description = "Plugin configuration for the holo daemon";
            default = { };
          };
        };
      };
      description = "Configuration for the holo daemon";
      default = { };
    };
  };

  config = {
    process.argv = [
      "${cfg.package}/bin/holod"
      "-c"
      configFile
    ];
  };

  meta.maintainers = with lib.maintainers; [ themadbit ];
}
