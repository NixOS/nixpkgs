import ./make-test-python.nix (
  { lib, pkgs, ... }:

  rec {
    name = "wordpress";
    meta = with pkgs.lib.maintainers; {
      maintainers = [
        flokli
        grahamc # under duress!
        mmilata
      ];
    };

    nodes =
      lib.foldl
        (
          a: version:
          let
            package = pkgs."wordpress_${version}";
          in
          a
          // {
            "wp${version}_httpd" = _: {
              services.httpd.adminAddr = "webmaster@site.local";
              services.httpd.logPerVirtualHost = true;

              services.wordpress.webserver = "httpd";
              services.wordpress.sites = {
                "site1.local" = {
                  database.tablePrefix = "site1_";
                  inherit package;
                };
                "site2.local" = {
                  database.tablePrefix = "site2_";
                  inherit package;
                };
              };

              networking.firewall.allowedTCPPorts = [ 80 ];
              networking.hosts."127.0.0.1" = [
                "site1.local"
                "site2.local"
              ];
            };

            "wp${version}_nginx" = _: {
              services.wordpress.webserver = "nginx";
              services.wordpress.sites = {
                "site1.local" = {
                  database.tablePrefix = "site1_";
                  inherit package;
                };
                "site2.local" = {
                  database.tablePrefix = "site2_";
                  inherit package;
                };
              };

              networking.firewall.allowedTCPPorts = [ 80 ];
              networking.hosts."127.0.0.1" = [
                "site1.local"
                "site2.local"
              ];
            };

            "wp${version}_caddy" = _: {
              services.wordpress.webserver = "caddy";
              services.wordpress.sites = {
                "site1.local" = {
                  database.tablePrefix = "site1_";
                  inherit package;
                };
                "site2.local" = {
                  database.tablePrefix = "site2_";
                  inherit package;
                };
              };

              networking.firewall.allowedTCPPorts = [ 80 ];
              networking.hosts."127.0.0.1" = [
                "site1.local"
                "site2.local"
              ];
            };
          }
        )
        { }
        [
          "6_7"
        ];

    testScript = ''
      import re

      start_all()

      ${lib.concatStrings (
        lib.mapAttrsToList (name: value: ''
          ${name}.wait_for_unit("${(value null).services.wordpress.webserver}")
        '') nodes
      )}

      site_names = ["site1.local", "site2.local"]

      for machine in (${lib.concatStringsSep ", " (builtins.attrNames nodes)}):
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
  }
)
