# This test runs haka and probes it with hakactl

import ./make-test.nix ({ pkgs, ...} : {
  name = "haka";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ tvestelind ];
  };

  nodes = {
    haka =
      { config, pkgs, ... }:
        {
          services.haka.enable = true;
        };
    };

  testScript = ''
    startAll;

    $haka->waitForUnit("haka.service");
    $haka->succeed("hakactl status");
    $haka->succeed("hakactl stop");
  '';
})
