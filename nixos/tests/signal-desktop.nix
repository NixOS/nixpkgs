import ./make-test.nix ({ pkgs, ...} :

{
  name = "signal-desktop";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ flokli ];
  };

  machine = { ... }:

  {
    imports = [
      ./common/user-account.nix
      ./common/x11.nix
    ];

    services.xserver.enable = true;
    services.xserver.displayManager.auto.user = "alice";
    environment.systemPackages = [ pkgs.signal-desktop ];
    virtualisation.memorySize = 1024;
  };

  enableOCR = true;

  testScript = { nodes, ... }: let
    user = nodes.machine.config.users.users.alice;
  in ''
    startAll;
    $machine->waitForX;

    # start signal desktop
    $machine->execute("su - alice -c signal-desktop &");

    # wait for the "Link your phone to Signal Desktop" message
    $machine->waitForText(qr/Link your phone to Signal Desktop/);
    $machine->screenshot("signal_desktop");
  '';
})
