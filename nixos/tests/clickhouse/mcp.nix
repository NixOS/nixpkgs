{ pkgs, package, ... }:

{
  name = "clickhouse-mcp";

  meta.maintainers = with pkgs.lib.maintainers; [
    jpds
    thevar1able
  ];

  nodes.machine =
    { config, ... }:
    {
      virtualisation.memorySize = 4096;

      services.clickhouse = {
        enable = true;
        inherit package;
      };

      # Define an mcp-clickhouse systemd service
      systemd.services.mcp-clickhouse = {
        after = [ "clickhouse.service" ];
        requires = [ "clickhouse.service" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          ExecStart = pkgs.lib.getExe pkgs.mcp-clickhouse;
          Environment = [
            "CLICKHOUSE_HOST=127.0.0.1"
            "CLICKHOUSE_PORT=8123"
            "CLICKHOUSE_USER=default"
            "CLICKHOUSE_PASSWORD="
            "CLICKHOUSE_SECURE=false"
            "CLICKHOUSE_VERIFY=false"
            "CLICKHOUSE_MCP_SERVER_TRANSPORT=http"
            "CLICKHOUSE_MCP_BIND_HOST=127.0.0.1"
            "CLICKHOUSE_MCP_BIND_PORT=8000"
            "CLICKHOUSE_MCP_AUTH_TOKEN=test-token"
          ];
          DynamicUser = true;
          Restart = "on-failure";
          RestartSec = "5s";
        };
      };
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("clickhouse.service")
    machine.wait_for_open_port(8123)

    machine.wait_for_unit("mcp-clickhouse.service")
    machine.wait_for_open_port(8000)

    # /health performs a ClickHouse probe and only returns 200 OK when the
    # connection succeeds.
    machine.succeed("curl -fsS http://127.0.0.1:8000/health | grep -qx OK")
  '';
}
