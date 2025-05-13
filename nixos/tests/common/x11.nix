{ lib, pkgs, ... }:

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

  # Help with OCR
  systemd.tmpfiles.settings =
    let
      icewmSettingsDir = "/root/.icewm";
    in
    {
      "10-icewm-root-test-setup" = {
        "${icewmSettingsDir}".d = {
          mode = "0700";
          user = "root";
          group = "root";
        };
        "${icewmSettingsDir}/theme".L.argument = builtins.toString (
          pkgs.writeText "icewm-testing-theme" ''
            Theme="gtk2/default.theme"
          ''
        );
      };
    };
}
