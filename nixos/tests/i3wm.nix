import ./make-test.nix ({ pkgs, ...} : {
  name = "i3wm";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ aszlig ];
  };

  machine = { lib, ... }: {
    imports = [ ./common/x11.nix ./common/user-account.nix ];
    services.xserver.displayManager.auto.user = "alice";
    services.xserver.windowManager.default = lib.mkForce "i3";
    services.xserver.windowManager.i3.enable = true;
  };

  testScript = { ... }: ''
    $machine->waitForX;
    $machine->waitForFile("/home/alice/.Xauthority");
    $machine->succeed("xauth merge ~alice/.Xauthority");
    $machine->waitForWindow(qr/first configuration/);
    $machine->sleep(2);
    $machine->screenshot("started");
    $machine->sendKeys("ret");
    $machine->sleep(2);
    $machine->sendKeys("alt");
    $machine->sleep(2);
    $machine->screenshot("configured");
    $machine->sendKeys("ret");
    # make sure the config file is created before we continue
    $machine->waitForFile("/home/alice/.config/i3/config");
    $machine->sleep(2);
    $machine->sendKeys("alt-ret");
    $machine->waitForWindow(qr/machine.*alice/);
    $machine->sleep(2);
    $machine->screenshot("terminal");
  '';
})
