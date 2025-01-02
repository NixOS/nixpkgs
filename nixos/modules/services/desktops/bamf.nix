# Bamf
{ config, lib, pkgs, ... }:
{
  meta = with lib; {
    maintainers = with lib.maintainers; [ ] ++ lib.teams.pantheon.members;
  };

  ###### interface

  options = {
    services.bamf = {
      enable = lib.mkEnableOption "bamf";
    };
  };

  ###### implementation

  config = lib.mkIf config.services.bamf.enable {
    services.dbus.packages = [ pkgs.bamf ];

    systemd.packages = [ pkgs.bamf ];
  };
}
