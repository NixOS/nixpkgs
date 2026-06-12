{ pkgs, ... }:
{
  name = "cloudflared";

  nodes.machine = _: {
    services.cloudflared = {
      enable = true;
      tunnels."00000000-0000-0000-0000-000000000000" = {
        # set all available options, to make sure they exist and are properly formatted.
        credentialsFile = "/tmp/test";
        certificateFile = "/tmp/cert.pem";
        default = "http_status:404";
        originRequest = {
          tlsTimeout = "30s";
          tcpKeepAlive = "30s";
          proxyType = "socks";
          proxyPort = 1055;
          proxyAddress = "127.0.0.1";
          originServerName = "example.com";
          noTLSVerify = false;
          noHappyEyeballs = false;
          keepAliveTimeout = "1m30s";
          keepAliveConnections = 100;
          httpHostHeader = "example.com";
          disableChunkedEncoding = false;
          connectTimeout = "30s";
          caPool = "/tmp/ca.pem";
          matchSNItoHost = true;
          http2Origin = true;
        };
        ingress = {
          "example.com" = "http://localhost:8080";
        };
      };
    };
  };

  testScript =
    {
      nodes,
      ...
    }:
    let
      cloudflared = pkgs.lib.getExe pkgs.cloudflared;
    in
    ''
      start_all()

      # Verify the generated configs are valid.
      machine.succeed("test -n \"$(${cloudflared} tunnel --config ${
        nodes.machine.services.cloudflared.tunnels."00000000-0000-0000-0000-000000000000".configFile
      } ingress validate | grep OK)\"")
    '';
}
