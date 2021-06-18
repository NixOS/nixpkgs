# This test runs chatwoot and checks if it works

import ./make-test-python.nix ({ pkgs, lib, ...} : with lib; {
  name = "chatwoot";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ mkg20001 ];
  };

  nodes = {
    chatwoot = { ... }: {
      imports = [ common/user-account.nix ];

      virtualisation.memorySize = 4096;

      services.chatwoot = {
        enable = true;

        domain = "chatwoot";
        externalUrl = "http://chatwoot";
        nginx = true;
      };

      services.nginx.virtualHosts.chatwoot = {
        enableACME = mkForce false;
      };
    };
  };

  testScript = { nodes, ... }:
    let
      da = true;
    in ''
        chatwoot.start()
        chatwoot.wait_for_unit("chatwoot-web.service")
        chatwoot.wait_for_unit("chatwoot-worker.service")
        chatwoot.wait_until_succeeds("curl -sSf http://chatwoot")
      '';
})
