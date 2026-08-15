{ lib, pkgs, ... }:
{
  name = "jellystat";
  meta.maintainers = with lib.maintainers; [ mistyttm ];

  nodes.machine = {
    services.jellystat = {
      enable = true;
      settings = {
        jwtSecretFile = pkgs.writeText "jellystat-jwt" "test-jwt-secret";
        database.passwordFile = pkgs.writeText "jellystat-db-password" "test-db-password";
      };
    };
  };

  testScript = ''
    import json

    machine.wait_for_unit("jellystat.service")
    machine.wait_for_open_port(3000)

    with subtest("state directories are created"):
        machine.succeed("test -d /var/lib/jellystat/backups")
        machine.succeed("test -d /var/lib/jellystat/env")

    with subtest("database is reachable and unconfigured"):
        config = json.loads(machine.wait_until_succeeds(
            "curl --fail -s http://localhost:3000/auth/isConfigured"
        ))
        assert config["state"] == 0, f"unexpected state: {config}"

    with subtest("protected API rejects unauthenticated requests"):
        machine.succeed(
            "test $(curl -s -o /dev/null -w '%{http_code}' http://localhost:3000/api/getconfig) = 401"
        )

    with subtest("user can be created and log in"):
        creds = json.dumps({"username": "admin", "password": "admin"})
        machine.succeed(
            f"curl --fail -s -H 'Content-Type: application/json' -d '{creds}' "
            "http://localhost:3000/auth/createuser"
        )
        token = json.loads(machine.succeed(
            f"curl --fail -s -H 'Content-Type: application/json' -d '{creds}' "
            "http://localhost:3000/auth/login"
        ))["token"]

    with subtest("authenticated API request succeeds"):
        config = json.loads(machine.succeed(
            f"curl --fail -s -H 'Authorization: Bearer {token}' "
            "http://localhost:3000/api/getconfig"
        ))
        assert config["APP_USER"] == "admin", f"unexpected config: {config}"
  '';
}
