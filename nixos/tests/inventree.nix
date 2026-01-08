{ lib, ... }:
{
  name = "inventree";
  meta.maintainers = with lib.maintainers; [
    kurogeek
  ];

  nodes = {
    psqlTest = {
      services.inventree = {
        enable = true;
      };
    };
    mysqlTest = {
      services.inventree = {
        enable = true;
        database.dbtype = "mysql";
      };
    };
  };
  testScript = ''
    psqlTest.wait_for_unit("inventree.target")
    psqlTest.wait_for_unit("inventree-server.service")
    psqlTest.wait_for_open_unix_socket("/run/inventree/gunicorn.socket")
    psqlTest.wait_until_succeeds("curl -sf http://localhost/web")

    mysqlTest.wait_for_unit("inventree.target")
    mysqlTest.wait_for_unit("inventree-server.service")
    mysqlTest.wait_for_open_unix_socket("/run/inventree/gunicorn.socket")
    mysqlTest.wait_until_succeeds("curl -sf http://localhost/web")
  '';
}
