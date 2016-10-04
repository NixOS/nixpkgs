{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.xbanish;

in {
  options.services.xbanish = {

    enable = mkEnableOption "xbanish";

    arguments = mkOption {
      description = "Arguments to pass to xbanish command";
      default = "";
      example = "-d -i shift";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.xbanish = {
      description = "xbanish hides the mouse pointer";
      wantedBy = [ "default.target" ];
      serviceConfig.ExecStart = ''
        ${pkgs.xbanish}/bin/xbanish ${cfg.arguments}
      '';
      serviceConfig.Restart = "always";
    };
  };
}
