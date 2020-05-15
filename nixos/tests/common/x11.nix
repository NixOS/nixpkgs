{ lib, ... }:

{
  imports = [
    ./auto.nix
  ];

  services.xserver.enable = true;

  # Automatically log in.
  test-support.displayManager.auto.enable = true;

  # Use IceWM as the window manager.
  # Don't use a desktop manager.
  services.xserver.displayManager.defaultSession = lib.mkDefault "none+icewm";
  services.xserver.windowManager.icewm.enable = true;
}
