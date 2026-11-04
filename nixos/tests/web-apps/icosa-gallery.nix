{ lib, ... }:
{
  name = "icosa-gallery";
  meta.teams = [ lib.teams.ngi ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.icosa-gallery = {
        enable = true;
        enableLocalDB = true;
        openFirewall = true;
        host = "0.0.0.0";
        port = 8080;
        settings = {
          # Do *NOT* do this in production, use https://wiki.nixos.org/wiki/Comparison_of_secret_managing_schemes, eg. sops-nix
          POSTGRES_PASSWORD = "icosa-gallery";
          DJANGO_SECRET_KEY = "SnakeOilKEY";
          JWT_SECRET_KEY = "SnakeOilKEY2";

          DJANGO_DISABLE_CACHE = "1";
          DEPLOYMENT_NO_SSL = "1";
          DEPLOYMENT_ENV = "local";
          DEPLOYMENT_HOST_WEB = "localhost:8080";
        };
      };

      # Do *NOT* do this in production!
      services.postgresql.initialScript = pkgs.writeText "init-sql-script" ''
        CREATE ROLE "icosa-gallery" LOGIN PASSWORD 'icosa-gallery';
      '';
    };

  testScript =
    { nodes, ... }:
    let
      port = toString nodes.machine.services.icosa-gallery.port;
    in
    ''
      endpoint = "http://localhost:${port}"

      with subtest("Start system and wait for service"):
          machine.wait_for_unit("icosa-gallery.service")
          machine.wait_for_open_port(${port})

      with subtest("Verify health check endpoint"):
          machine.succeed(f"curl -fsS {endpoint}/health")

      with subtest("Verify homepage and public pages"):
          machine.succeed(f"curl -fsS {endpoint}/ | grep -q 'Icosa Gallery'")
          machine.succeed(f"curl -fsS {endpoint}/explore/food")

      with subtest("Verify API OpenAPI docs and assets endpoint"):
          machine.succeed(f"curl -fsS {endpoint}/api/v1/docs | grep -q 'Icosa Gallery API'")
          response = machine.succeed(f"curl -fsS {endpoint}/api/v1/assets/")
          import json
          data = json.loads(response)
          assert "assets" in data

      with subtest("Test login gate and enable via constance"):
          # By default LOGIN_OPEN is False, so /login raises 404
          machine.fail(f"curl -fsS {endpoint}/login")
          # Open logins using icosa-gallery-manage CLI
          machine.succeed("icosa-gallery-manage constance set LOGIN_OPEN True")
          machine.succeed(f"curl -fsS {endpoint}/login | grep -qi 'login'")

      with subtest("Create superuser and verify admin authentication"):
          machine.succeed(
              "DJANGO_SUPERUSER_PASSWORD=admin "
              "icosa-gallery-manage createsuperuser --noinput --username admin --email admin@example.com"
          )
          # Admin login page renders
          machine.succeed(f"curl -fsS {endpoint}/admin/login/ | grep -qi 'Django administration'")

          # Authenticate to Django admin with superuser credentials
          cookie_jar = "/tmp/admin_cookies.txt"
          machine.succeed(f"""
              csrf_token=$(curl -c {cookie_jar} -s {endpoint}/admin/login/ | grep -oP 'name="csrfmiddlewaretoken" value="\\K[^"]+')
              curl -fsS -b {cookie_jar} -c {cookie_jar} \
                  -H "Referer: {endpoint}/admin/login/" \
                  -d "csrfmiddlewaretoken=$csrf_token" \
                  -d "username=admin" \
                  -d "password=admin" \
                  -d "next=/admin/" \
                  -X POST {endpoint}/admin/login/
          """)
          # Verify admin dashboard is accessible after login
          machine.succeed(f"curl -fsS -b {cookie_jar} {endpoint}/admin/ | grep -qi 'Site administration'")
    '';

  # Debug interactively with:
  # - nix-build -A nixosTests.icosa-gallery.driverInteractive
  # - ./result/bin/nixos-test-driver
  # - run_tests()
  interactive.sshBackdoor.enable = true;
  interactive.nodes.machine =
    { config, ... }:
    let
      port = config.services.icosa-gallery.port;
    in
    {
      virtualisation.forwardPorts = [
        {
          from = "host";
          host.port = port;
          guest.port = port;
        }
      ];

      # forwarded ports need to be accessible
      networking.firewall.enable = false;
    };
}
