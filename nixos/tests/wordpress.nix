import ./make-test.nix ({ pkgs, ... }:

{
  name = "wordpress";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ grahamc ]; # under duress!
  };

  nodes =
    { web =
        { config, pkgs, ... }:
        {
          services.mysql.enable = true;
          services.mysql.package = pkgs.mysql;
          services.mysql.initialScript = pkgs.writeText "start.sql" ''
            CREATE DATABASE wordpress;
	    CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'wordpress';
            GRANT ALL on wordpress.* TO 'wordpress'@'localhost';
          '';

          services.httpd = {
            enable = true;
            logPerVirtualHost = true;
            adminAddr="js@lastlog.de";
            extraModules = [
              { name = "php7"; path = "${pkgs.php}/modules/libphp7.so"; }
            ];

            virtualHosts = [
              {
                hostName = "wordpress";
                extraSubservices =
                  [
                    {
                      serviceType = "wordpress";
                      dbPassword = "wordpress";
                      wordpressUploads = "/data/uploads";
                      languages = [ "de_DE" "en_GB" ];
                    }
                  ];
              }
            ];
          };
        };
    };

  testScript =
    { nodes, ... }:
    ''
      startAll;

      $web->waitForUnit("mysql");
      $web->waitForUnit("httpd");

      $web->succeed("curl -L 127.0.0.1:80 | grep 'Welcome to the famous'");


    '';

})
