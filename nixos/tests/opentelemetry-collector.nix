import ./make-test-python.nix ({ pkgs, ...} : let
  port = 4318;
in {
  name = "opentelemetry-collector";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ tylerjl ];
  };

  nodes.machine = { ... }: {
    networking.firewall.allowedTCPPorts = [ port ];
    services.opentelemetry-collector = {
      enable = true;
      settings = {
        exporters.logging.verbosity = "detailed";
        receivers.otlp.protocols.http = {};
        service = {
          pipelines.logs = {
            receivers = [ "otlp" ];
            exporters = [ "logging" ];
          };
        };
      };
    };
    virtualisation.forwardPorts = [{
      host.port = port;
      guest.port = port;
    }];
  };

  extraPythonPackages = p: [
    p.requests
    p.types-requests
  ];

  # Send a log event through the OTLP pipeline and check for its
  # presence in the collector logs.
  testScript = /* python */ ''
    import requests
    import time

    from uuid import uuid4

    flag = str(uuid4())

    machine.wait_for_unit("opentelemetry-collector.service")
    machine.wait_for_open_port(${toString port})

    event = {
        "resourceLogs": [
            {
                "resource": {"attributes": []},
                "scopeLogs": [
                    {
                        "logRecords": [
                            {
                                "timeUnixNano": str(time.time_ns()),
                                "severityNumber": 9,
                                "severityText": "Info",
                                "name": "logTest",
                                "body": {
                                    "stringValue": flag
                                },
                                "attributes": []
                            },
                        ]
                    }
                ]
            }
        ]
    }

    response = requests.post("http://localhost:${toString port}/v1/logs", json=event)
    assert response.status_code == 200
    assert flag in machine.execute("journalctl -u opentelemetry-collector")[-1]
  '';
})
