import ./make-test-python.nix ({ pkgs, ... }: let
  domain = "example.com";
  fakeIp = "203.0.113.42";
in {
  name = "dns-over-https";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ dwoffinden ];
  };
  nodes = {
    server = { nodes, ... }:
    {
      services.unbound = {
        enable = true;
        extraConfig = ''
          local-zone: "${domain}." static
          local-data: "${domain}. 10800 IN A ${fakeIp}"
        '';
      };
      services.dns-over-https = {
        verbose = true;
        server = {
          enable = true;
          listen = [ ":80" ];
          upstream = [ "udp:127.0.0.1:53" ];
        };
      };
      networking.firewall.allowedTCPPorts = [ 80 ];
    };
    client = { config, lib, nodes, ... }:
    {
      services.dns-over-https = {
        verbose = true;
        client = {
          enable = true;
          bootstrap = [];
          listen = [ ":53" ];
          upstream = [
            { url = "http://${nodes.server.config.networking.primaryIPAddress}/dns-query"; }
          ];
        };
      };
    };
  };
  testScript = { nodes,  ... }: let
    serverIp = nodes.server.config.networking.primaryIPAddress;
  in ''
    start_all()
    server.wait_for_unit("unbound")
    server.wait_for_unit("doh-server")
    client.wait_for_unit("doh-client")

    with subtest("Server correctly configured"):
        assert "${fakeIp}" in server.succeed("host ${domain} localhost")

    with subtest("Server returns correct result over HTTP"):
        assert "${fakeIp}" in client.succeed(
            "curl 'http://${serverIp}/dns-query?name=${domain}&type=A'"
        )

    with subtest("Client fetches correct result over HTTP"):
        assert "${fakeIp}" in client.succeed("host ${domain} localhost")
  '';
})
