# Tumbler

{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let

  cfg = config.services.tumbler;

in

{

  imports = [
    (mkRemovedOptionModule [ "services" "tumbler" "package" ] "")
  ];

  meta = with lib; {
    maintainers = with maintainers; [ ] ++ teams.pantheon.members;
  };

  ###### interface

  options = {

    services.tumbler = {

      enable = mkEnableOption "Tumbler, A D-Bus thumbnailer service";

    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs.xfce; [
      tumbler
    ];

    services.dbus.packages = with pkgs.xfce; [
      tumbler
    ];

  };

}
