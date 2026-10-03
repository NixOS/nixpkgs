{ lib, ... }:
{
  name = "minuspod";
  meta.maintainers = with lib.maintainers; [ tlvince ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.minuspod = {
        enable = true;
        host = "127.0.0.1";
        port = 8000;
        baseUrl = "http://localhost:8000";
        environment.MINUSPOD_REQUIRE_AUTH = "false";
      };
    };

  testScript = ''
    machine.wait_for_unit("minuspod.service")
    machine.wait_for_open_port(8000)
    machine.succeed("curl --fail http://127.0.0.1:8000/api/v1/health")
    machine.succeed("curl --fail http://127.0.0.1:8000/ui/ | grep -i minuspod")
  '';
}
