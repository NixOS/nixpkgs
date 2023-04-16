{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.services.clipmon;
in {
  options.services.clipmon = {
    enable = mkEnableOption (mdDoc "clipmon");
  };

  config = mkIf cfg.enable {
    systemd.user.services.clipmon = {
      description = "Clipboard monitor for Wayland";
      documentation = [ "https://sr.ht/~whynothugo/clipmon" ];
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        Restart = "on-failure";
        ExecStart = "${pkgs.clipmon}/bin/clipmon";
      };
    };
  };

  meta.maintainers = with maintainers; [ ma27 ];
}
