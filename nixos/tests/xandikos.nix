import ./make-test-python.nix (
  { pkgs, lib, ... }:

  {
    name = "xandikos";

    meta.maintainers = with lib.maintainers; [ _0x4A6F ];

    nodes = {
      xandikos_client = { };
      xandikos_default = {
        networking.firewall.allowedTCPPorts = [ 8080 ];
        services.xandikos.enable = true;
      };
      xandikos_proxy = {
        networking.firewall.allowedTCPPorts = [
          80
          8080
        ];
        services.xandikos.enable = true;
        services.xandikos.address = "localhost";
        services.xandikos.port = 8080;
        services.xandikos.routePrefix = "/xandikos-prefix/";
        services.xandikos.extraOptions = [
          "--defaults"
        ];
        services.nginx = {
          enable = true;
          recommendedProxySettings = true;
          virtualHosts."xandikos" = {
            serverName = "xandikos.local";
            basicAuth.xandikos = "snakeOilPassword";
            locations."/xandikos/" = {
              proxyPass = "http://localhost:8080/xandikos-prefix/";
            };
          };
        };
      };
    };

    testScript = ''
      start_all()

      with subtest("Xandikos default"):
          xandikos_default.wait_for_unit("multi-user.target")
          xandikos_default.wait_for_unit("xandikos.service")
          xandikos_default.wait_for_open_port(8080)
          xandikos_default.succeed("curl --fail http://localhost:8080/")
          xandikos_default.succeed(
              "curl -s --fail --location http://localhost:8080/ | grep -i Xandikos"
          )
          xandikos_client.wait_for_unit("network.target")
          xandikos_client.fail("curl --fail http://xandikos_default:8080/")

      with subtest("Xandikos proxy"):
          xandikos_proxy.wait_for_unit("multi-user.target")
          xandikos_proxy.wait_for_unit("xandikos.service")
          xandikos_proxy.wait_for_open_port(8080)
          xandikos_proxy.succeed("curl --fail http://localhost:8080/")
          xandikos_proxy.succeed(
              "curl -s --fail --location http://localhost:8080/ | grep -i Xandikos"
          )
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
)
