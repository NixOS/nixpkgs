{ lib, ... }:
{
  name = "flaresolverr";
  meta.maintainers = with lib.maintainers; [ diogotcorreia ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.flaresolverr = {
        enable = true;
        port = 8888;
      };

      services.nginx = {
        enable = true;
        virtualHosts.localhost = {
          locations."/" = {
            return = "200 'hello world'";
            extraConfig = ''
              default_type text/plain;
            '';
          };
        };
      };
    };

  testScript = /* python */ ''
    import json

    machine.wait_for_unit("flaresolverr.service")
    machine.wait_for_open_port(8888)
    machine.succeed("curl --fail http://localhost:8888/")

    res = machine.succeed("""curl --fail http://localhost:8888/v1 -X POST --json '{ "cmd": "request.get", "url": "http://localhost/", "maxTimeout": 10000 }'""")
    res = json.loads(res)
    response = res["solution"]["response"]
    assert "hello world" in response, f"Could not find 'hello world' in response: {response}"
  '';
}
