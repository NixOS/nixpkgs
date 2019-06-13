import ./make-test.nix ({ pkgs, ... }:

{
  name = "wordpress";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ grahamc ]; # under duress!
  };

  nodes =
    { web =
        { pkgs, ... }:
        {
          services.mysql = {
            enable = true;
            package = pkgs.mysql;
          };
          services.httpd = {
            enable = true;
            logPerVirtualHost = true;
            adminAddr="js@lastlog.de";

            virtualHosts = [
              {
                hostName = "wordpress";
                extraSubservices =
                  [
                    {
                      serviceType = "wordpress";
                      dbPassword = "wordpress";
                      dbHost = "127.0.0.1";
                      languages = [ "de_DE" "en_GB" ];
                    }
                  ];
              }
            ];
          };
        };
    };

  testScript =
    { ... }:
    ''
      startAll;

      $web->waitForUnit("mysql");
      $web->waitForUnit("httpd");

      $web->succeed("curl -L 127.0.0.1:80 | grep 'Welcome to the famous'");


    '';

})
