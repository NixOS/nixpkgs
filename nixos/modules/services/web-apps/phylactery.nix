{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.phylactery;
in
{
  options.services.phylactery = {
    enable = lib.mkEnableOption "Phylactery server";

    host = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = "Listen host for Phylactery";
    };

    port = lib.mkOption {
      type = lib.types.port;
      description = "Listen port for Phylactery";
    };

    library = lib.mkOption {
      type = lib.types.path;
      description = "Path to CBZ library";
    };

    package = lib.mkPackageOption pkgs "phylactery" { };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.phylactery = {
      environment = {
        PHYLACTERY_ADDRESS = "${cfg.host}:${toString cfg.port}";
        PHYLACTERY_LIBRARY = "${cfg.library}";
      };

      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ConditionPathExists = cfg.library;
        DynamicUser = true;
        ExecStart = "${cfg.package}/bin/phylactery";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ McSinyx ];
}
