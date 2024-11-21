import ../make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "wizarr";

    meta.maintainers = with lib.maintainers; [ pluiedev ];

    nodes.machine =
      { ... }:
      {
        services.wizarr = {
          enable = true;
        };
      };

    testScript = ''
      import json

      machine.start()
      machine.wait_for_unit("wizarr.target")
      machine.wait_until_succeeds("journalctl --since -1m --unit wizarr --grep Listening")

      assert {'status': 'online'} == json.loads(machine.succeed("curl http://localhost:5000"))

    '';
  }
)
