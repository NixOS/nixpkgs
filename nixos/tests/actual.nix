{ lib, ... }:
{
  name = "actual";
  meta.maintainers = [ lib.maintainers.oddlama ];

  nodes.machine =
    { ... }:
    {
      services.actual.enable = true;
    };

  nodes.machine2 =
    { ... }:
    {
      services.actual = {
        enable = true;
        user = "actual";
        group = "actual";
        settings = {
          port = 7000;
          dataDir = "/var/lib/actual-test";
        };
      };

      users.users.actual = {
        group = "actual";
        home = "/var/lib/actual-test";
        isSystemUser = true;
      };

      users.groups.actual = { };

      systemd.tmpfiles.settings = {
        "10-actualdir" = {
          "/var/lib/actual-test" = {
            d = {
              group = "actual";
              mode = "0755";
              user = "actual";
            };
          };
        };
      };
    };

  testScript = ''
    start_all()

    machine.wait_for_open_port(3000)
    machine.succeed("curl -fvvv -Ls http://localhost:3000/ | grep 'Actual'")

    machine2.wait_for_open_port(7000)
    machine2.succeed("curl -fvvv -Ls http://localhost:7000/ | grep 'Actual'")
  '';
}
