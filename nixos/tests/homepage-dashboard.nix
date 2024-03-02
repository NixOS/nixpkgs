import ./make-test-python.nix ({ lib, ... }: {
  name = "homepage-dashboard";
  meta.maintainers = with lib.maintainers; [ jnsgruk ];

  nodes.machine = { pkgs, ... }: {
    services.homepage-dashboard.enable = true;
  };

  testScript = ''
    machine.wait_for_unit("homepage-dashboard.service")
    machine.wait_for_open_port(8082)
    machine.succeed("curl --fail http://localhost:8082/")
  '';
})
