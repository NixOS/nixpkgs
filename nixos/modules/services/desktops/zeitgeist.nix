# Zeitgeist
{
  config,
  lib,
  pkgs,
  ...
}:
{

<<<<<<< HEAD
  meta = {
    maintainers = [ ] ++ lib.teams.pantheon.members;
=======
  meta = with lib; {
    maintainers = with maintainers; [ ] ++ teams.pantheon.members;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  ###### interface

  options = {
    services.zeitgeist = {
      enable = lib.mkEnableOption "zeitgeist, a service which logs the users' activities and events";
    };
  };

  ###### implementation

  config = lib.mkIf config.services.zeitgeist.enable {

    environment.systemPackages = [ pkgs.zeitgeist ];

    services.dbus.packages = [ pkgs.zeitgeist ];

    systemd.packages = [ pkgs.zeitgeist ];
  };
}
