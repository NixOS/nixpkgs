{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    types
    ;

  inherit (lib.modules)
    mkIf
    ;

  inherit (lib.options)
    mkEnableOption
    mkOption
    literalExpression
    ;

  cfg = config.services.ax25.axlisten;
in
{
  options = {

    services.ax25.axlisten = {

      enable = mkEnableOption "AX.25 axlisten daemon";

      package = mkOption {
        type = types.package;
        default = pkgs.ax25-apps;
        defaultText = literalExpression "pkgs.ax25-apps";
        description = "The ax25-apps package to use.";
      };

      config = mkOption {
        type = types.str;
        default = "-art";
        description = ''
          Options that will be passed to the axlisten daemon.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    systemd.services.axlisten = {
      description = "AX.25 traffic monitor";
      wantedBy = [ "multi-user.target" ];
      after = [ "ax25-axports.target" ];
      requires = [ "ax25-axports.target" ];
      serviceConfig = {
        Type = "exec";
        ExecStart = "${cfg.package}/bin/axlisten ${cfg.config}";
      };
    };
  };
}
