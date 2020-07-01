import ./make-test-python.nix ({ pkgs, ... }:

{
  name = "wordpress";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [
      flokli
      grahamc # under duress!
      mmilata
    ];
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
    };

  testScript = ''
    import re

    start_all()

    machine.wait_for_unit("httpd")

    machine.wait_for_unit("phpfpm-wordpress-site1.local")
    machine.wait_for_unit("phpfpm-wordpress-site2.local")

    site_names = ["site1.local", "site2.local"]

    with subtest("website returns welcome screen"):
        for site_name in site_names:
            assert "Welcome to the famous" in machine.succeed(f"curl -L {site_name}")

    with subtest("wordpress-init went through"):
        for site_name in site_names:
            info = machine.get_unit_info(f"wordpress-init-{site_name}")
            assert info["Result"] == "success"

    with subtest("secret keys are set"):
        pattern = re.compile(r"^define.*NONCE_SALT.{64,};$", re.MULTILINE)
        for site_name in site_names:
            assert pattern.search(
                machine.succeed(f"cat /var/lib/wordpress/{site_name}/secret-keys.php")
            )
  '';
})
