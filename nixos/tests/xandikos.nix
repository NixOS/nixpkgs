{ lib, ... }:

{
  name = "xandikos";

  meta.maintainers = with lib.maintainers; [ _0x4A6F ];

  nodes = {
    xandikos_client = { };
    xandikos_default = {
      networking.firewall.allowedTCPPorts = [
        8080
        8081
      ];
      services.xandikos = {
        enable = true;
        metrics.enable = true;
      };
    };
    xandikos_proxy = {
      networking.firewall.allowedTCPPorts = [
        80
        8080
      ];
      services.xandikos = {
        enable = true;
        address = [
          "127.0.0.1:8080"
          "[::1]:8080"
          "/run/xandikos/socket"
        ];
        routePrefix = "/xandikos-prefix/";
        extraOptions = [
          "--defaults"
        ];
      };
      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        virtualHosts."xandikos" = {
          serverName = "xandikos.local";
          basicAuth.xandikos = "snakeOilPassword";
          locations."/xandikos/" = {
            proxyPass = "http://unix:/run/xandikos/socket:/xandikos-prefix/";
          };
        };
      };
    };
  };

  testScript = ''
    start_all()

    with subtest("Xandikos default"):
        xandikos_default.wait_for_unit("sockets.target")
        xandikos_default.succeed("curl --fail http://localhost:8080/")
        xandikos_default.succeed(
            "curl -s --fail --location http://localhost:8080/ | grep -i Xandikos"
        )
        xandikos_default.succeed("curl -s --fail --location http://localhost:8081/metrics")
        xandikos_client.wait_for_unit("network.target")
        xandikos_client.fail("curl --fail http://xandikos_default:8080/")
        xandikos_client.fail("curl --fail http://xandikos_default:8081/metrics")

    with subtest("Xandikos proxy"):
        xandikos_proxy.wait_for_unit("sockets.target")
        xandikos_proxy.succeed("curl --fail http://localhost:8080/")
        xandikos_proxy.succeed(
            "curl -s --fail --location http://localhost:8080/ | grep -i Xandikos"
        )
        xandikos_client.fail("curl --fail http://xandikos_default:8081/metrics")
        xandikos_client.wait_for_unit("network.target")
        xandikos_client.fail("curl --fail http://xandikos_proxy:8080/")
        xandikos_client.succeed(
            "curl -s --fail -u xandikos:snakeOilPassword -H 'Host: xandikos.local' http://xandikos_proxy/xandikos/ | grep -i Xandikos"
        )
        xandikos_client.succeed(
            "curl -s --fail -u xandikos:snakeOilPassword -H 'Host: xandikos.local' http://xandikos_proxy/xandikos/user/ | grep -i Xandikos"
        )
  '';
}
