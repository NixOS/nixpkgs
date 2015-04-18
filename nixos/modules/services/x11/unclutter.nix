{ config, lib, pkgs, ... }:
with lib;
let cfg = config.services.unclutter;
in {
  options = {
    services.unclutter.enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Enable unclutter to hide your mouse cursor when inactive";
    };

    services.unclutter.arguments = mkOption {
      description = "Arguments to pass to unclutter command";
      default = "-idle 1";
      type = types.uniq types.string;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.unclutter = {
      description = "unclutter";
      requires = [ "display-manager.service" ];
      after = [ "display-manager.service" ];
      wantedBy = [ "graphical.target" ];
      serviceConfig.ExecStart = ''
        ${pkgs.unclutter}/bin/unclutter ${cfg.arguments}
      '';
      environment = { DISPLAY = ":0"; };
      serviceConfig.Restart = "always";
    };
  };
}
