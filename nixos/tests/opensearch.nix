import ./make-test-python.nix ({ pkgs, ... }: {
  name = "opensearch";
  meta.maintainers = with pkgs.lib.maintainers; [ shyim ];

  nodes.machine = {
    virtualisation.memorySize = 2048;
    services.opensearch.enable = true;
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("opensearch.service")
    machine.wait_for_open_port(9200)

    machine.succeed(
        "curl --fail localhost:9200"
    )
  '';
})
