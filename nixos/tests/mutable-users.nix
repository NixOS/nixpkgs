# Mutable users tests.

import ./make-test.nix ({ pkgs, ...} : {
  name = "mutable-users";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ gleber ];
  };

  nodes = {
    machine = { config, lib, pkgs, ... }: {
      users.mutableUsers = false;
    };
    mutable = { config, lib, pkgs, ... }: {
      users.mutableUsers = true;
    };
  };

  testScript = {nodes, ...}: let
    immutableSystem = nodes.machine.config.system.build.toplevel;
    mutableSystem = nodes.mutable.config.system.build.toplevel;
  in ''
    $machine->start();
    $machine->waitForUnit("default.target");

    # Machine starts in immutable mode. Add a user and test if reactivating
    # configuration removes the user.
    $machine->fail("cat /etc/passwd | grep ^foobar:");
    $machine->succeed("sudo useradd foobar");
    $machine->succeed("cat /etc/passwd | grep ^foobar:");
    $machine->succeed("${immutableSystem}/bin/switch-to-configuration test");
    $machine->fail("cat /etc/passwd | grep ^foobar:");

    # In immutable mode passwd is not wrapped, while in mutable mode it is
    # wrapped.
    $machine->succeed('which passwd | grep /run/current-system/');
    $machine->succeed("${mutableSystem}/bin/switch-to-configuration test");
    $machine->succeed('which passwd | grep /run/wrappers/');
  '';
})
