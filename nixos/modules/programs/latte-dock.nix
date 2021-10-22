{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.latte-dock;
in
{
  meta.maintainers = [ maintainers.diffumist ];

  ###### interface
  options.programs.latte-dock = {
    enable = mkEnableOption "Latte Dock";
  };

  ###### implementation
  config = mkIf cfg.enable {
    systemd.user.services.latte-dock = {
      script = "${pkgs.latte-dock}/bin/latte-dock";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
    };
  };
}
