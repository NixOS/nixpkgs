{ config, lib, pkgs, ... }:

let
  cfg = config.services.systembus-notify;

  inherit (lib) mkEnableOption mkIf;

in
{
  options.services.systembus-notify = {
    enable = mkEnableOption "System bus notification support";
  };

  config = mkIf cfg.enable {
    systemd = {
      packages = with pkgs; [ systembus-notify ];

      user.services.systembus-notify.wantedBy = [ "graphical-session.target" ];
    };
  };
}
