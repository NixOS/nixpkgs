{ lib, ... }:

let
  port = 8080;
  # MD5 of "hunter2" - the form the kosync protocol puts on the wire.
  passwordHash = "2ab96390c7dbe3439de74d0c9b0b1767";
  document = "8bf28b7b1c1e51b4dcdd7f0f2f4bbdcb";
in

{
  name = "crosspoint-sync";
  meta.maintainers = with lib.maintainers; [ notthebee ];

  nodes = {
    machine = {
      services.crosspoint-sync = {
        enable = true;
        settings.PORT = port;
        environmentFiles = [
          (builtins.toFile "crosspoint-sync.env" ''
            TOKEN_ENC_KEY=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef
          '')
        ];
      };
    };

    private = {
      services.crosspoint-sync = {
        enable = true;
        settings = {
          PORT = port;
          REGISTRATION_DISABLED = true;
        };
      };
    };
  };

  testScript = ''
    import json
    import shlex

    port = ${toString port}
    auth = "-H 'x-auth-user: nixos' -H 'x-auth-key: ${passwordHash}'"


    def post(node, path, body, flags=""):
        return node.succeed(
            f"curl -sS {flags} -X POST http://localhost:{port}{path}"
            " -H 'content-type: application/json'"
            f" -d {shlex.quote(json.dumps(body))}"
        )


    start_all()

    for node in (machine, private):
        node.wait_for_unit("crosspoint-sync.service")
        node.wait_for_open_port(port)

    with subtest("serves the health endpoint"):
        health = json.loads(machine.succeed(f"curl -sSf http://localhost:{port}/healthz"))
        assert health["status"] == "ok", health

    with subtest("the secret from the environment file enables connectors"):
        machine.wait_until_succeeds(
            "journalctl -u crosspoint-sync.service | grep -F '\"connectors\":\"enabled\"'"
        )

    with subtest("registers an account and authenticates with it"):
        created = json.loads(
            post(machine, "/users/create", {"username": "nixos", "password": "${passwordHash}"}, "-f")
        )
        assert created["username"] == "nixos", created

        authorized = json.loads(
            machine.succeed(f"curl -sSf http://localhost:{port}/users/auth {auth}")
        )
        assert authorized["authorized"] == "OK", authorized

    with subtest("stores and returns reading progress"):
        machine.succeed(
            f"curl -sSf -X PUT http://localhost:{port}/syncs/progress {auth}"
            " -H 'content-type: application/json'"
            f""" -d {shlex.quote(json.dumps({
                "document": "${document}",
                "progress": "/body/DocFragment[3]",
                "percentage": 0.42,
                "device": "nixos-test",
                "device_id": "nixos-test-1",
            }))}"""
        )

        progress = json.loads(
            machine.succeed(f"curl -sSf http://localhost:{port}/syncs/progress/${document} {auth}")
        )
        assert progress["percentage"] == 0.42, progress
        assert progress["progress"] == "/body/DocFragment[3]", progress
        assert progress["device"] == "nixos-test", progress

    with subtest("keeps its database across restarts"):
        machine.succeed("test -f /var/lib/crosspoint-sync/crosspoint.db")
        machine.systemctl("restart crosspoint-sync.service")
        machine.wait_for_open_port(port)

        progress = json.loads(
            machine.succeed(f"curl -sSf http://localhost:{port}/syncs/progress/${document} {auth}")
        )
        assert progress["percentage"] == 0.42, progress

    with subtest("honours REGISTRATION_DISABLED"):
        refused = json.loads(
            post(private, "/users/create", {"username": "nixos", "password": "${passwordHash}"})
        )
        assert refused["code"] == 2003, refused
  '';
}
