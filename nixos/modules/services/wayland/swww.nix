{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.swww;
in
{
  options.services.swww.enable = mkEnableOption (lib.mdDoc "wallpaper daemon");

  config = mkIf cfg.enable {
    systemd.user.services."swww" = {
      enable = true;
      description = "wallpaper daemon";
      after = [ "graphical-session.target" ];
      requires = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "notify";
        ExecStart = "${pkgs.swww}/bin/swww init --no-daemon";
        NotifyAccess = "all";
      };
      path = [ pkgs.swww ];
    };
  };

  meta.maintainers = with lib.maintainers; [ b3nj5m1n ];

}
