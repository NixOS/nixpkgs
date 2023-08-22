import ./make-test-python.nix ({ lib, ... }: {
  name = "mlflow";
  meta.maintainers = [ lib.teams.lumiguide ];

  nodes.machine = { ... }: {
    services.mlflow.enable = true;
  };

  testScript = ''
    with subtest("Web interface gets ready"):
        machine.wait_for_unit("mlflow.service")
        # Wait until server accepts connections
        machine.wait_until_succeeds("curl -fs localhost:5000")
  '';
})

