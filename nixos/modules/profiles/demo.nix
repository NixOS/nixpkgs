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
}
