{ config, lib, pkgs, utils, ... }:
let
  inherit (lib) mkOption types mdDoc;
  cfg = config.services.prometheus.exporters.fritz;
  yaml = pkgs.formats.yaml { };
  configFile = yaml.generate "fritz-exporter.yaml" cfg.settings;
in
{
  port = 9787;

  extraOpts = {
    settings = mkOption {
      description = mdDoc "Configuration settings for fritz-exporter.";
      type = types.submodule {
        freeformType = yaml.type;

        options = {
          # Pull existing port option into config file.
          port = mkOption {
            type = types.port;
            default = cfg.port;
            internal = true;
            visible = false;
          };
          # Pull existing listen address option into config file.
          listen_address = mkOption {
            type = types.str;
            default = cfg.listenAddress;
            internal = true;
            visible = false;
          };
          log_level = mkOption {
            type = types.enum [ "DEBUG" "INFO" "WARNING" "ERROR" "CRITICAL" ];
            default = "INFO";
            description = mdDoc ''
              Log level to use for the exporter.
            '';
          };
          devices = mkOption {
            default = [];
            description = "Fritz!-devices to monitor using the exporter.";
            type = with types; listOf (submodule {
              freeformType = yaml.type;

              options = {
                name = mkOption {
                  type = types.str;
                  default = "";
                  description = mdDoc ''
                    Name to use for the device.
                  '';
                };
                hostname = mkOption {
                  type = types.str;
                  default = "fritz.box";
                  description = mdDoc ''
                    Hostname under which the target device is reachable.
                  '';
                };
                username = mkOption {
                  type = types.str;
                  description = mdDoc ''
                    Username to authenticate with the target device.
                  '';
                };
                password_file = mkOption {
                  type = types.path;
                  description = mdDoc ''
                    Path to a file which contains the password to authenticate with the target device.
                    Needs to be readable by the user the exporter runs under.
                  '';
                };
                host_info = mkOption {
                  type = types.bool;
                  description = mdDoc ''
                    Enable extended host info for this device. *Warning*: This will heavily increase scrape time.
                  '';
                  default = false;
                };
              };
            });
          };
        };
      };
    };
  };

  serviceOpts = {
    serviceConfig = {
      ExecStart = utils.escapeSystemdExecArgs ([
        (lib.getExe pkgs.fritz-exporter)
        "--config" configFile
      ] ++ cfg.extraFlags);
      DynamicUser = false;
    };
  };
}
