import ./make-test.nix ({ pkgs, lib, ... }:

with lib;

{
  name = "gnome-keyring";
  meta.maintainers = with pkgs.stdenv.lib.maintainers; [ ma27 ];

  nodes.machine = {
    imports = [ ./common/x11.nix ./common/user-account.nix ];
    services.xserver.displayManager.auto.user = "bob";

    services.gnome3.gnome-keyring.enable = true;
  };

  testScript = ''
    $machine->start;
    $machine->waitForX;
    $machine->waitForUnit("gnome-keyring-daemon.service", "bob");
  '';
})
