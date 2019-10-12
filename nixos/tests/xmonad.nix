import ./make-test.nix ({ pkgs, ...} : {
  name = "xmonad";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ nequissimus ];
  };

  machine = { lib, pkgs, ... }: {
    imports = [ ./common/x11.nix ./common/user-account.nix ];
    services.xserver.displayManager.auto.user = "alice";
    services.xserver.windowManager.default = lib.mkForce "xmonad";
    services.xserver.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = with pkgs.haskellPackages; haskellPackages: [ xmobar ];
      config = ''
        import XMonad
        import XMonad.Util.EZConfig
        main = launch $ def `additionalKeysP` myKeys
        myKeys = [ ("M-C-x", spawn "xterm") ]
      '';
    };
  };

  testScript = { ... }: ''
    $machine->waitForX;
    $machine->waitForFile("/home/alice/.Xauthority");
    $machine->succeed("xauth merge ~alice/.Xauthority");
    $machine->sendKeys("alt-ctrl-x");
    $machine->waitForWindow(qr/alice.*machine/);
    $machine->sleep(1);
    $machine->screenshot("terminal");
    $machine->waitUntilSucceeds("xmonad --restart");
    $machine->sleep(3);
    $machine->sendKeys("alt-shift-ret");
    $machine->waitForWindow(qr/alice.*machine/);
    $machine->sleep(1);
    $machine->screenshot("terminal");
  '';
})
