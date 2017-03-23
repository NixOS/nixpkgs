import ./make-test.nix ({ pkgs, ...} : {
  name = "sddm";

  machine = { lib, ... }: {
    imports = [ ./common/user-account.nix ];
    services.xserver.enable = true;
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.windowManager.default = "icewm";
    services.xserver.windowManager.icewm.enable = true;
    services.xserver.desktopManager.default = "none";
  };

  enableOCR = true;

  testScript = { nodes, ... }: let
    user = nodes.machine.config.users.extraUsers.alice;
  in ''
    startAll;
    $machine->waitForText(qr/ALICE/);
    $machine->screenshot("sddm");
    $machine->sendChars("${user.password}\n");
    $machine->waitForFile("/home/alice/.Xauthority");
    $machine->succeed("xauth merge ~alice/.Xauthority");
    $machine->waitForWindow("^IceWM ");
  '';
})
