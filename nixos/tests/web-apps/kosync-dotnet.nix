{ lib, ... }:
let
  port = 8081;
  adminPassword = "hunter2";
  # kosync-dotnet authenticates with the MD5 hex digest of the password,
  # a constraint inherited from KOReader's sync plugin.
  adminKey = "2ab96390c7dbe3439de74d0c9b0b1767";
  documentHash = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
in
{
  name = "kosync-dotnet";

  meta.maintainers = with lib.maintainers; [ notthebee ];

  nodes.machine = {
    services.kosync-dotnet = {
      enable = true;
      inherit port;
      adminPasswordFile = builtins.toFile "kosync-admin-password" adminPassword;
    };
  };

  testScript = ''
    import json

    base = "http://localhost:${toString port}"

    def request(args, expected_status=200):
        status, body = machine.succeed(
            f"curl --silent --show-error --write-out '\\n%{{http_code}}' {args}"
        ).rsplit("\n", 1)[::-1]
        assert status == str(expected_status), \
            f"expected HTTP {expected_status}, got {status}: {body}"
        return body

    machine.wait_for_unit("kosync-dotnet.service")
    machine.wait_for_open_port(${toString port})

    with subtest("server reports healthy"):
        assert json.loads(request(f"{base}/healthcheck"))["state"] == "OK"

    with subtest("admin password is taken from adminPasswordFile"):
        users = json.loads(request(
            f"-H 'x-auth-user: admin' -H 'x-auth-key: ${adminKey}' {base}/manage/users"
        ))
        assert any(u["username"] == "admin" for u in users), users

    with subtest("a user can register and authenticate"):
        request(
            f"-X POST -H 'Content-Type: application/json'"
            f" -d '{{\"username\":\"reader\",\"password\":\"secret\"}}' {base}/users/create",
            expected_status=201,
        )
        auth = json.loads(request(
            f"-H 'x-auth-user: reader' -H 'x-auth-key: secret' {base}/users/auth"
        ))
        assert auth["username"] == "reader", auth

    with subtest("reading progress round-trips"):
        request(
            f"-X PUT -H 'Content-Type: application/json'"
            f" -H 'x-auth-user: reader' -H 'x-auth-key: secret'"
            f" -d '{{\"document\":\"${documentHash}\",\"progress\":\"/body/DocFragment[3]\","
            f"\"percentage\":0.42,\"device\":\"kobo\",\"device_id\":\"1234\"}}'"
            f" {base}/syncs/progress"
        )
        progress = json.loads(request(
            f"-H 'x-auth-user: reader' -H 'x-auth-key: secret'"
            f" {base}/syncs/progress/${documentHash}"
        ))
        assert progress["progress"] == "/body/DocFragment[3]", progress
        assert progress["device"] == "kobo", progress
        assert progress["device_id"] == "1234", progress

    with subtest("progress survives a restart"):
        machine.succeed("test -f /var/lib/kosync-dotnet/data/Kosync.db")
        machine.systemctl("restart kosync-dotnet.service")
        machine.wait_for_open_port(${toString port})
        progress = json.loads(request(
            f"-H 'x-auth-user: reader' -H 'x-auth-key: secret'"
            f" {base}/syncs/progress/${documentHash}"
        ))
        assert progress["device"] == "kobo", progress
  '';
}
