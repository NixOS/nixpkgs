import ./make-test-python.nix (
  { lib, ... }:
  {
    name = "thunderbird-appointment";
    meta.maintainers = [ ];

    nodes.machine =
      { config, pkgs, ... }:
      {
        services.thunderbird-appointment = {
          enable = true;
          nginx.enable = false; # test without nginx for simplicity
          settings = {
            allowFirstTimeRegister = true;
            secretKey = "test-secret-for-nixos-test-do-not-use-in-prod";
            dbUrl = "sqlite:////var/lib/thunderbird-appointment/test.db"; # use sqlite for faster test
          };
          database.createLocally = false;
          redis.createLocally = true;
        };

        # Allow first-time setup
        environment.variables.APP_ALLOW_FIRST_TIME_REGISTER = "True";
      };

    testScript = ''
      machine.start()
      machine.wait_for_unit("thunderbird-appointment.service")
      machine.wait_for_unit("thunderbird-appointment-celery.service")
      machine.wait_for_unit("thunderbird-appointment-beat.service")
      machine.wait_for_unit("redis-thunderbird-appointment.service")

      # Check frontend and API (backend serves on 5000 by default in test)
      machine.wait_until_succeeds("curl -fs http://localhost:5000/docs", timeout=30)
      machine.succeed("curl -fs http://localhost:5000/redoc | grep -q 'Thunderbird Appointment'")

      # Test CLI (matches backend testing and pretix test)
      machine.succeed("run-command main --help")
      machine.succeed("run-command main update-db")

      # Security check (matching pretix.nix and lasuite-docs style)
      machine.log(machine.succeed("systemd-analyze security thunderbird-appointment.service"))
      machine.log(machine.succeed("systemd-analyze security thunderbird-appointment-celery.service"))

      # Basic functionality: first-time register simulation (DB table check)
      machine.succeed("sqlite3 /var/lib/thunderbird-appointment/test.db 'SELECT name FROM sqlite_master WHERE type=\"table\";' | grep -q subscriber")

      machine.log("Thunderbird Appointment test passed successfully.")
    '';
  }
)
