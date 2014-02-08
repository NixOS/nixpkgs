{ config, pkgs, ... }:

{
  imports = [ ./graphical.nix ];

  users.extraUsers.demo =
    { description = "Demo user account";
      group = "users";
      extraGroups = [ "wheel" ];
      home = "/home/demo";
      createHome = true;
      useDefaultShell = true;
      password = "demo";
      uid = 1000;
    };
}
