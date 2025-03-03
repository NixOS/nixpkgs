{ lib, ... }:

{
  name = "readeck";
  meta.maintainers = with lib.maintainers; [ julienmalka ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.readeck = {
        enable = true;
        environmentFile = pkgs.writeText "env-file" ''
          READECK_SECRET_KEY="verysecretkey"
        '';
      };
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("readeck.service")
    machine.wait_for_open_port(8000)
    machine.succeed("curl --fail http://localhost:8000/login?r=%2F")
  '';
}
