{ ... }:
{
  name = "grimmory-nixos";

  nodes.machine =
    { pkgs, ... }:
    let
      environmentFile = pkgs.writeText "grimmory.env" ''
        DATABASE_PASSWORD=SECRET_PASSWORD
      '';
    in
    {
      services.grimmory = {
        enable = true;
        inherit environmentFile;
      };
    };

  testScript = ''
    machine.wait_for_unit('grimmory.service')

    machine.wait_for_open_port(6060)
    machine.succeed('curl -s --fail -X POST -H "Content-Type: application/json" --data \'{"username":"admin","email":"admin@example.com","name":"Admin","password":"password"}\' http://localhost:6060/api/v1/setup')
  '';
}
