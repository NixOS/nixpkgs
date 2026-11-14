{ pkgs, ... }:
{
  name = "gatus";
  meta.maintainers = with pkgs.lib.maintainers; [ pizzapim ];

  nodes.machine =
    { ... }:
    {
      services.gatus = {
        enable = true;

        settings = {
          web.port = 8080;
          metrics = true;

          endpoints = [
            {
              name = "metrics";
              url = "http://localhost:8080/metrics";
              interval = "1s";
              conditions = [
                "[STATUS] == 200"
              ];
            }
            {
              name = "ping";
              url = "icmp://127.0.0.1";
              interval = "1s";
              conditions = [
                "[CONNECTED] == true"
              ];
            }
          ];
        };
      };
    };

  testScript = ''
    import datetime as dt
    import json

    machine.wait_for_unit("gatus.service")
    machine.wait_until_succeeds("curl -s http://localhost:8080/metrics | grep go_info", timeout=60)

    with subtest("ICMP checks work without CAP_NET_RAW"):
      def ping_succeeded(_):
        statuses = json.loads(machine.succeed("curl -sf http://localhost:8080/api/v1/endpoints/statuses"))
        results = next((s["results"] for s in statuses if s["name"] == "ping"), [])
        return len(results) > 0 and all(r["success"] for r in results)
      retry(ping_succeeded, timeout=dt.timedelta(seconds=60))
  '';
}
