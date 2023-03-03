import ./make-test-python.nix ({ pkgs, lib, ...} : with lib; {
  name = "odoo";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ mkg20001 ];
  };

  nodes = {
    server = { ... }: {
      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
      };

      services.odoo = {
        enable = true;
        domain = "localhost";
      };
    };
  };

  testScript = { nodes, ... }:
  ''
    server.wait_for_unit("odoo.service")
    server.wait_until_succeeds("curl -s http://localhost:8069/web/database/selector | grep '<title>Odoo</title>'")
    server.succeed("curl -s http://localhost/web/database/selector | grep '<title>Odoo</title>'")
  '';
})
