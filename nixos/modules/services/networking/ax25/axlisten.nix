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
    mkPackageOption
    ;

  cfg = config.services.ax25.axlisten;
in
{
  options = {

    services.ax25.axlisten = {

      enable = mkEnableOption "AX.25 axlisten daemon";

      package = mkPackageOption pkgs "ax25-apps" { };

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
