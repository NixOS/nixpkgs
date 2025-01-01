{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.services.phylactery;
in
{
  options.services.phylactery = {
    enable = mkEnableOption "Phylactery server";

    host = mkOption {
      type = types.str;
      default = "localhost";
      description = "Listen host for Phylactery";
    };

    port = mkOption {
      type = types.port;
      description = "Listen port for Phylactery";
    };

    library = mkOption {
      type = types.path;
      description = "Path to CBZ library";
    };

    package = mkPackageOption pkgs "phylactery" { };
  };

  config = mkIf cfg.enable {
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

  meta.maintainers = with maintainers; [ McSinyx ];
}
