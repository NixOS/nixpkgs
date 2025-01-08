{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xbanish;

in
{
  options.services.xbanish = {

    enable = lib.mkEnableOption "xbanish";

    arguments = lib.mkOption {
      description = "Arguments to pass to xbanish command";
      default = "";
      example = "-d -i shift";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.xbanish = {
      description = "xbanish hides the mouse pointer";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig.ExecStart = ''
        ${pkgs.xbanish}/bin/xbanish ${cfg.arguments}
      '';
      serviceConfig.Restart = "always";
    };
  };
}
