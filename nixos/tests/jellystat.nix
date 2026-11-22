{ lib, pkgs, ... }:
{
  name = "jellystat";
  meta.maintainers = with lib.maintainers; [ mistyttm ];

  nodes =
    let
      common = {
        services.jellystat = {
          enable = true;
          secretFiles.JWT_SECRET = pkgs.writeText "jellystat-jwt" "test-jwt-secret";
        };
      };
    in
    {
      machine = common;
      customDataDir = lib.recursiveUpdate common {
        services.jellystat.dataDir = "/srv/jellystat";
      };
    };

  testScript = ''
    import json

    start_all()
    machine.wait_for_unit("jellystat.service")
    machine.wait_for_open_port(3000)

    with subtest("state directories are created"):
        machine.succeed("test -d /var/lib/jellystat/backups")
        machine.succeed("test -d /var/lib/jellystat/env")

    with subtest("database is reachable over the socket"):
        config = json.loads(machine.wait_until_succeeds(
            "curl --fail -s http://localhost:3000/auth/isConfigured"
        ))
        assert config["state"] == 0, f"unexpected state: {config}"

    with subtest("protected API rejects unauthenticated requests"):
        machine.succeed(
            "test $(curl -s -o /dev/null -w '%{http_code}' http://localhost:3000/api/getconfig) = 401"
        )

    with subtest("first user can be created and log in"):
        creds = json.dumps({"username": "admin", "password": "admin"})
        machine.succeed(
            f"curl --fail -s -H 'Content-Type: application/json' -d '{creds}' "
            "http://localhost:3000/auth/createuser"
        )
        # Signing the token requires JWT_SECRET from LoadCredential.
        token = json.loads(machine.succeed(
            f"curl --fail -s -H 'Content-Type: application/json' -d '{creds}' "
            "http://localhost:3000/auth/login"
        ))["token"]
        assert token, "login returned no token"

    with subtest("authenticated API request succeeds"):
        config = json.loads(machine.succeed(
            f"curl --fail -s -H 'Authorization: Bearer {token}' "
            "http://localhost:3000/api/getconfig"
        ))
        assert config["APP_USER"] == "admin", f"unexpected config: {config}"

    with subtest("custom dataDir is created"):
        customDataDir.wait_for_unit("jellystat.service")
        customDataDir.wait_for_open_port(3000)
        for d in ["/srv/jellystat/backups", "/srv/jellystat/env"]:
            customDataDir.succeed(f"test \"$(stat -c %U:%G {d})\" = jellystat:jellystat")
  '';
}
