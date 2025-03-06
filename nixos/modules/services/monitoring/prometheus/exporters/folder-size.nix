{ config, lib, pkgs, options, utils }:
let
  cfg = config.services.prometheus.exporters.folder-size;

  settingsFormat = pkgs.formats.json { };
  settingsFile = settingsFormat.generate "config.json" (builtins.filter (folder: builtins.hasAttr "path" folder) cfg.folders);
in
{
  port = 9974;
  extraOpts = {
    folders = lib.mkOption {
      description = "Folders to Scan";
      type = lib.types.listOf (lib.types.submodule {
        options = {
          path = lib.mkOption {
            description = "The starting analysis path.";
            type = lib.types.str;
          };
          explode_depth = lib.mkOption {
            description = ''
              This setting controls how deep the folder explosion will go.
              -1 means no limit.
              0 means no explosion.
            '';
            type = lib.types.int;
            default = 0;
          };
          sum_remaining_subfolders = lib.mkOption {
            description = ''This setting specifies if the last exploded folder size should include the subfolders.'';
            type = lib.types.bool;
            default = false;
          };
          user = lib.mkOption {
            description = "Folders belonging to this user you want to specifically label.";
            type = lib.types.nullOr lib.types.str;
            default = null;
          };
        };
      });
    };

    background = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = ''
        Enables the async storage calculation.
        The value specifies how often (in seconds) the calculation will be done.
        If not specified, the values will be calculated synchronously at each HTTP Get.
      '';
    };

    verbose = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''Enable verbose logging of service.'';
    };

    directory = {
      root = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib";
        description = "Parent path of working directory";
      };
      folder = lib.mkOption {
        type = lib.types.str;
        default = "prometheus-folder-size-exporter";
        description = "Working Directory name";
      };
    };
  };

  serviceOpts = {
    serviceConfig = {
      StateDirectory = cfg.directory.folder;
      WorkingDirectory = "${cfg.directory.root}/${cfg.directory.folder}";
      ExecStart = "${pkgs.writeShellScript "setup-cfg" ''
        ${pkgs.prometheus-folder-size-exporter}/bin/prometheus_folder_size_exporter \
          -p ${toString cfg.port} \
          -i ${settingsFile} \
          ${lib.optionalString (cfg.background > 0) "-b ${toString cfg.background}"} ${lib.optionalString cfg.verbose "-v"}
      ''}";
    };
  };
}
