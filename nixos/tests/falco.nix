{ lib, ... }:
let
  rule = name: file: {
    rule = name;
    desc = "Test rule for ${name}";
    condition = "evt.type in (open, openat, openat2) and fd.name = ${file}";
    output = "${name} (proc=%proc.name file=%fd.name container=%container.id)";
    priority = "WARNING";
    tags = [ "test" ];
  };
in
{
  name = "falco";
  meta.maintainers = with lib.maintainers; [ happysalada ];

  nodes.machine = {
    services.falco = {
      enable = true;

      settings = {
        priority = "warning";
        json_output = true;
        file_output = {
          enabled = true;
          keep_alive = true;
          filename = "/var/log/falco/events.json";
        };
        webserver = {
          enabled = true;
          prometheus_metrics_enabled = true;
        };
        metrics.enabled = true;
      };

      rules = {
        "50-test" = [ (rule "First file touched" "/tmp/first") ];

        # The overrides shown in the manual; they only compile after the stock rules.
        "60-tuning" = [
          {
            macro = "user_known_read_sensitive_files_activities";
            condition = "(proc.name = backup-agent)";
            override.condition = "replace";
          }
          {
            rule = "Terminal shell in container";
            condition = "and not container.image.repository = registry.example.com/debug-tools";
            override.condition = "append";
          }
        ];
      };
    };

    specialisation.second-rule.configuration.services.falco.rules."50-test" = [
      (rule "Second file touched" "/tmp/second")
    ];
  };

  testScript = ''
    import json

    # The probe attaches some time after the unit has started, so events are
    # triggered until one is seen.
    def fires(rule, trigger):
        machine.wait_until_succeeds(f"{trigger}; grep -q '{rule}' /var/log/falco/events.json")
        return json.loads(machine.succeed(f"grep '{rule}' /var/log/falco/events.json | tail -n 1"))

    machine.wait_for_unit("falco.service")
    machine.wait_for_open_port(8765)

    with subtest("serves health and metrics"):
        machine.succeed("curl -sf http://127.0.0.1:8765/healthz | grep -q ok")
        machine.wait_until_succeeds("curl -sf http://127.0.0.1:8765/metrics | grep -q falcosecurity")

    with subtest("fires a rule, enriched by the container plugin"):
        event = fires("First file touched", "touch /tmp/first")
        assert event["priority"] == "Warning", event
        assert event["output_fields"]["proc.name"] == "touch", event
        assert event["output_fields"]["container.id"] == "host", event

    with subtest("loads the stock rules and logs to the journal"):
        machine.wait_until_succeeds(
            "cat /etc/shadow > /dev/null; journalctl -u falco -o cat | grep -q 'Read sensitive file untrusted'"
        )

    with subtest("reopens its output file on SIGUSR1"):
        machine.succeed("mv /var/log/falco/events.json /var/log/falco/events.old")
        machine.succeed("systemctl kill --signal=SIGUSR1 falco.service")
        fires("First file touched", "touch /tmp/first")

    with subtest("reloads changed rules without restarting"):
        pid = machine.succeed("systemctl show -p MainPID --value falco.service")
        machine.succeed("/run/booted-system/specialisation/second-rule/bin/switch-to-configuration test")
        assert pid == machine.succeed("systemctl show -p MainPID --value falco.service"), "falco was restarted"
        fires("Second file touched", "touch /tmp/second")
  '';
}
