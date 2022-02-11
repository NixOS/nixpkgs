import ./make-test-python.nix ({ pkgs, ... }:

{
  name = "wordpress";
  meta = with pkgs.lib.maintainers; {
    maintainers = [
      flokli
      grahamc # under duress!
      mmilata
    ];
  };

  nodes = {
    wp_httpd = { ... }: {
      services.httpd.adminAddr = "webmaster@site.local";
      services.httpd.logPerVirtualHost = true;

      services.wordpress.sites = {
        "site1.local" = {
          database.tablePrefix = "site1_";
        };
        "site2.local" = {
          database.tablePrefix = "site2_";
        };
      };

      networking.firewall.allowedTCPPorts = [ 80 ];
      networking.hosts."127.0.0.1" = [ "site1.local" "site2.local" ];
    };

    wp_nginx = { ... }: {
      services.wordpress.webserver = "nginx";
      services.wordpress.sites = {
        "site1.local" = {
          database.tablePrefix = "site1_";
        };
        "site2.local" = {
          database.tablePrefix = "site2_";
        };
      };

      networking.firewall.allowedTCPPorts = [ 80 ];
      networking.hosts."127.0.0.1" = [ "site1.local" "site2.local" ];
    };

    wp_caddy = { ... }: {
      services.wordpress.webserver = "caddy";
      services.wordpress.sites = {
        "site1.local" = {
          database.tablePrefix = "site1_";
        };
        "site2.local" = {
          database.tablePrefix = "site2_";
        };
      };

      networking.firewall.allowedTCPPorts = [ 80 ];
      networking.hosts."127.0.0.1" = [ "site1.local" "site2.local" ];
    };
  };

  testScript = ''
    import re

    start_all()

    wp_httpd.wait_for_unit("httpd")
    wp_nginx.wait_for_unit("nginx")
    wp_caddy.wait_for_unit("caddy")

    site_names = ["site1.local", "site2.local"]

    for machine in (wp_httpd, wp_nginx, wp_caddy):
        for site_name in site_names:
            machine.wait_for_unit(f"phpfpm-wordpress-{site_name}")

            with subtest("website returns welcome screen"):
                assert "Welcome to the famous" in machine.succeed(f"curl -L {site_name}")

            with subtest("wordpress-init went through"):
                info = machine.get_unit_info(f"wordpress-init-{site_name}")
                assert info["Result"] == "success"

            with subtest("secret keys are set"):
                pattern = re.compile(r"^define.*NONCE_SALT.{64,};$", re.MULTILINE)
                assert pattern.search(
                    machine.succeed(f"cat /var/lib/wordpress/{site_name}/secret-keys.php")
                )
  '';
})
