{ lib, ... }:

let
  ports = {
    grafana-to-ntfy = 8080;
    ntfy-sh = 8081;
    grafana = 3000;
    alertmanager = 9093;
  };
  ntfyTopic = "grafana-alerts";
in

{
  name = "grafana-to-ntfy";
  meta.maintainers = with lib.maintainers; [ kittyandrew ];

  nodes.machine = {
    services.grafana-to-ntfy = {
      enable = true;
      settings = {
        ntfyUrl = "http://127.0.0.1:${toString ports.ntfy-sh}/${ntfyTopic}";
        port = ports.grafana-to-ntfy;
        address = "127.0.0.1";
      };
    };

    services.ntfy-sh = {
      enable = true;
      settings = {
        listen-http = "127.0.0.1:${toString ports.ntfy-sh}";
        base-url = "http://127.0.0.1:${toString ports.ntfy-sh}";
      };
    };

    services.grafana = {
      enable = true;
      settings = {
        server.http_port = ports.grafana;
        server.http_addr = "127.0.0.1";
        security.admin_user = "admin";
        security.admin_password = "admin";
        security.secret_key = "test-only-dummy-key";
      };
      provision.alerting = {
        contactPoints.settings = {
          apiVersion = 1;
          contactPoints = [
            {
              orgId = 1;
              name = "grafana-to-ntfy";
              receivers = [
                {
                  uid = "cp_webhook";
                  type = "webhook";
                  disableResolveMessage = false;
                  settings = {
                    url = "http://127.0.0.1:${toString ports.grafana-to-ntfy}";
                    httpMethod = "POST";
                  };
                }
              ];
            }
          ];
        };
        policies.settings = {
          apiVersion = 1;
          policies = [
            {
              orgId = 1;
              receiver = "grafana-to-ntfy";
              group_by = [ "..." ];
              group_wait = "0s";
              group_interval = "1s";
              repeat_interval = "1h";
            }
          ];
        };
      };
    };

    services.prometheus.alertmanager = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = ports.alertmanager;
      configuration = {
        route = {
          receiver = "grafana-to-ntfy";
          group_by = [ "..." ];
          group_wait = "0s";
          group_interval = "1s";
          repeat_interval = "2h";
        };
        receivers = [
          {
            name = "grafana-to-ntfy";
            webhook_configs = [
              { url = "http://127.0.0.1:${toString ports.grafana-to-ntfy}"; }
            ];
          }
        ];
      };
    };
  };

  interactive.nodes.machine = {
    services.grafana-to-ntfy.settings.address = lib.mkForce "0.0.0.0";
    services.grafana.settings.server.http_addr = lib.mkForce "0.0.0.0";
    services.prometheus.alertmanager.listenAddress = lib.mkForce "0.0.0.0";
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

    machine.wait_for_unit("grafana-to-ntfy.service")
    machine.wait_for_unit("ntfy-sh.service")
    machine.wait_for_unit("grafana.service")
    machine.wait_for_unit("alertmanager.service")
    machine.wait_for_open_port(${toString ports.grafana-to-ntfy})
    machine.wait_for_open_port(${toString ports.ntfy-sh})
    machine.wait_for_open_port(${toString ports.grafana})
    machine.wait_for_open_port(${toString ports.alertmanager})

    with subtest("Health endpoint returns 200"):
      machine.succeed("curl -sf http://127.0.0.1:${toString ports.grafana-to-ntfy}/health")

    with subtest("Alertmanager alert arrives at ntfy"):
      machine.succeed(
        "curl -sf http://127.0.0.1:${toString ports.alertmanager}/api/v2/alerts"
        " -X POST -H 'Content-Type: application/json'"
        " -d '[{\"labels\": {\"alertname\": \"TestAlertFromAM\"}}]'"
      )
      # grep makes wait_until_succeeds retry: ntfy returns 200 with empty body when no messages exist
      resp = machine.wait_until_succeeds(
        "curl -sf 'http://127.0.0.1:${toString ports.ntfy-sh}/${ntfyTopic}/json?poll=1'"
        " | grep '\"title\":\"Alertmanager\"'"
      )
      msg = json.loads(resp.strip())
      assert msg["title"] == "Alertmanager", f"Expected title 'Alertmanager', got '{msg['title']}'"
      assert "warning" in msg["tags"], f"Expected 'warning' in tags, got {msg['tags']}"
      assert "firing" in msg["tags"], f"Expected 'firing' in tags, got {msg['tags']}"

    with subtest("Grafana alert arrives at ntfy"):
      machine.succeed(
        "curl -sf http://127.0.0.1:${toString ports.grafana}/apis/notifications.alerting.grafana.app/v1beta1/namespaces/default/receivers/-/test"
        " -u admin:admin"
        " -X POST -H 'Content-Type: application/json'"
        """ -d '{"alert": {"labels": {"alertname": "test-alert"}, "annotations": {}}, "integration": {"type": "webhook", "settings": {"url": "http://127.0.0.1:${toString ports.grafana-to-ntfy}", "httpMethod": "POST"}}}'"""
      )
      # grep ensures we wait for the Grafana message specifically (see above)
      resp = machine.wait_until_succeeds(
        "curl -sf 'http://127.0.0.1:${toString ports.ntfy-sh}/${ntfyTopic}/json?poll=1'"
        " | grep 'FIRING'"
      )
      msg = json.loads(resp.strip())
      assert "[FIRING:1]" in msg["title"], f"Expected Grafana title with '[FIRING:1]', got '{msg['title']}'"
      assert "warning" in msg["tags"], f"Expected 'warning' in tags, got {msg['tags']}"
      assert "firing" in msg["tags"], f"Expected 'firing' in tags, got {msg['tags']}"
  '';
}
