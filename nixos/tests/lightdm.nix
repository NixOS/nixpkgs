import ./make-test.nix ({ pkgs, ...} : {
  name = "lightdm";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ aszlig ];
  };

  machine = { lib, ... }: {
    imports = [ ./common/user-account.nix ];
    services.xserver.enable = true;
    services.xserver.displayManager.select = "lightdm";
    services.xserver.windowManager.select = [ "icewm " ];
  };

  enableOCR = true;

  testScript = { nodes, ... }: let
    user = nodes.machine.config.users.extraUsers.alice;
  in ''
    startAll;
    $machine->waitForText(qr/${user.description}/);
    $machine->screenshot("lightdm");
    $machine->sendChars("${user.password}\n");
    $machine->waitForFile("/home/alice/.Xauthority");
    $machine->succeed("xauth merge ~alice/.Xauthority");
    $machine->waitForWindow("^IceWM ");
  '';
})
