{ lib, ... }:
{
  name = "tandoor-recipes";
  meta.maintainers = [ ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.tandoor-recipes = {
        enable = true;
        database.createLocally = true;
      };
    };

  testScript = ''
    machine.wait_for_unit("tandoor-recipes.service")

    with subtest("Web interface gets ready"):
        # Wait until server accepts connections
        machine.wait_until_succeeds("curl -fs localhost:8080")
  '';
}
