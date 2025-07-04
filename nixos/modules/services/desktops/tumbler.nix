# Tumbler
{
  config,
  pkgs,
  lib,
  ...
}:
let

  cfg = config.services.tumbler;

in

{

  imports = [
    (lib.mkRemovedOptionModule [ "services" "tumbler" "package" ] "")
  ];

  meta = with lib; {
    maintainers = with lib.maintainers; [ ] ++ lib.teams.pantheon.members;
  };

  ###### interface

  options = {

    services.tumbler = {

      enable = lib.mkEnableOption "Tumbler, A D-Bus thumbnailer service";

    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs.xfce; [
      tumbler
    ];

    services.dbus.packages = with pkgs.xfce; [
      tumbler
    ];

  };

}
