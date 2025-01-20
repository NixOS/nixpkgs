import ../make-test-python.nix (
  { ... }:
  {
    name = "linkwarden-nixos";

    nodes.machine =
      { pkgs, ... }:
      let
        secretsFile = pkgs.writeText "linkwarden-secret-env" ''
          NEXTAUTH_SECRET=VERY_SENSITIVE_SECRET
        '';
      in
      {
        services.linkwarden = {
          enable = true;
          enableRegistration = true;
          secretsFile = toString secretsFile;
        };
      };

    testScript = ''
      machine.wait_for_unit("linkwarden.service")

      machine.wait_for_open_port(3000)
      machine.succeed("curl --fail -s http://localhost:3000/")

      machine.succeed("curl -L --fail -s --data '{\"name\":\"Admin\",\"username\":\"admin\",\"password\":\"adminadmin\"}' -H 'Content-Type: application/json' -X POST http://localhost:3000/api/v1/users")
    '';
  }
)
