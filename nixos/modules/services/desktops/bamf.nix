# Bamf

{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  meta = with lib; {
    maintainers = with maintainers; [ ] ++ teams.pantheon.members;
  };

  ###### interface

  options = {
    services.bamf = {
      enable = mkEnableOption "bamf";
    };
  };

  ###### implementation

  config = mkIf config.services.bamf.enable {
    services.dbus.packages = [ pkgs.bamf ];

    systemd.packages = [ pkgs.bamf ];
  };
}
