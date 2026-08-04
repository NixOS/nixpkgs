{ config, pkgs, lib, ... }:

{
  # Budgie 10.10 uses Wayland.
  services.desktopManager.budgie.enable = true;

  # LightDM is primarily intended for X11 sessions.
  # Use GDM for the Budgie Wayland session.
  services.displayManager.gdm.enable = true;

  # Budgie's package advertises this session name.
  services.displayManager.defaultSession = lib.mkDefault "budgie-desktop";

  # Automatically enter the live ISO desktop.
  services.displayManager.autoLogin = {
    enable = true;
    user = "nixos";
  };

  # Keep XWayland enabled so ordinary X11 applications can run
  # inside the Budgie Wayland session.
  programs.xwayland.enable = true;

  # Useful desktop packages.
  environment.systemPackages = with pkgs; [
    budgie-desktop
    budgie-control-center
    gnome-terminal
    nautilus
    networkmanagerapplet
    pavucontrol
  ];

  # NetworkManager is appropriate for a desktop/live ISO.
  networking.networkmanager.enable = true;

  # Audio.
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Common desktop services.
  services.dbus.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.udisks2.enable = true;
  services.upower.enable = true;

  # Fonts.
  fonts.packages = with pkgs; [
    dejavu_fonts
    liberation_ttf
    noto-fonts
    noto-fonts-color-emoji
  ];

  # Avoid competing display-manager/session definitions.
  services.xserver.displayManager.lightdm.enable =
    lib.mkForce false;
}
