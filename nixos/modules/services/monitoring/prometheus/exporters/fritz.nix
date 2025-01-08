{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.prometheus.exporters.fritz;
  yaml = pkgs.formats.yaml { };
  configFile = yaml.generate "fritz-exporter.yaml" cfg.settings;
in
{
  port = 9787;

  extraOpts = {
    settings = lib.mkOption {
      description = "Configuration settings for fritz-exporter.";
      type = lib.types.submodule {
        freeformType = yaml.type;

        options = {
          # Pull existing port option into config file.
          port = lib.mkOption {
            type = lib.types.port;
            default = cfg.port;
            internal = true;
            visible = false;
          };
          # Pull existing listen address option into config file.
          listen_address = lib.mkOption {
            type = lib.types.str;
            default = cfg.listenAddress;
            internal = true;
            visible = false;
          };
          log_level = lib.mkOption {
            type = lib.types.enum [
              "DEBUG"
              "INFO"
              "WARNING"
              "ERROR"
              "CRITICAL"
            ];
            default = "INFO";
            description = ''
              Log level to use for the exporter.
            '';
          };
          devices = lib.mkOption {
            default = [ ];
            description = "Fritz!-devices to monitor using the exporter.";
            type =
              lib.types.listOf (lib.types.submodule {
                freeformType = yaml.type;

                options = {
                  name = lib.mkOption {
                    type = lib.types.str;
                    default = "";
                    description = ''
                      Name to use for the device.
                    '';
                  };
                  hostname = lib.mkOption {
                    type = lib.types.str;
                    default = "fritz.box";
                    description = ''
                      Hostname under which the target device is reachable.
                    '';
                  };
                  username = lib.mkOption {
                    type = lib.types.str;
                    description = ''
                      Username to authenticate with the target device.
                    '';
                  };
                  password_file = lib.mkOption {
                    type = lib.types.path;
                    description = ''
                      Path to a file which contains the password to authenticate with the target device.
                      Needs to be readable by the user the exporter runs under.
                    '';
                  };
                  host_info = lib.mkOption {
                    type = lib.types.bool;
                    description = ''
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
      ExecStart = utils.escapeSystemdExecArgs (
        [
          (lib.getExe pkgs.fritz-exporter)
          "--config"
          configFile
        ]
        ++ cfg.extraFlags
      );
      DynamicUser = false;
    };
  };
}
