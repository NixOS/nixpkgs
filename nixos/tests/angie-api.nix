import ./make-test-python.nix (
  { lib, pkgs, ... }:
  let
    hosts = ''
      192.168.2.101 example.com
      192.168.2.101 api.example.com
      192.168.2.101 backend.example.com
    '';

  in
  {
    name = "angie-api";
    meta.maintainers = with pkgs.lib.maintainers; [ izorkin ];

    nodes = {
      server =
        { pkgs, ... }:
        {
          networking = {
            interfaces.eth1 = {
              ipv4.addresses = [
                {
                  address = "192.168.2.101";
                  prefixLength = 24;
                }
              ];
            };
            extraHosts = hosts;
            firewall.allowedTCPPorts = [ 80 ];
          };

          services.nginx = {
            enable = true;
            package = pkgs.angie;

            upstreams = {
              "backend-http" = {
                servers = {
                  "backend.example.com:8080" = {
                    fail_timeout = "0";
                  };
                };
                extraConfig = ''
                  zone upstream 256k;
                '';
              };
              "backend-socket" = {
                servers = {
                  "unix:/run/example.sock" = {
                    fail_timeout = "0";
                  };
                };
                extraConfig = ''
                  zone upstream 256k;
                '';
              };
            };

            virtualHosts."api.example.com" = {
              locations."/console/" = {
                extraConfig = ''
                  api /status/;

                  allow 192.168.2.201;
                  deny all;
                '';
              };
            };

            virtualHosts."example.com" = {
              locations."/test/" = {
                root = lib.mkForce (
                  pkgs.runCommandLocal "testdir" { } ''
                    mkdir -p "$out/test"
                    cat > "$out/test/index.html" <<EOF
                    <html><body>Hello World!</body></html>
                    EOF
                  ''
                );
                extraConfig = ''
                  status_zone test_zone;

                  allow 192.168.2.201;
                  deny all;
                '';
              };
              locations."/test/locked/" = {
                extraConfig = ''
                  status_zone test_zone;

                  deny all;
                '';
              };
              locations."/test/error/" = {
                extraConfig = ''
                  status_zone test_zone;

                  allow all;
                '';
              };
              locations."/upstream-http/" = {
                proxyPass = "http://backend-http";
              };
              locations."/upstream-socket/" = {
                proxyPass = "http://backend-socket";
              };
            };
          };
        };

      client =
        { pkgs, ... }:
        {
          environment.systemPackages = [ pkgs.jq ];
          networking = {
            interfaces.eth1 = {
              ipv4.addresses = [
                {
                  address = "192.168.2.201";
                  prefixLength = 24;
                }
              ];
            };
            extraHosts = hosts;
          };
        };
    };

    testScript = ''
      start_all()

      server.wait_for_unit("nginx")
      server.wait_for_open_port(80)

      # Check Angie version
      client.succeed("curl --verbose http://api.example.com/console/ | jq -e '.angie.version' | grep '${pkgs.angie.version}'")

      # Check access
      client.succeed("curl --verbose --head http://api.example.com/console/ | grep 'HTTP/1.1 200'")
      server.succeed("curl --verbose --head http://api.example.com/console/ | grep 'HTTP/1.1 403 Forbidden'")

      # Check responses and requests
      client.succeed("curl --verbose http://example.com/test/")
      client.succeed("curl --verbose http://example.com/test/locked/")
      client.succeed("curl --verbose http://example.com/test/locked/")
      client.succeed("curl --verbose http://example.com/test/error/")
      client.succeed("curl --verbose http://example.com/test/error/")
      client.succeed("curl --verbose http://example.com/test/error/")
      server.succeed("curl --verbose http://example.com/test/")
      client.succeed("curl --verbose http://api.example.com/console/ | jq -e '.http.location_zones.test_zone.responses.\"200\"' | grep '1'")
      client.succeed("curl --verbose http://api.example.com/console/ | jq -e '.http.location_zones.test_zone.responses.\"403\"' | grep '3'")
      client.succeed("curl --verbose http://api.example.com/console/ | jq -e '.http.location_zones.test_zone.responses.\"404\"' | grep '3'")
      client.succeed("curl --verbose http://api.example.com/console/ | jq -e '.http.location_zones.test_zone.requests.total' | grep '7'")

      # Check upstreams
      client.succeed("curl --verbose http://api.example.com/console/ | jq -e '.http.upstreams.\"backend-http\".peers.\"192.168.2.101:8080\".state' | grep 'up'")
      client.succeed("curl --verbose http://api.example.com/console/ | jq -e '.http.upstreams.\"backend-http\".peers.\"192.168.2.101:8080\".health.fails' | grep '0'")
      client.succeed("curl --verbose http://api.example.com/console/ | jq -e '.http.upstreams.\"backend-socket\".peers.\"unix:/run/example.sock\".state' | grep 'up'")
      client.succeed("curl --verbose http://api.example.com/console/ | jq -e '.http.upstreams.\"backend-socket\".peers.\"unix:/run/example.sock\".health.fails' | grep '0'")
      client.succeed("curl --verbose http://example.com/upstream-http/")
      client.succeed("curl --verbose http://example.com/upstream-socket/")
      client.succeed("curl --verbose http://example.com/upstream-socket/")
      client.succeed("curl --verbose http://api.example.com/console/ | jq -e '.http.upstreams.\"backend-http\".peers.\"192.168.2.101:8080\".health.fails' | grep '1'")
      client.succeed("curl --verbose http://api.example.com/console/ | jq -e '.http.upstreams.\"backend-socket\".peers.\"unix:/run/example.sock\".health.fails' | grep '2'")

      server.shutdown()
      client.shutdown()
    '';
  }
)
