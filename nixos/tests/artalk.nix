{ lib, pkgs, ... }:
{

  name = "artalk";

  meta = {
    maintainers = with lib.maintainers; [ moraxyc ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.curl
        pkgs.artalk
        pkgs.sudo
      ];
      services.artalk = {
        enable = true;
        settings = {
          cache.enabled = true;
          admin_users = [
            {
              name = "admin";
              email = "admin@example.org";
              # md5 for 'password'
              password = "(md5)5F4DCC3B5AA765D61D8327DEB882CF99";
            }
          ];
        };
      };
    };

  testScript = ''
    import json
    machine.wait_for_unit("artalk.service")

    machine.wait_for_open_port(23366)

    assert '${pkgs.artalk.version}' in machine.succeed("curl --fail --max-time 10 http://127.0.0.1:23366/api/v2/version")

    # Get token
    result = json.loads(machine.succeed("""
      curl --fail -X POST --json '{
              "email": "admin@example.org",
              "password": "password"
              }' 'http://127.0.0.1:23366/api/v2/auth/email/login'
      """))
    token = result['token']

    # Test admin
    machine.succeed(f"""
      curl --fail -X POST --header 'Authorization: {token}' 'http://127.0.0.1:23366/api/v2/cache/flush'
      """)
  '';
}
