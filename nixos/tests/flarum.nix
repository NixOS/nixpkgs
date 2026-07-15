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
    { ... }:
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
        # Flarum rejects admin passwords shorter than 8 characters.
        initialAdminPassword = "flarum-admin-password";
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
  '';
}
