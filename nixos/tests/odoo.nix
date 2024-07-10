import ./make-test-python.nix ({ pkgs, lib, package ? pkgs.odoo, ...} : {
  name = "odoo";
  meta.maintainers = with lib.maintainers; [ mkg20001 ];

  nodes = {
    server = { ... }: {
      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
      };

      services.odoo = {
        enable = true;
        package = package;
        domain = "localhost";
      };

      # odoo does not automatically initialize its database,
      # even if passing what _should_ be the equivalent of these options:
      #  settings = {
      #    options = {
      #      database = "odoo";
      #      init = "base";
      #    };
      #  };
      systemd.services.odoo.preStart = ''
        HOME=$STATE_DIRECTORY ${package}/bin/odoo -d odoo -i base --stop-after-init --without-demo all
      '';
    };
  };

  testScript = { nodes, ... }:
  ''
    server.wait_for_unit("odoo.service")
    server.wait_until_succeeds("curl -s http://localhost:8069/web/database/selector | grep '<title>Odoo</title>'")
    server.succeed("curl -s http://localhost/web/database/selector | grep '<title>Odoo</title>'")
  '';
})
