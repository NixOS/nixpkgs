# This test runs haka and probes it with hakactl

import ./make-test-python.nix ({ pkgs, ...} : {
  name = "haka";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ tvestelind ];
  };

  nodes = {
    haka =
      { ... }:
        {
          services.haka.enable = true;
        };
    };

  testScript = ''
    start_all()

    haka.wait_for_unit("haka.service")
    haka.succeed("hakactl status")
    haka.succeed("hakactl stop")
  '';
})
