{ lib, pkgs, ... }:
{
  _class = "nixosTest";
  name = "trailbase";

  nodes = {
    machine =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          pkgs.curl
          (pkgs.writers.writePython3Bin "trailbase-api" {
            libraries = [ pkgs.python3Packages.trailbase ];
          } (builtins.readFile ./api.py))
        ];

        system.services.trailbase = {
          imports = [ pkgs.trailbase.services.default ];
          trailbase.address = "127.0.0.1:4000";
        };
      };
  };

  testScript = ''
    import re

    start_all()
    machine.wait_for_unit("trailbase.service")
    machine.wait_for_open_port(4000)
    machine.succeed("curl --fail http://127.0.0.1:4000/api/healthcheck")
    machine.succeed("curl --fail -o /dev/null http://127.0.0.1:4000/_/admin/")

    journal = machine.succeed("journalctl -u trailbase.service --no-pager")
    match = re.search(r"password:\s*'([^']+)'", journal)
    assert match, f"admin password not in journal:\n{journal}"
    password = match.group(1)

    machine.succeed(f"trailbase-api --password {password!r} setup")
    machine.succeed("systemctl restart trailbase.service")
    machine.wait_for_unit("trailbase.service")
    machine.wait_for_open_port(4000)
    machine.succeed("curl --fail http://127.0.0.1:4000/api/healthcheck")
    machine.succeed(f"trailbase-api --password {password!r} crud")
  '';

  meta = {
    maintainers = [ lib.maintainers.lucasew ];
    teams = [ lib.teams.ngi ];
  };
}
