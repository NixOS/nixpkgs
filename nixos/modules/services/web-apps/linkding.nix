{
  config,
  lib,
  options,
  pkgs,
  ...
}:
{
  options.services.linkding = {
    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/etc/linkding/data";
      description = "The directory where linkding stores its data files.";
    };

    enable = lib.mkEnableOption "linkding service";

    package = lib.mkPackageOption pkgs "linkding" { };

    port = lib.mkOption {
      default = 9090;
      description = "Port on which linkding will listen for connections.";
      type = lib.types.port;
    };
  };

  config = lib.mkIf config.services.linkding.enable {
    systemd.services.linkding = {
      description = "linkding";

      environment = {
        LD_HOST_DATA_DIR = config.services.linkding.dataDir;
        LD_HOST_PORT = builtins.toString config.services.linkding.port;
      };

      serviceConfig.ExecStart = lib.getExe config.services.linkding.package;
    };
  };

  meta.maintainers = [ lib.maintainers.l0b0 ];
}
