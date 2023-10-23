import ./make-test-python.nix ({ lib, ... }: {
  name = "tandoor-recipes";
  meta.maintainers = with lib.maintainers; [ ambroisie ];

  nodes.machine = { pkgs, ... }: {
    services.tandoor-recipes = {
      enable = true;
    };
  };

  testScript = ''
    machine.wait_for_unit("tandoor-recipes.service")

    with subtest("Web interface gets ready"):
        # Wait until server accepts connections
        machine.wait_until_succeeds("curl -fs localhost:8080")
  '';
})
