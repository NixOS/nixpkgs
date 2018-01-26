import ./make-test.nix ({ pkgs, ... }:

{
  name = "owncloud";
  nodes =
    { web =
        { config, pkgs, ... }:
        {
          services.postgresql.enable = true;
          services.httpd = {
            enable = true;
            logPerVirtualHost = true;
            adminAddr = "example@example.com";
            virtualHosts = [
              {
                hostName = "owncloud";
                extraSubservices =
                  [
                    {
                      serviceType   = "owncloud";
                      adminPassword = "secret";
                      dbPassword    = "secret";
                    }
                  ];
              }
            ];
          };
        };
    };

  testScript = ''
    startAll;

    $web->waitForUnit("postgresql");
    $web->waitForUnit("httpd");

    $web->succeed("curl -L 127.0.0.1:80");
  '';
})
