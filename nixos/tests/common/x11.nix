{ config, lib, ... }:

let
  isHeadless = config.boot.isNspawnContainer;
in
{
  imports = [
    ./auto.nix
  ];

  services.xserver = lib.mkMerge [
    {
      enable = true;

      # Use IceWM as the window manager.
      windowManager.icewm.enable = true;
    }
    (lib.mkIf isHeadless {
      # nspawn containers have no physical display device, so use a headless
      # X server for graphical tests.
      videoDrivers = [ "dummy" ];
      resolutions = [
        {
          x = 1024;
          y = 768;
        }
      ];
    })
  ];

  # Automatically log in.
  test-support.displayManager.auto.enable = true;

  # Don't use a desktop manager.
  services.displayManager.defaultSession = lib.mkDefault "none+icewm";

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
