{ lib, ... }:
let
  nodes = {

    "drupal_nginx" = _: {
      services.drupal.webserver = "nginx";
      services.drupal.enable = true;
      services.drupal.sites = {
        "site1.local" = {
          database.tablePrefix = "site1_";
          enable = true;
        };
        "site2.local" = {
          database.tablePrefix = "site2_";
          enable = true;
        };
      };

      networking.firewall.allowedTCPPorts = [ 80 ];
      networking.hosts."127.0.0.1" = [
        "site1.local"
        "site2.local"
      ];
    };

    "drupal_caddy" = _: {
      services.drupal.enable = true;
      services.drupal.webserver = "caddy";
      services.drupal.sites = {
        "site1.local" = {
          enable = true;
          database.tablePrefix = "site1_";
        };
        "site2.local" = {
          enable = true;
          database.tablePrefix = "site2_";
        };
      };

      networking.firewall.allowedTCPPorts = [
        80
        443
      ];
      networking.hosts."127.0.0.1" = [
        "site1.local"
        "site2.local"
      ];
    };
  };
in
{
  name = "drupal";
  meta.maintainers = [
    lib.maintainers.drupol
    lib.maintainers.OulipianSummer
  ];

  inherit nodes;

  testScript = ''
    start_all()

    ${lib.concatStrings (
      lib.mapAttrsToList (name: value: ''
        ${name}.wait_for_unit("${(value null).services.drupal.webserver}")
      '') nodes
    )}

    site_names = ["site1.local", "site2.local"]

    for machine in (${lib.concatStringsSep ", " (builtins.attrNames nodes)}):
        for site_name in site_names:
            machine.wait_for_unit(f"phpfpm-drupal-{site_name}")

            with subtest("website returns welcome screen"):
                assert "Choose language" in machine.succeed(f"curl -k -L {site_name}")

            with subtest("website is installable"):
                assert "Database configuration" in machine.succeed(f"curl -k -L \"{site_name}/core/install.php?langcode=en&profile=standard\"")

            with subtest("drupal-state-init went through"):
                info = machine.get_unit_info(f"drupal-state-init-{site_name}")
                assert info["Result"] == "success"
  '';
}
