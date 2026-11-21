{ lib, pkgs, ... }:

{
  name = "pollaris";
  meta.maintainers = with lib.maintainers; [ haansn08 ];

  nodes.machine = {
    services.pollaris = {
      enable = true;
      domain = "localhost";
      settings = {
        APP_NAME = "NixOS polls";
        APP_REQUIRE_EMAILS = true;
        MAILER_DSN = "smtp://localhost:1025";
      };

      customCss = pkgs.writeText "custom.css" "/* custom-css-marker */";
      customJs = pkgs.writeText "custom.js" "// custom-js-marker";
      customHomeTemplate = pkgs.writeText "custom.html.twig" ''
        {% extends "base.html.twig" %}
        {% block body %}custom-home-marker{% endblock %}
      '';
    };

    # A minimal SMTP server that prints the received messages to the journal.
    systemd.services.smtp-sink = {
      wantedBy = [ "multi-user.target" ];
      before = [ "pollaris-worker.service" ];
      serviceConfig = {
        DynamicUser = true;
        # Otherwise the received messages stay in Python's buffer instead of the journal.
        Environment = "PYTHONUNBUFFERED=1";
        ExecStart = "${lib.getExe pkgs.python3Packages.aiosmtpd} --nosetuid --listen localhost:1025";
      };
    };
  };

  testScript = ''
    import datetime as dt

    def check_file(path, mode, owner):
        actual = machine.succeed(f"stat --format '%a %U:%G' {path}").strip()
        assert actual == f"{mode} {owner}", f"{path}: expected {mode} {owner}, got {actual}"

    machine.wait_for_unit("pollaris-setup.service")
    machine.wait_for_unit("phpfpm-pollaris.service")
    machine.wait_for_unit("pollaris-worker.service")
    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(80)

    with subtest("The application is served"):
        machine.succeed("curl -sSf http://localhost/ | grep 'NixOS polls'")
        # Make sure the prebuilt assets are served.
        machine.succeed("curl -sSf http://localhost/assets/js/application.js")
        # curl would otherwise resolve the ".." itself before sending the request.
        machine.fail("curl -sSf --path-as-is http://localhost/index.php/../.env.local")
        machine.fail("curl -sSf http://localhost/index.php")

    with subtest("The platform can be customised"):
        machine.succeed("curl -sSf http://localhost/custom.css | grep custom-css-marker")
        machine.succeed("curl -sSf http://localhost/custom.js | grep custom-js-marker")
        machine.succeed("curl -sSf http://localhost/ | grep custom-home-marker")
        # The custom assets are linked from the pages of the application.
        machine.succeed("curl -sSf http://localhost/ | grep -F custom.css")
        machine.succeed("curl -sSf http://localhost/ | grep -F custom.js")

    with subtest("Secrets are only readable by the service user"):
        check_file("/var/lib/pollaris", "700", "pollaris:pollaris")
        check_file("/var/lib/pollaris/.env.local", "600", "pollaris:pollaris")
        check_file("/var/lib/pollaris/app_secret", "600", "pollaris:pollaris")
        machine.fail("sudo -u nginx cat /var/lib/pollaris/.env.local")

    with subtest("An admin can be created interactively"):
        # The password prompt needs a terminal and `stty` to hide the input.
        machine.succeed(
            "printf 'secret-password\\n' | script -qec 'pollaris-console app:user:create --username=admin' /dev/null"
        )

    with subtest("Emails can be sent through the configured SMTP server"):
        machine.wait_for_unit("smtp-sink")
        machine.succeed("pollaris-console mailer:test user@example.org --subject 'Hello from the test'")
        machine.wait_until_succeeds(
            "journalctl -u smtp-sink | grep 'Subject: Hello from the test'",
            timeout=dt.timedelta(seconds=10)
        )
  '';
}
