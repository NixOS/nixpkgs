{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.xfconf;

in {
  meta = {
    maintainers = teams.xfce.members;
  };

  options = {
    programs.xfconf = {
      enable = mkEnableOption "Xfconf, the Xfce configuration storage system";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.xfce.xfconf
    ];

    services.dbus.packages = [
      pkgs.xfce.xfconf
    ];
  };
}
