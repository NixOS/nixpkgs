let
  nginxRoot = "/run/nginx";
in
  import ./make-test.nix ({...}: {
    name  = "nghttpx";
    nodes = {
      webserver = {
        networking.firewall.allowedTCPPorts = [ 80 ];
        systemd.services.nginx = {
          preStart = ''
            mkdir -p ${nginxRoot}
            echo "Hello world!" > ${nginxRoot}/hello-world.txt
          '';
        };

        services.nginx = {
          enable = true;
          virtualHosts."server" = {
            locations."/".root = nginxRoot;
          };
        };
      };

      proxy = {
        networking.firewall.allowedTCPPorts = [ 80 ];
        services.nghttpx = {
          enable = true;
          frontends = [
            { server = {
                host = "*";
                port = 80;
              };

              params = {
                tls = "no-tls";
              };
            }
          ];
          backends = [
            { server = {
                host = "webserver";
                port = 80;
              };
              patterns = [ "/" ];
              params.proto = "http/1.1";
            }
          ];
        };
      };

      client = {};
    };

    testScript = ''
      startAll;

      $webserver->waitForOpenPort("80");
      $proxy->waitForOpenPort("80");
      $client->waitUntilSucceeds("curl -s --fail http://proxy/hello-world.txt");
    '';
  })
