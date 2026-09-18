{ runTest }:

let
  secretKeybase = "nannannannannannannannannannannannannannannannannannannan_batman!";

  # A fixed bcrypt password hash is fine for a test; the plaintext is never
  # needed because the test only checks that an admin user exists (and thus the
  # "first launch" setup wizard is unreachable), not that login with the
  # password works.
  adminEmail = "admin@localhost";

  mkPlausibleTest =
    {
      seedAdmin ? false,
    }:
    runTest (
      { lib, pkgs, ... }:
      let
        adminPassword = "correct-horse-battery-staple";
        adminPasswordHashFile = pkgs.runCommand "plausible-admin-password-hash" { } ''
          ${lib.getExe pkgs.mkpasswd} -m bcrypt ${lib.escapeShellArg adminPassword} > "$out"
        '';
      in
      {
        name = "plausible" + lib.optionalString seedAdmin "-declarative-admin-user";
        meta = {
          maintainers = with lib.maintainers; [
            nh2
            stepbrobd
          ];
        };

        nodes.machine = {
          # On first boot, the ClickHouse migrations run by Plausible's
          # `migrate.sh` intermittently fail with `(Mint.TransportError) socket
          # closed`, which aborts startup before the web server opens its port.
          # The failure is transient and succeeds on a subsequent attempt, so
          # retry startup without a rate limit until the port opens. (Without
          # this, the test is flaky.)
          systemd.services.plausible.serviceConfig.Restart = lib.mkForce "always";
          systemd.services.plausible.serviceConfig.RestartSec = 1;
          systemd.services.plausible.unitConfig.StartLimitIntervalSec = 0;

          services.plausible = {
            enable = true;
            adminUser = lib.mkIf seedAdmin {
              email = adminEmail;
              name = "Test Admin";
              passwordHashFile = "${adminPasswordHashFile}";
            };
            server = {
              baseUrl = "http://localhost:8000";
              secretKeybaseFile = builtins.toFile "plausible-test-secret-keybase-file" secretKeybase;
            };
          };
        };

        testScript = ''
          machine.wait_for_unit("plausible.service")
          machine.wait_for_open_port(8000)

          # Ensure that the software does not make the machine
          # listen on any public interfaces by default.
          machine.fail("ss -tlpn 'src = 0.0.0.0 or src = [::]' | grep LISTEN")

          machine.succeed("curl -f localhost:8000 >&2")
          machine.succeed("curl -f localhost:8000/js/script.js >&2")

          def user_count():
            # Plausible's "first launch" state is defined as "no user exists"
            # (`Plausible.Release.should_be_first_launch?` is
            # `not Repo.exists?(Plausible.Auth.User)`), so we inspect the `users`
            # table directly. Local Postgres connections use `trust` auth in this
            # VM, so the `postgres` superuser can query without a password.
            return machine.succeed(
              "sudo -u postgres psql --dbname plausible --tuples-only --no-align "
              "--command 'SELECT count(*) FROM users'"
            ).strip()

          def login_redirect_url():
            return machine.succeed(
              "curl -s -o /dev/null -w '%{redirect_url}' localhost:8000/login"
            ).strip()
        ''
        + (
          if seedAdmin then
            ''
              with subtest("the admin user is seeded"):
                assert user_count() == "1", "expected exactly one seeded admin user"
                email = machine.succeed(
                  "sudo -u postgres psql --dbname plausible --tuples-only --no-align "
                  "--command 'SELECT email FROM users'"
                ).strip()
                assert email == "${adminEmail}", f"unexpected seeded admin email: {email!r}"

              with subtest("the setup wizard is NOT reachable"):
                # `/login` must render normally (HTTP 200) and must not redirect
                # to the first-launch `/register` wizard.
                status = machine.succeed(
                  "curl -s -o /dev/null -w '%{http_code}' localhost:8000/login"
                ).strip()
                assert status == "200", f"expected /login to render (200), got: {status!r}"
                location = login_redirect_url()
                assert "/register" not in location, (
                  f"/login unexpectedly redirected to the setup wizard: {location!r}"
                )

              with subtest("seeding is idempotent across restarts"):
                machine.succeed("systemctl restart plausible.service")
                machine.wait_for_open_port(8000)
                assert user_count() == "1", "expected still exactly one user after restart"
            ''
          else
            ''
              with subtest("without an admin user, the setup wizard is reachable"):
                assert user_count() == "0", "expected no users in first-launch state"
                # With no user seeded, `should_be_first_launch?` is true and the
                # browser pipeline's `FirstLaunchPlug` 302-redirects every page to
                # `/register`.
                location = login_redirect_url()
                assert "/register" in location, (
                  f"expected /login to redirect to the setup wizard /register, but redirect was: {location!r}"
                )
            ''
        );
      }
    );
in
{
  # Basic test: Plausible without a declaratively configured admin user is in
  # the "first launch" state, so the unauthenticated setup wizard is reachable.
  # This also asserts that the way the `declarative-admin-user` test detects
  # "wizard reachable" actually fires for this Plausible version, so a future
  # Plausible change that breaks the detection would make that test fail rather
  # than silently pass.
  basic = mkPlausibleTest { seedAdmin = false; };

  # Tests that a declaratively configured admin user is seeded before the web
  # server accepts connections, so the unauthenticated "first launch" setup
  # wizard is never reachable.
  declarative-admin-user = mkPlausibleTest { seedAdmin = true; };
}
