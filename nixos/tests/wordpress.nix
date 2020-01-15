import ./make-test.nix ({ pkgs, ... }:

{
  name = "wordpress";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ grahamc ]; # under duress!
  };

  machine =
    { ... }:
    { services.httpd.adminAddr = "webmaster@site.local";
      services.httpd.logPerVirtualHost = true;

      services.wordpress."site1.local" = {
        database.tablePrefix = "site1_";
      };

      services.wordpress."site2.local" = {
        database.tablePrefix = "site2_";
      };

      networking.hosts."127.0.0.1" = [ "site1.local" "site2.local" ];

      # required for wordpress-init.service to succeed
      systemd.tmpfiles.rules = [
        "F /var/lib/wordpress/site1.local/secret-keys.php 0440 wordpress wwwrun - -"
        "F /var/lib/wordpress/site2.local/secret-keys.php 0440 wordpress wwwrun - -"
      ];
    };

  testScript = ''
    startAll;

    $machine->waitForUnit("httpd");
    $machine->waitForUnit("phpfpm-wordpress-site1.local");
    $machine->waitForUnit("phpfpm-wordpress-site2.local");

    $machine->succeed("curl -L site1.local | grep 'Welcome to the famous'");
    $machine->succeed("curl -L site2.local | grep 'Welcome to the famous'");
  '';

})
