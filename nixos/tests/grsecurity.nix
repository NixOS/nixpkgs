# Basic test to make sure grsecurity works

import ./make-test.nix ({ pkgs, ...} : {
  name = "grsecurity";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ copumpkin ];
  };

  machine = { config, pkgs, ... }:
    { boot.kernelPackages = pkgs.linuxPackages_grsec_testing_server; };

  testScript =
    ''
      $machine->succeed("uname -a") =~ /grsec/;
      # FIXME: this seems to hang the whole test. Unclear why, but let's fix it
      # $machine->succeed("${pkgs.paxtest}/bin/paxtest blackhat");
    '';
})

