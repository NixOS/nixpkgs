{
  lib,
  ...
}:
{
  name = "iggy";

  meta = {
    maintainers = with lib.maintainers; [ jpds ];
  };

  nodes = {
    server =
      { pkgs, ... }:
      {
        services.iggy = {
          enable = true;
          settings = {
            http.address = "[::]:3000";
            tcp.address = "[::]:8090";
          };
          secretsFile = pkgs.writeText "iggy-test-secrets" ''
            IGGY_ROOT_USERNAME=iggy
            IGGY_ROOT_PASSWORD=secret
            IGGY_HTTP_JWT_ENCODING_SECRET=nixos-test-jwt-secret
            IGGY_HTTP_JWT_DECODING_SECRET=nixos-test-jwt-secret
          '';
        };

        environment.systemPackages = [ pkgs.iggy ];

        networking.firewall.allowedTCPPorts = [
          3000 # HTTP API
          8090 # TCP
        ];
      };

    mcp =
      { pkgs, ... }:
      let
        mcpConfigFile = pkgs.writeText "iggy-mcp.toml" ''
          transport = "http"

          [http]
          address = "[::]:8082"
          path = "/mcp"

          [iggy]
          address = "server:8090"
          username = "iggy"
          password = "secret"
          consumer = "iggy-mcp"

          [permissions]
          create = true
          read = true
          update = true
          delete = true

          [telemetry]
          enabled = false
          service_name = "iggy-mcp"
        '';
      in
      {
        systemd.services.iggy-mcp = {
          description = "Iggy MCP Server";
          wantedBy = [ "multi-user.target" ];
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          environment.IGGY_MCP_CONFIG_PATH = "${mcpConfigFile}";
          serviceConfig = {
            ExecStart = lib.getExe' pkgs.iggy "iggy-mcp";
            Restart = "on-failure";
          };
        };
      };
  };

  testScript = ''
    server.start()
    server.wait_for_unit("iggy-server.service")
    server.wait_for_open_port(3000)
    server.wait_for_open_port(8090)

    with subtest("create stream"):
        server.succeed("IGGY_USERNAME=iggy IGGY_PASSWORD=secret iggy stream create teststream")

    with subtest("create topic"):
        server.succeed("IGGY_USERNAME=iggy IGGY_PASSWORD=secret iggy topic create teststream testtopic 1 none")

    with subtest("send message"):
        server.succeed("IGGY_USERNAME=iggy IGGY_PASSWORD=secret iggy message send teststream testtopic 'hello iggy'")

    with subtest("poll message"):
        server.succeed("IGGY_USERNAME=iggy IGGY_PASSWORD=secret iggy message poll --offset 0 teststream testtopic 0 | grep 'hello iggy'")

    with subtest("mcp server check"):
        mcp.start()
        mcp.wait_for_unit("iggy-mcp.service")
        mcp.wait_for_open_port(8082)
        mcp.succeed("curl -sf http://127.0.0.1:8082/health | grep -q 'healthy'")
  '';
}
