{ config, pkgs, ... }:

{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  users.users.test = {
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    isNormalUser = true;
    initialPassword = "1234";
  };
}
