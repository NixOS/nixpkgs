# Test configuration switching.

import ./make-test.nix ({ pkgs, ...} : {
  name = "switch-test";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ gleber ];
  };

  nodes = {
    machine = { ... }: {
      users.mutableUsers = false;
    };
    other = { ... }: {
      users.mutableUsers = true;
    };
  };

  testScript = {nodes, ...}: let
    originalSystem = nodes.machine.config.system.build.toplevel;
    otherSystem = nodes.other.config.system.build.toplevel;
  in ''
    $machine->succeed("env -i ${originalSystem}/bin/switch-to-configuration test | tee /dev/stderr");
    $machine->succeed("env -i ${otherSystem}/bin/switch-to-configuration test | tee /dev/stderr");
  '';
})
