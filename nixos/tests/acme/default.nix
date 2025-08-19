{ runTest }:
let
  domain = "example.test";
in
{
  http01-builtin = runTest ./http01-builtin.nix;
  dns01 = runTest ./dns01.nix;
  caddy = runTest ./caddy.nix;
  nginx = runTest (
    import ./webserver.nix {
      inherit domain;
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
          };
        };
        specialisation.nullroot.configuration = {
          services.nginx.virtualHosts."nullroot.${domain}".acmeFallbackHost = "localhost:8081";
        };
      };
    }
  );
  httpd = runTest (
    import ./webserver.nix {
      inherit domain;
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
        specialisation.nullroot.configuration = {
          services.httpd.virtualHosts."nullroot.${domain}" = {
            locations."/.well-known/acme-challenge" = {
              proxyPass = "http://localhost:8081/.well-known/acme-challenge";
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
