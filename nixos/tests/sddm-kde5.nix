import ./make-test.nix ({ pkgs, ...} : {
  name = "sddm";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ ttuegel ];
  };

  machine = { lib, ... }: {
    imports = [ ./common/user-account.nix ];
    services.xserver.displayManager.enable = "sddm";
    services.xserver.displayManager.sddm.autoLogin = {
      enable = true;
      user = "alice";
    };
    services.xserver.windowManager.enable = [ "icewm" ];
    services.xserver.desktopManager.enable = [ "kde5" ];
  };

  enableOCR = true;

  testScript = { nodes, ... }: ''
    startAll;
    $machine->waitForFile("/home/alice/.Xauthority");
    $machine->succeed("xauth merge ~alice/.Xauthority");
    $machine->waitForWindow("^IceWM ");
  '';
})
