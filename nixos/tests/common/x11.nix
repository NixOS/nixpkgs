{ config, lib, ... }:

let
  isNspawn = config.boot.isNspawnContainer;
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
    (lib.mkIf isNspawn {
      # nspawn containers have no physical display device, so use a headless
      # X server for graphical tests.
      videoDrivers = [ "dummy" ];
      resolutions = [
        {
          x = 1024;
          y = 768;
        }
      ];

      # logind correctly marks an nspawn seat without display hardware as
      # non-graphical. The dummy X server does not depend on that hardware.
      displayManager.lightdm.extraConfig = ''
        logind-check-graphical = false
      '';

      # `wait_for_x()` establishing a connection that is being teared down
      # before having any other connection to X11 causes the X server to reset
      # itself. This flag prevents that behavior.
      # Context: https://github.com/NixOS/nixpkgs/pull/578540#issuecomment-6593586095
      displayManager.xserverArgs = lib.mkAfter [ "-noreset" ];
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
