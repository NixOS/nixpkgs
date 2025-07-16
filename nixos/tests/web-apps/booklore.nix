{ ... }:
{
  name = "booklore-nixos";

  nodes.machine =
    { pkgs, ... }:
    let
      passwordFile = pkgs.writeText "booklore_db_passwd" ''
        SECRET_PASSWORD
      '';
    in
    {
      services.booklore = {
        enable = true;
        secretFiles = {
          DATABASE_PASSWORD = toString passwordFile;
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("booklore.service")

    machine.wait_for_open_port(8080)
    machine.succeed("curl -s --fail http://localhost:8080")
  '';
}
