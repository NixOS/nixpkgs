{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.services.picom;
in {
  options.services.picom = {
    enable = mkEnableOption "picom, a compositor for X11";

    package = mkOption {
      type = types.package;
      default = pkgs.picom;
      defaultText = literalExpression "pkgs.picom";
      description = "The picom package to use.";
    };

    settings = mkOption {
      type = formats.libconfig.type;
      default = { };
      description = "Picom configuration in libconfig format.";
      example = literalExpression ''
        {
          backend = "glx";
          vsync = true;
          "corner-radius" = 10;
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."xdg/picom/picom.conf".source =
      formats.libconfig.generate "picom.conf" cfg.settings;

    systemd.user.services.picom = {
      description = "Picom Compositor";
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/picom --config /etc/xdg/picom/picom.conf";
        Restart = "on-failure";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ rnhmjoj ];
}
