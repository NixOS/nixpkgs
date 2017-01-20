{ system ? builtins.currentSystem }:

with import ../lib/testing.nix { inherit system; };
with import ../lib/qemu-flags.nix;
with pkgs.lib;
{
  hyperd = makeTest {
    name = "hyperd";

   machine= { config, pkgs, lib, nodes, ... }: {
     virtualisation.memorySize = 768;
     virtualisation.diskSize = 2048;

     virtualisation.hyperd.enable = true;
   };

    testScript = ''
      startAll;

      $machine->waitUntilSucceeds("hyperctl run redis")

    '';
  };
}
