{ config, lib, pkgs, ... }:

with lib;
let cfg = config.services.ydotool;
in {
  meta = {
    maintainers = with lib.maintainers; [ kimat ];
  };

  options.services.ydotool = {
    enable = mkEnableOption "ydotool";
  };

  config = mkIf cfg.enable {
    systemd.user.services.ydotool = {
      description = "Ydotool daemon";
      path = with pkgs; [ ydotool ];
      serviceConfig = {
        ExecStart = "${pkgs.ydotool}/bin/ydotoold";
        Restart = "on-failure";
      };
      wantedBy = [ "default.target" ];
    };

    environment.systemPackages = [ pkgs.ydotool ];
  };
}
