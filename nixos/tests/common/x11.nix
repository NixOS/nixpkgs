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
  services.displayManager.defaultSession = lib.mkDefault "none+icewm";
  services.xserver.windowManager.icewm.enable = true;

  environment.etc = {
    # Help with OCR
    "icewm/theme".text = ''
      Theme="gtk2/default.theme"
    '';
    # Remove task bar to avoid non-determinism
    "icewm/preferences".text = ''
      ShowTaskBar=0
    '';
  };

}
