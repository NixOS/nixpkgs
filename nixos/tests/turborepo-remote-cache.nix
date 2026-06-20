{ lib, ... }:

let
  ports = {
    turborepo-remote-cache = 8080;
  };

  token = "myrandomtoken";
  team = "nixos-team";
  # require('crypto').randomBytes(20).toString('hex');
  artifactid = "82286e93a6f84e18a8fe4770c5a88b24653e7f59";
in
{
  name = "turborepo-remote-cache";

  nodes.machine = {
    services.turborepo-remote-cache = {
      enable = true;

      environment = {
        PORT = ports.turborepo-remote-cache;
        TURBO_TEAM = team;
        TURBO_TOKEN = token;
      };
    };
  };

  testScript = ''
    import json

    machine.wait_for_unit("turborepo-remote-cache.service")
    machine.wait_for_open_port(${toString ports.turborepo-remote-cache})

    def read_json(input):
      try:
        return json.loads(input)
      except Exception as e:
        print(input)
        raise e

    out = read_json(machine.succeed("""curl 127.0.0.1:${toString ports.turborepo-remote-cache}/v8/artifacts/status? \
      -H 'Content-Type: application/json' \
      -H "Authorization: Bearer ${token}"
      """))

    if out["status"] != "enabled":
      raise Exception(f"status is not enabled in response: {out}")

    out = read_json(machine.succeed("""curl -X PUT "127.0.0.1:${toString ports.turborepo-remote-cache}/v8/artifacts/${artifactid}?teamId=${team}" \
      -H "Authorization: Bearer ${token}" \
      -H "Content-Type: application/octet-stream" \
      -d 'myartifact'"""))
    if "urls" not in out:
      raise Exception(f"'urls' not in response: {out}")

    out = machine.succeed("""curl 127.0.0.1:${toString ports.turborepo-remote-cache}/v8/artifacts/${artifactid}?teamId=${team} \
      -H 'Content-Type: application/json' \
      -H "Authorization: Bearer ${token}"
      """)
    if out != "myartifact":
      raise Exception(f"reponse in not 'myartifact': {out}")
  '';

  meta.maintainers = [ lib.maintainers.ibizaman ];
}
