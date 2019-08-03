import ./make-test.nix ({ lib, pkgs, ... }: {
  name = "syncthing-relay";
  meta.maintainers = with pkgs.stdenv.lib.maintainers; [ delroth ];

  machine = {
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
    $machine->waitForUnit("syncthing-relay.service");
    $machine->waitForOpenPort(12345);
    $machine->waitForOpenPort(12346);
    $machine->succeed("curl http://localhost:12346/status | jq -r '.options.\"provided-by\"'") =~ /nixos-test/ or die;
  '';
})
