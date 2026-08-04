{ config, pkgs, lib, ... }: {
  imports = [
    ../modules/desktop/budgie.nix
    ../modules/desktop/budgie-config.nix
    ../modules/desktop/wayfire.nix
    ../modules/desktop/wayfire-config.nix
  ];

  # GDM is preferred for reliable Wayland sessions
  services.displayManager.gdm = {
    enable = true;
  };

  services.displayManager.defaultSession = "euclid-budgie-wayfire";

  environment.systemPackages = with pkgs; [
    euclid-wayfire-session
  ];

  services.displayManager.sessionPackages = [ pkgs.euclid-wayfire-session ];
}
