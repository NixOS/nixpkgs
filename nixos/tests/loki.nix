{ pkgs, ... }:

{
  name = "loki";

  meta.maintainers = [ ];

  nodes.machine =
    { ... }:
    {
      services.loki = {
        enable = true;
        configFile = "${pkgs.grafana-loki.src}/cmd/loki/loki-local-config.yaml";
      };
    };

  testScript = ''
    import json
    import time

    machine.start
    machine.wait_for_unit("loki.service")
    machine.wait_for_open_port(3100)

    payload = json.dumps({
        "streams": [{
            "stream": {"job": "test"},
            "values": [
                [str(time.time_ns()), "Loki Ingestion Test"],
            ],
        }],
    })
    machine.succeed(f"curl --json '{payload}' http://localhost:3100/loki/api/v1/push")

    machine.wait_until_succeeds("logcli query --no-labels '{job=\"test\"}' | grep -q 'Loki Ingestion Test'")
  '';
}
