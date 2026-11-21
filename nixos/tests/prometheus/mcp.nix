{ lib, pkgs, ... }:

let
  mcpClient =
    pkgs.writers.writePython3Bin "prometheus-mcp-client"
      {
        libraries = [ pkgs.python3Packages.mcp ];
        flakeIgnore = [ "E501" ];
      }
      ''
        """Query Prometheus through prometheus-mcp with the MCP Python SDK."""

        import asyncio

        from mcp import ClientSession
        from mcp.client.streamable_http import streamable_http_client


        async def main():
            async with streamable_http_client("http://127.0.0.1:8080/mcp") as (read, write):
                async with ClientSession(read, write) as session:
                    await session.initialize()
                    result = await session.call_tool("query", {"query": "prom_mcp_build_info"})
                    text = "".join(getattr(block, "text", "") for block in result.content)
                    if result.is_error or "prometheus-mcp" not in text:
                        raise RuntimeError(f"query failed: {result}")


        asyncio.run(main())
      '';
in
{
  name = "prometheus-mcp";

  meta.maintainers = with lib.maintainers; [
    fpletz
    Frostman
    jpds
  ];

  nodes.machine =
    { ... }:
    {
      virtualisation.memorySize = 1024;

      services.prometheus = {
        enable = true;
        globalConfig.scrape_interval = "1s";

        scrapeConfigs = [
          {
            job_name = "prometheus";
            static_configs = [ { targets = [ "127.0.0.1:9090" ]; } ];
          }
          {
            job_name = "prometheus-mcp";
            static_configs = [ { targets = [ "127.0.0.1:8080" ]; } ];
          }
        ];
      };

      systemd.services.prometheus-mcp = {
        wantedBy = [ "multi-user.target" ];
        after = [ "prometheus.service" ];
        requires = [ "prometheus.service" ];

        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.prometheus-mcp} --mcp.transport=http --web.listen-address=127.0.0.1:8080 --prometheus.url=http://127.0.0.1:9090";
          DynamicUser = true;
          Restart = "on-failure";
          RestartSec = "5s";
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("prometheus.service")
    machine.wait_for_open_port(9090)

    machine.wait_for_unit("prometheus-mcp.service")
    machine.wait_for_open_port(8080)

    # Prometheus scrapes the MCP server's own metrics here; the MCP tool call
    # below then queries them back out of Prometheus.
    machine.wait_until_succeeds(
      "curl -sSf 'http://127.0.0.1:9090/api/v1/query?query=prom_mcp_build_info' | grep -q prometheus-mcp"
    )

    machine.succeed("${lib.getExe mcpClient}")
  '';
}
