{ config, pkgs, ... }:

{
  imports = [ ./graphical.nix ];

  users.extraUsers.demo =
    { isNormalUser = true;
      description = "Demo user account";
      extraGroups = [ "wheel" ];
      password = "demo";
      uid = 1000;
    };

  services.xserver.displayManager.sddm.autoLogin = {
    enable = true;
    relogin = true;
    user = "demo";
  };
}
