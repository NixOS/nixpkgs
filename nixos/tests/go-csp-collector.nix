{ lib, ... }:

{
  name = "go-csp-collector";
  meta.maintainers = with lib.maintainers; [ stepbrobd ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.go-csp-collector = {
        enable = true;
        settings = {
          debug = true;
          port = 9999;
          health-check-path = "/health";
          filter-file = pkgs.writeText "filter" ''
            # allow ::1
            127.0.0.1
          '';
        };
      };
    };

  testScript = ''
    import json

    machine.wait_for_unit("go-csp-collector.service")
    machine.wait_for_open_port(8000)

    resp = json.loads(machine.succeed("curl localhost:8000/get?foo=bar"))
    assert resp["args"]["foo"] == ["bar"]
    assert resp["method"] == "GET"
    assert resp["origin"] == "127.0.0.1"
    assert resp["url"] == "http://localhost:8000/get?foo=bar"
  '';
}
