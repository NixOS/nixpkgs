{ lib, ... }:

{
  name = "kimai";
  meta.maintainers = with lib.maintainers; [ peat-psuwit ];

  nodes.machine =
    { ... }:
    {
      services.kimai.sites."localhost" = {
        database.createLocally = true;
      };
    };

  testScript = ''
    machine.wait_for_unit("phpfpm-kimai-localhost.service")
    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(80)
    machine.succeed("curl -v --location --fail http://localhost/")
  '';
}
