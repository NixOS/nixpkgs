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
          filter-file = pkgs.writeText "filter" "chrome-extension://";
        };
      };
    };

  testScript = ''
    import json

    # health check
    machine.wait_for_unit("go-csp-collector.service")
    machine.wait_for_open_port(9999)
    machine.succeed("curl -f http://localhost:9999/health")

    # send valid csp report
    machine.succeed(
      "curl -f -X POST http://127.0.0.1:9999/ "
      "-H 'Content-Type: application/csp-report' "
      "-d '" + json.dumps({
        "csp-report": {
          "document-uri": "https://example.com/",
          "referrer": "https://example.com/",
          "violated-directive": "script-src",
          "effective-directive": "script-src",
          "original-policy": "script-src 'self'",
          "blocked-uri": "https://example.org/malicious.js",
          "status-code": 200
        }
      }) + "'"
    )
    logs = machine.succeed("journalctl -u go-csp-collector.service")
    assert "level=debug" in logs, "debug mode not enabled"
    assert "blocked_uri" in logs, "csp report not logged"
    assert "https://example.org/malicious.js" in logs, "blocked uri not in logs"

    # check rejection
    machine.fail(
      "curl -f -X POST http://[::1]:9999/ "
      "-H 'Content-Type: application/csp-report' "
      "-d '" + json.dumps({
        "csp-report": {
          "document-uri": "https://example.com/",
          "blocked-uri": "chrome-extension://something",
          "violated-directive": "script-src"
        }
      }) + "'"
    )
    logs = machine.succeed("journalctl -u go-csp-collector.service")
    assert "invalid resource" in logs, "filter rejection not logged"
    assert "chrome-extension://" in logs, "filtered uri pattern not in logs"
  '';
}
