import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "syncthing-relay";
  meta.maintainers = with pkgs.lib.maintainers; [ delroth ];

  nodes.machine = {
    environment.systemPackages = [ pkgs.jq ];
    services.syncthing.relay = {
      enable = true;
      providedBy = "nixos-test";
      pools = [];  # Don't connect to any pool while testing.
      port = 12345;
      statusPort = 12346;
    };
  };

  testScript = ''
    machine.wait_for_unit("syncthing-relay.service")
    machine.wait_for_open_port(12345)
    machine.wait_for_open_port(12346)

    out = machine.succeed(
        "curl -sSf http://localhost:12346/status | jq -r '.options.\"provided-by\"'"
    )
    assert "nixos-test" in out
  '';
})
