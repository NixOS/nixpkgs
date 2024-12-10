{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.clipmenu;
in
{

  options.services.clipmenu = {
    enable = mkEnableOption "clipmenu, the clipboard management daemon";

    package = mkPackageOption pkgs "clipmenu" { };
  };

  config = mkIf cfg.enable {
    systemd.user.services.clipmenu = {
      enable = true;
      description = "Clipboard management daemon";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig.ExecStart = "${cfg.package}/bin/clipmenud";
    };

    environment.systemPackages = [ cfg.package ];
  };
}
