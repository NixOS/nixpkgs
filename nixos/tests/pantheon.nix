import ./make-test.nix ({ pkgs, ...} :

{
  name = "pantheon";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ worldofpeace ];
  };

  machine = { ... }:

  {
    imports = [ ./common/user-account.nix ];

    services.xserver.enable = true;
    services.xserver.desktopManager.pantheon.enable = true;

    virtualisation.memorySize = 1024;
  };

  enableOCR = true;

  testScript = { nodes, ... }: let
    user = nodes.machine.config.users.users.alice;
  in ''
    # Wait for display manager to start
    $machine->waitForUnit("display-manager.service");

    # Test we can see username in elementary-greeter
    $machine->waitForText(qr/${user.description}/);
    $machine->screenshot("elementary_greeter_lightdm");

    # Log in
    $machine->sendChars("${user.password}\n");
    $machine->waitForUnit("default.target","alice");
    $machine->waitForFile("${user.home}/.Xauthority");
    $machine->succeed("xauth merge ${user.home}/.Xauthority");

    # Check if "pantheon-shell" components actually start
    $machine->waitUntilSucceeds("pgrep gala");
    $machine->waitForWindow(qr/gala/);
    $machine->waitUntilSucceeds("pgrep wingpanel");
    $machine->waitForWindow("wingpanel");
    $machine->waitUntilSucceeds("pgrep plank");
    $machine->waitForWindow(qr/plank/);

    # Check that logging in has given the user ownership of devices.
    $machine->succeed("getfacl -p /dev/snd/timer | grep -q alice");

    # Open elementary terminal
    $machine->execute("su - alice -c 'DISPLAY=:0.0 io.elementary.terminal &'");
    $machine->waitForWindow(qr/io.elementary.terminal/);

    # Take a screenshot of the desktop
    $machine->sleep(20);
    $machine->screenshot("screen");
  '';
})
