{ config, lib, pkgs, ... }:

with lib;
let cfg = config.services.phylactery;
in {
  options.services.phylactery = {
    enable = mkEnableOption (lib.mdDoc "Whether to enable Phylactery server");

    host = mkOption {
      type = types.str;
      default = "localhost";
      description = lib.mdDoc "Listen host for Phylactery";
    };

    port = mkOption {
      type = types.port;
      description = lib.mdDoc "Listen port for Phylactery";
    };

    library = mkOption {
      type = types.path;
      description = lib.mdDoc "Path to CBZ library";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.phylactery;
      defaultText = literalExpression "pkgs.phylactery";
      description = lib.mdDoc "The Phylactery package to use";
    };
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
