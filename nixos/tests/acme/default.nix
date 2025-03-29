{ runTest }:
{
  http01-builtin = runTest ./http01-builtin.nix;
  dns01 = runTest ./dns01.nix;
  caddy = runTest ./caddy.nix;
  nginx = runTest (
    import ./webserver.nix {
      serverName = "nginx";
      group = "nginx";
      baseModule = {
        services.nginx = {
          enable = true;
          enableReload = true;
          logError = "stderr info";
          # This tests a number of things at once:
          #   - Self-signed certs are in place before the webserver startup
          #   - Nginx is started before acme renewal is attempted
          #   - useACMEHost behaves as expected
          #   - acmeFallbackHost behaves as expected
          virtualHosts.default = {
            default = true;
            addSSL = true;
            useACMEHost = "proxied.example.test";
            acmeFallbackHost = "localhost:8080";
            # lego will refuse the request if the host header is not correct
            extraConfig = ''
              proxy_set_header Host $host;
            '';
          };
        };
      };
    }
  );
  httpd = runTest (
    import ./webserver.nix {
      serverName = "httpd";
      group = "wwwrun";
      baseModule = {
        services.httpd = {
          enable = true;
          # This is the default by virtue of being the first defined vhost.
          virtualHosts.default = {
            addSSL = true;
            useACMEHost = "proxied.example.test";
            locations."/.well-known/acme-challenge" = {
              proxyPass = "http://localhost:8080/.well-known/acme-challenge";
              extraConfig = ''
                ProxyPreserveHost On
              '';
            };
          };
        };
      };
    }
  );
}
