{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.xfconf;

in
{
  meta = {
    maintainers = lib.teams.xfce.members;
  };

  options = {
    programs.xfconf = {
      enable = lib.mkEnableOption "Xfconf, the Xfce configuration storage system";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
<<<<<<< HEAD
      pkgs.xfconf
    ];

    services.dbus.packages = [
      pkgs.xfconf
=======
      pkgs.xfce.xfconf
    ];

    services.dbus.packages = [
      pkgs.xfce.xfconf
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ];
  };
}
