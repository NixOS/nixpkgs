{
  lib,
  pkgs,
  ...
}:

{
  name = "loops-server";
  meta = {
    maintainers = [ lib.maintainers.onny ];
    teams = [ lib.teams.ngi ];
  };

  nodes = {
    server = {

      virtualisation.memorySize = 4096;

      environment.systemPackages = [ pkgs.jq ];

      services.loops-server = {
        enable = true;
        domain = "localhost";
        # Configure NGINX.
        nginx = { };
        secretFile = (
          pkgs.writeText "secrets.env" ''
            # Snakeoil secret, can be any random 32-chars secret via CSPRNG.
            APP_KEY=adKK9EcY8Hcj3PLU7rzG9rJ6KKTOtYfA
          ''
        );
        # For local testing without SSL and S3
        settings = {
          FORCE_HTTPS_URLS = false;
          FORCE_HTTPS = false;
          AWS_DRIVER = "local";
          APP_URL = "http://server";
        };
      };
    };
  };

  testScript = ''
    import json
    import shlex

    ADMIN_EMAIL = "admin@example.org"
    ADMIN_PASSWORD = "admin123"

    server.start()
    server.wait_for_unit("loops-horizon.service")
    server.wait_for_open_port(80)
    server.wait_for_file("/run/phpfpm/loops-server.sock")
    server.succeed("curl -sSfL http://server/login | grep '<title>Loops</title>'")

    server.succeed(
        "loops-manage create-admin-account "
        f"--name=admin --username=admin --email={shlex.quote(ADMIN_EMAIL)} "
        f"--password={shlex.quote(ADMIN_PASSWORD)} --silent"
    )

    # grab session + CSRF cookies
    server.succeed(
        "curl -sSf -c /tmp/cookies.txt "
        "http://server/sanctum/csrf-cookie -o /dev/null"
    )

    # Extract XSRF-TOKEN from the cookie jar
    csrf_token = server.succeed(
        "awk '$6 == \"XSRF-TOKEN\" {print $7}' /tmp/cookies.txt "
        "| sed 's/%3D/=/g'"
    ).strip()

    assert csrf_token, "failed to obtain XSRF-TOKEN"

    # log in with default credentials
    payload = json.dumps({
        "email": ADMIN_EMAIL,
        "password": ADMIN_PASSWORD,
        "remember": False,
        "add_account": False,
    })
    login_result = server.succeed(
        "curl -sSf "
        "-c /tmp/cookies.txt -b /tmp/cookies.txt "
        "-X POST http://server/login "
        "-H 'Content-Type: application/json' "
        "-H 'Accept: application/json' "
        "-H 'X-Requested-With: XMLHttpRequest' "
        f"-H {shlex.quote(f'X-XSRF-TOKEN: {csrf_token}')} "
        f"-d {shlex.quote(payload)}"
    )

    assert '"redirect"' in login_result, f"login failed: {login_result}"

    # Enable federation
    server.succeed(
        "loops-manage db:seed --class=AdminSettingsSeeder --force"
    )
    server.succeed(
        "loops-manage tinker --execute=\"App\Models\AdminSetting::where('key', 'federation.enableFederation')->update(['value' => true]);\""
    )
    server.succeed(
        "loops-manage optimize:clear"
    )

    # Test federation
    server.wait_until_succeeds("curl -sS -f http://server/nodeinfo/2.0 | jq '.usage.users.total' | grep -q '^1$'")
  '';

}
