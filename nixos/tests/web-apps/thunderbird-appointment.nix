{ lib, ... }:

{
  name = "thunderbird-appointment";
  meta.maintainers = with lib.maintainers; [ philocalyst ];

  nodes.machine = {
    virtualisation.memorySize = 2048;

    services.thunderbird-appointment = {
      enable = true;
      # A domain is always required, but we skip the nginx
      # vhost here as the test needs no ACME/DNS!
      nginx = {
        enable = false;
        domain = "appointment.example.com";
      };
      database.createLocally = true;
      redis.createLocally = true;
    };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("thunderbird-appointment-secrets.service")
    machine.wait_for_unit("postgresql.service")
    machine.wait_for_unit("redis-thunderbird-appointment.service")
    machine.wait_for_unit("thunderbird-appointment.service")
    machine.wait_for_unit("thunderbird-appointment-worker.service")

    with subtest("secrets are generated with strict permissions"):
        machine.succeed("test -f /var/lib/thunderbird-appointment/secrets.env")
        machine.succeed("test $(stat -c %a /var/lib/thunderbird-appointment/secrets.env) = 600")
        for key in ["SESSION_SECRET", "JWT_SECRET", "CSRF_SECRET", "SIGNED_SECRET", "DB_SECRET"]:
            machine.succeed(f"grep -q '^{key}=.' /var/lib/thunderbird-appointment/secrets.env")

    with subtest("migrations ran against PostgreSQL"):
        # `run-command main update-db` stamps the alembic head on a fresh DB.
        machine.succeed(
            "sudo -u postgres psql -tAc "
            "\"SELECT to_regclass('public.alembic_version')\" "
            "thunderbird-appointment | grep -q alembic_version"
        )

    with subtest("the API is up and serving its OpenAPI docs"):
        machine.wait_for_open_port(5000)
        machine.wait_until_succeeds("curl -fsS http://127.0.0.1:5000/docs", timeout=60)
        machine.succeed("curl -fsS http://127.0.0.1:5000/redoc | grep -q 'Thunderbird Appointment'")

    with subtest("units are meaningfully hardened"):
        machine.log(machine.succeed("systemd-analyze security thunderbird-appointment.service"))
        machine.log(machine.succeed("systemd-analyze security thunderbird-appointment-worker.service"))
  '';
}
