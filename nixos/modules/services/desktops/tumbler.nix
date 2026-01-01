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

  meta = {
    maintainers = [ ] ++ lib.teams.pantheon.members;
  };

  ###### interface

  options = {

    services.tumbler = {

      enable = lib.mkEnableOption "Tumbler, A D-Bus thumbnailer service";

    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

<<<<<<< HEAD
    environment.systemPackages = with pkgs; [
      tumbler
    ];

    services.dbus.packages = with pkgs; [
=======
    environment.systemPackages = with pkgs.xfce; [
      tumbler
    ];

    services.dbus.packages = with pkgs.xfce; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      tumbler
    ];

  };

}
