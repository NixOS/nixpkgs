{ lib, ... }:

let
  ports = {
    alertmanager-ntfy = 8000;
    ntfy-sh = 8001;
    alertmanager = 8002;
  };
in

{
  name = "alertmanager-ntfy";
  meta.maintainers = with lib.maintainers; [ defelo ];

  nodes.machine = {
    services.prometheus.alertmanager = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = ports.alertmanager;

      configuration = {
        route = {
          receiver = "test";
          group_by = [ "..." ];
          group_wait = "0s";
          group_interval = "1s";
          repeat_interval = "2h";
        };

        receivers = [
          {
            name = "test";
            webhook_configs = [ { url = "http://127.0.0.1:${toString ports.alertmanager-ntfy}/hook"; } ];
          }
        ];
      };
    };

    services.prometheus.alertmanager-ntfy = {
      enable = true;
      settings = {
        http.addr = "127.0.0.1:${toString ports.alertmanager-ntfy}";
        ntfy = {
          baseurl = "http://127.0.0.1:${toString ports.ntfy-sh}";
          notification.topic = "alertmanager";
        };
      };
    };

    services.ntfy-sh = {
      enable = true;
      settings = {
        listen-http = "127.0.0.1:${toString ports.ntfy-sh}";
        base-url = "http://127.0.0.1:${toString ports.ntfy-sh}";
      };
    };
  };

  interactive.nodes.machine = {
    services.prometheus.alertmanager.listenAddress = lib.mkForce "0.0.0.0";
    services.prometheus.alertmanager-ntfy.settings.http.addr =
      lib.mkForce "0.0.0.0:${toString ports.alertmanager-ntfy}";
    services.ntfy-sh.settings.listen-http = lib.mkForce "0.0.0.0:${toString ports.ntfy-sh}";
    networking.firewall.enable = false;
    virtualisation.forwardPorts = lib.mapAttrsToList (_: port: {
      from = "host";
      host = { inherit port; };
      guest = { inherit port; };
    }) ports;
  };

  testScript = ''
    import json
    import time

    machine.wait_for_unit("alertmanager.service")
    machine.wait_for_unit("alertmanager-ntfy.service")
    machine.wait_for_unit("ntfy-sh.service")
    machine.wait_for_open_port(${toString ports.alertmanager})
    machine.wait_for_open_port(${toString ports.alertmanager-ntfy})
    machine.wait_for_open_port(${toString ports.ntfy-sh})

    machine.succeed("""curl 127.0.0.1:${toString ports.alertmanager}/api/v2/alerts \
      -X POST -H 'Content-Type: application/json' \
      -d '[{ \
        "labels": {"alertname": "test"},
        "annotations": {"summary": "alert summary", "description": "alert description"} \
      }]'""")

    while not (resp := machine.succeed("curl '127.0.0.1:${toString ports.ntfy-sh}/alertmanager/json?poll=1'")):
      time.sleep(1)

    msg = json.loads(resp)
    assert msg["title"] == "alert summary"
    assert msg["message"] == "alert description"
    assert msg["priority"] == 4
    assert "red_circle" in msg["tags"]
  '';
}
