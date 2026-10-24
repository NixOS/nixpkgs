{ pkgs, ... }:

let
  mkNode =
    openfga:
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.curl ];
      services.openfga = openfga // {
        enable = true;
      };
    };
in
{
  name = "openfga";
  meta.maintainers = pkgs.openfga.meta.maintainers;

  nodes = {
    memory = mkNode { };

    sqlite = mkNode {
      settings = {
        datastore.engine = "sqlite";
        authn.method = "preshared";
      };
      environmentFile = pkgs.writeText "openfga.env" "OPENFGA_AUTHN_PRESHARED_KEYS=test-key";
    };

    postgres = mkNode {
      settings.datastore.engine = "postgres";
      database.createLocally = true;
    };

    mysql =
      { pkgs, ... }:
      {
        imports = [
          (mkNode {
            settings.datastore.engine = "mysql";
            database.createLocally = true;
          })
        ];
        services.mysql.package = pkgs.mysql84;
      };
  };

  testScript = ''
    import json

    api = "http://127.0.0.1:8080"
    auth = {sqlite: "-H 'Authorization: Bearer test-key'"}

    def curl(machine, args):
        return machine.succeed(f"curl -sf {auth.get(machine, ''')} {args}")

    def wait_ready(machine):
        machine.wait_for_unit("openfga.service")
        machine.wait_for_open_port(8080)
        machine.wait_until_succeeds(f"curl -sf {auth.get(machine, ''')} {api}/healthz")

    def store_names(machine):
        return [s["name"] for s in json.loads(curl(machine, f"{api}/stores"))["stores"]]

    start_all()

    for machine in [memory, sqlite, postgres, mysql]:
        with subtest(f"{machine.name} creates a store"):
            wait_ready(machine)
            curl(machine, f"-X POST -H 'Content-Type: application/json' -d '{{\"name\": \"test\"}}' {api}/stores")
            assert store_names(machine) == ["test"]

    for machine in [sqlite, postgres, mysql]:
        with subtest(f"{machine.name} keeps the store across restarts"):
            machine.systemctl("restart openfga.service")
            wait_ready(machine)
            assert store_names(machine) == ["test"]

    with subtest("the preshared key from environmentFile is required"):
        status = sqlite.succeed(f"curl -s -o /dev/null -w '%{{http_code}}' {api}/stores")
        assert status == "401", status

    with subtest("servers listen on the configured addresses only"):
        for machine in [memory, sqlite, postgres, mysql]:
            listening = sorted(
                t for t in machine.succeed("ss -ltnH").split() if t.endswith((":8080", ":8081", ":2112"))
            )
            assert listening == ["127.0.0.1:2112", "127.0.0.1:8080", "127.0.0.1:8081"], listening
  '';
}
