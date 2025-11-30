{ lib, ... }:
{
  name = "plausible";
  meta = {
    maintainers = lib.teams.cyberus.members;
  };

  nodes.machine =
    { pkgs, ... }:
    {
      virtualisation.memorySize = 4096;
      services.plausible = {
        enable = true;
        server = {
          baseUrl = "http://localhost:8000";
          secretKeybaseFile = "${pkgs.writeText "dont-try-this-at-home" "nannannannannannannannannannannannannannannannannannannan_batman!"}";
        };
      };
    };

  testScript = ''
    start_all()
    machine.wait_for_unit("plausible.service")
    machine.wait_for_open_port(8000)

    # Ensure that the software does not make not make the machine
    # listen on any public interfaces by default.
    machine.fail("ss -tlpn 'src = 0.0.0.0 or src = [::]' | grep LISTEN")

    machine.succeed("curl -f localhost:8000 >&2")

    machine.succeed("curl -f localhost:8000/js/script.js >&2")
  '';
}
