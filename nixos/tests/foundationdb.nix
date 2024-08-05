import ./make-test-python.nix ({ pkgs, lib, package ? pkgs.foundationdb, ...} : {
  name = "foundationdb";
  meta.maintainers = with lib.maintainers; [ siriobalmelli ];

  nodes = {
    server = { _, ... }: {
      services.foundationdb = {
        inherit package;
        enable = true;
        serverProcesses = 1;
        traceFormat = "json";
      };

      # fail test if unable to start the first time
      systemd.services.foundationdb.serviceConfig.Restart = lib.mkForce "no";
    };
  };

  testScript = { nodes, ... }:
  ''
    server.wait_for_unit("foundationdb.service")
    server.succeed("fdbcli --exec status")
  '';
})
