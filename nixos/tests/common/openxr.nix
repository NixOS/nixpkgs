{
  lib,
  pkgs,
  config,
  ...
}:

{
  imports = [
    ./user-account.nix
    ./x11.nix
  ];
  test-support.displayManager.auto.user = "alice";
  systemd.user.targets.xdg-desktop-autostart = {
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
  };

  hardware.graphics.enable = true;

  services.monado = {
    enable = true;
    defaultRuntime = true;
    forceDefaultRuntime = true;
  };
  systemd.user.services.monado = {
    requires = [ "graphical-session.target" ];
    environment = {
      # Stop Monado from probing for any hardware
      SIMULATED_ENABLE = "1";
      # Run as X11 client rather than using direct mode
      XRT_COMPOSITOR_FORCE_XCB = "1";
      # And run fullscreen so that we can hide the DE
      XRT_COMPOSITOR_XCB_FULLSCREEN = "1";
    };
  };
}
