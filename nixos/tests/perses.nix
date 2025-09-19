{ lib, ... }:

{
  name = "perses";

  meta.maintainers = with lib.maintainers; [ fooker ];

  nodes.machine = {
    services.perses = {
      enable = true;
    };
  };

  testScript = ''
    start_all()

    with subtest("Perses starts"):
        machine.wait_for_unit("perses.service")
        machine.wait_for_open_port(8080)
        machine.succeed("percli login http://127.0.0.1:8080")
        machine.succeed("percli version")
        machine.succeed("percli config")
        machine.succeed("percli plugin list | grep 'Prometheus'")
  '';
}
