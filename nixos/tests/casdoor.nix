{ ... }:
{
  name = "casdoor";

  nodes.machine =
    { pkgs, ... }:
    {
      services.casdoor = {
        enable = true;
        port = 8000;
        # "createDatabase" only works with MySQL and PostgreSQL. With the
        # SQLite driver it has to be ignored, because SQLite does not support
        # "CREATE DATABASE" and the server would panic on startup.
        createDatabase = true;
        settings = {
          origin = "http://localhost:8000";
          initAdminPassword = "nixos";
          # The LDAP listeners are not needed for this test. RADIUS cannot be
          # disabled and is left at its default port.
          ldapServerPort = 0;
          ldapsServerPort = 0;
        };
      };

      environment.systemPackages = [ pkgs.curl ];
    };

  # The connection string can be passed through an environment file instead
  # of the "dataSourceName" option, so that a password does not end up in the
  # Nix store. The module has to accept that and Casdoor has to pick the
  # value up from the environment.
  nodes.frontend =
    { pkgs, ... }:
    {
      services.casdoor = {
        enable = true;
        port = 8000;
        customFooter = "<span id=\"test-footer\">Test Footer</span>";
        showCloudPromotion = false;
        settings = {
          origin = "http://localhost:8000";
          initAdminPassword = "nixos";
          ldapServerPort = 0;
          ldapsServerPort = 0;
        };
      };

      environment.systemPackages = [ pkgs.curl ];
    };

  # The connection string can be passed through an environment file instead
  # of the "dataSourceName" option, so that a password does not end up in
  # the Nix store. The module has to accept that and Casdoor has to pick the
  # value up from the environment.
  nodes.envFile =
    { pkgs, ... }:
    {
      services.casdoor = {
        enable = true;
        port = 8000;
        environmentFile = pkgs.writeText "casdoor.env" ''
          dataSourceName=casdoor-envfile.db
        '';
        settings = {
          origin = "http://localhost:8000";
          ldapServerPort = 0;
          ldapsServerPort = 0;
        };
      };

      environment.systemPackages = [ pkgs.curl ];
    };

  # The settings are passed to the server as environment variables. The
  # conversion of the typed values has to be exact: Casdoor only reads a
  # boolean as true when the string is "true", and an empty value would
  # override the value from the configuration file.
  nodes.settings =
    { pkgs, ... }:
    {
      services.casdoor = {
        enable = true;
        port = 8000;
        settings = {
          origin = "http://localhost:8000";
          isDemoMode = true;
          initDataMerge = false;
          sessionCookieLifeTime = 3600;
          inactiveTimeoutMinutes = 15;
          themeShowcase = true;
          marketplaceUrl = "https://example.com/marketplace";
          batchSize = 50;
          verificationCodeTimeout = 5;
          quota.user = 10;
          ldapServerPort = 0;
          ldapsServerPort = 0;
        };
      };

      environment.systemPackages = [ pkgs.curl ];
    };

  # The port of the server is read from the configuration file of Casdoor, so
  # the module has to make the port reach the file.
  nodes.port =
    { pkgs, ... }:
    {
      services.casdoor = {
        enable = true;
        port = 8123;
        settings = {
          origin = "http://localhost:8123";
          initAdminPassword = "nixos";
          ldapServerPort = 0;
          ldapsServerPort = 0;
        };
      };

      environment.systemPackages = [ pkgs.curl ];
    };

  testScript = ''
    machine.wait_for_unit("casdoor.service")
    machine.wait_for_open_port(8000)

    # The health endpoint reports the state of the server.
    machine.succeed("curl --fail http://localhost:8000/api/health")

    # The web console is served from disk and has to be reachable, too.
    machine.succeed("curl --fail http://localhost:8000/")

    # The OIDC discovery document has to be served with the configured origin.
    machine.succeed(
        "curl --fail http://localhost:8000/.well-known/openid-configuration"
        " | grep -q '\"issuer\":\"http://localhost:8000\"'"
    )

    # The server writes its database and its logs into its state directory.
    machine.succeed("test -f /var/lib/casdoor/casdoor.db")
    machine.succeed("test -d /var/lib/casdoor/logs")

    # The flag must not have been passed to the server, and the server must
    # still be running.
    machine.succeed(
        "systemctl cat casdoor.service | grep -q -- '--createDatabase=false'"
    )
    machine.succeed("systemctl is-active casdoor.service")

    # The connection string from the environment file is used and does not
    # end up in the unit file or in the Nix store.
    envFile.wait_for_unit("casdoor.service")
    envFile.wait_for_open_port(8000)
    envFile.succeed("curl --fail http://localhost:8000/api/health")

    # Casdoor uses the file name from the environment file as its database.
    envFile.succeed("test -f /var/lib/casdoor/casdoor-envfile.db")

    # The connection string must not be readable in the unit file, and it
    # must not be part of the Nix store path of the service.
    envFile.fail(
        "systemctl show casdoor.service -p Environment | grep -q dataSourceName"
    )
    envFile.fail(
        "grep -rl dataSourceName /nix/store/ --include='*.service' 2>/dev/null"
    )

    # The custom footer is compiled into the web console, so it has to be in
    # the bundle that the server serves.
    frontend.wait_for_unit("casdoor.service")
    frontend.wait_for_open_port(8000)
    frontend.succeed("curl --fail http://localhost:8000/ | grep -q 'assets/index-'")
    frontend.succeed(
      "grep -rl 'Test Footer' /var/lib/casdoor/web/build/assets/ | grep -q ."
    )

    # The cloud promotion is compiled into the web console as well. Its default
    # is the "staticBaseUrl" entry of the configuration followed by the
    # "ShowCloudPromotion" flag, so the flag has to be compiled in as "false".
    frontend.succeed(
      "grep -rhoE 'casdoor-integrations@dist.,[A-Za-z0-9_]*=!1' /var/lib/casdoor/web/build/assets/ | grep -q ."
    )

    # The settings are passed as environment variables. A boolean has to be
    # rendered as "true" or "false", because Casdoor only reads the string
    # "true" as true.
    settings.wait_for_unit("casdoor.service")
    settings.succeed(
        "systemctl show casdoor.service -p Environment | grep -q 'isDemoMode=true'"
    )
    settings.succeed(
        "systemctl show casdoor.service -p Environment | grep -q 'initDataMerge=false'"
    )

    # The numeric settings are rendered as plain numbers.
    settings.succeed(
        "systemctl show casdoor.service -p Environment | grep -q 'sessionCookieLifeTime=3600'"
    )
    settings.succeed(
        "systemctl show casdoor.service -p Environment | grep -q 'inactiveTimeoutMinutes=15'"
    )

    # The theme showcase and the address of the marketplace are passed to the
    # server, which hands them to the web console.
    settings.succeed(
        "systemctl show casdoor.service -p Environment | grep -q 'themeShowcase=true'"
    )
    settings.succeed(
        "systemctl show casdoor.service -p Environment | grep -q 'marketplaceUrl=https://example.com/marketplace'"
    )

    # The remaining settings are passed as environment variables as well.
    settings.succeed(
        "systemctl show casdoor.service -p Environment | grep -q 'batchSize=50'"
    )
    settings.succeed(
        "systemctl show casdoor.service -p Environment | grep -q 'verificationCodeTimeout=5'"
    )

    # The quota is read from the configuration file, so it is passed in the
    # variable that the configuration file refers to. The environment of the
    # running server is read from the process, because systemd escapes the
    # quotes of the value when it shows the environment of a unit.
    settings.succeed(
        "grep -zq 'CASDOOR_QUOTA=.*\"user\":10' /proc/$(systemctl show -p MainPID --value casdoor.service)/environ"
    )
    settings.fail(
        "systemctl show casdoor.service -p Environment | grep -q ' quota='"
    )
    settings.succeed(
        "grep -q 'CASDOOR_QUOTA' /var/lib/casdoor/conf/app.conf"
    )

    # The server listens on the configured port.
    port.wait_for_unit("casdoor.service")
    port.wait_for_open_port(8123)
    port.succeed("curl --fail http://localhost:8123/api/health")
    port.fail("curl --fail http://localhost:8000/api/health")

    # A setting that was not set is left out of the environment, so that the
    # value from the configuration file stays in effect.
    settings.fail(
        "systemctl show casdoor.service -p Environment | grep -q 'originFrontend='"
    )
    settings.fail(
        "systemctl show casdoor.service -p Environment | grep -q 'initAdminPassword='"
    )
  '';
}
