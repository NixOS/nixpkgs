{ lib, ... }:
{
  name = "flarum";

  meta = {
    maintainers = with lib.maintainers; [
      fsagbuya
      jasonodoom
    ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      # Flarum installs and migrates the database on first boot and runs a
      # MariaDB server alongside PHP-FPM and nginx, so give the VM some headroom.
      virtualisation.memorySize = 2048;

      services.flarum = {
        enable = true;
        forumTitle = "NixOS Flarum Test Forum";
        domain = "localhost";
        baseUrl = "http://localhost";

        # Run `flarum install` against the locally provisioned MariaDB. Safe here
        # because the VM always starts from a fresh, empty database.
        createDatabaseLocally = true;

        adminUser = "admin";
        adminEmail = "admin@example.com";
        # The trailing newline matches how secret managers typically write files.
        initialAdminPasswordFile = "${pkgs.writeText "admin-pass" "flarum-admin-password\n"}";
        # MariaDB authenticates via unix socket and never checks this password;
        # setting it still exercises the substitution path.
        databasePasswordFile = "${pkgs.writeText "db-pass" "flarum-db-password\n"}";
      };
    };

  testScript = ''
    start_all()

    # PHP-FPM is ordered after the oneshot installer (Type=oneshot, no
    # RemainAfterExit), so waiting on it implies the install/migrate finished.
    machine.wait_for_unit("phpfpm-flarum.service")
    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(80)

    # The forum front page is server-rendered and embeds the configured title.
    machine.wait_until_succeeds("curl -sf http://localhost/ -o /dev/null")
    machine.succeed("curl -sf http://localhost/ | grep -F 'NixOS Flarum Test Forum'")

    # The admin API endpoint should respond, confirming the app booted cleanly.
    machine.succeed("curl -sf http://localhost/api -o /dev/null")

    # Only the placeholders may appear in the install config in the Nix store.
    machine.succeed("grep -q '@adminPassword@' /nix/store/*-config.json")
    machine.succeed("grep -q '@databasePassword@' /nix/store/*-config.json")
    machine.fail("grep -qe 'flarum-admin-password' -e 'flarum-db-password' /nix/store/*-config.json")

    # A successful login proves the admin password was substituted intact.
    machine.succeed(
        "curl -sf http://localhost/api/token "
        + "-H 'Content-Type: application/json' "
        + "-d '{\"identification\": \"admin\", \"password\": \"flarum-admin-password\"}' "
        + "| grep -F token"
    )

    # The database password must arrive intact in config.php, which must
    # not be world-readable.
    machine.succeed("grep -q 'flarum-db-password' /var/lib/flarum/config.php")
    machine.succeed("[ $(stat -c %a /var/lib/flarum/config.php) = 600 ]")

    # `flarum install` must not rerun on later activations, or it errors out
    # since the database already exists.
    machine.succeed(
        "echo 'create table nixos_test_marker (id int); insert into nixos_test_marker values (1);' "
        + "| sudo -u flarum mysql -u flarum flarum"
    )
    machine.succeed("systemctl restart flarum-install.service")
    machine.succeed(
        "echo 'select id from nixos_test_marker;' | sudo -u flarum mysql -u flarum flarum -N | grep -q 1"
    )
    machine.succeed("[ -f /var/lib/flarum/.flarum-installed ]")
  '';
}
