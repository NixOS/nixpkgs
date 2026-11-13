{
  package,
  lib,
  ...
}:
{
  name = "odoo-multi-process";
  meta.maintainers = with lib.maintainers; [
    mkg20001
    xanderio
  ];

  nodes.server = {
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
    };

    services.odoo = {
      enable = true;
      package = package;
      autoInit = true;
      autoInitExtraFlags = [ "--without-demo=all" ];
      domain = "localhost";
      settings.options.workers = 2;
    };
  };

  testScript = # python
    ''
      server.wait_for_unit("odoo.service")
      server.wait_until_succeeds(
        "test $(journalctl -u odoo | grep -o 'Worker WorkerHTTP ([[:digit:]]*) alive' | wc -l) = 2"
      )
      server.wait_until_succeeds("curl -s http://localhost:8069/web/database/selector | grep '<title>Odoo</title>'")
      server.succeed("curl -s http://localhost/web/database/selector | grep '<title>Odoo</title>'")
      server.succeed("curl http://localhost/web/database/manager | grep 'database manager has been disabled'")
    '';
}
