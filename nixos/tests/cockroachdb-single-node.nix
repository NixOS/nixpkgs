# Unlike the cockroachdb test, which spins up a proper cluster (and strictly
# requires kvm), this test runs cockroachdb in single-user mode.
#
# Testing that cockroachdb can run in single-user mode ensures that folks can
# test applications that depend on it, even though it's not a substitute for a
# full clustered test.

import ./make-test-python.nix ({ pkgs, ...} : {
  name = "cockroachdb";
  nodes = {
    machine = {
      # cockroach is under a license that restricts ability to host the database as a service.
      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [ "cockroach" ];

      # Bank/TPC-C benchmarks take some memory to complete
      virtualisation.memorySize = 2048;

      services.cockroachdb.enable = true;
      services.cockroachdb.insecure = true;
      services.cockroachdb.openPorts = true;
      services.cockroachdb.singleNode = true;
      services.cockroachdb.locality = "system=sol,planet=earth";
    };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("cockroachdb")
    machine.succeed(
        "cockroach sql --host=127.0.0.1 --insecure -e 'SHOW ALL CLUSTER SETTINGS' 2>&1",
        "cockroach workload init bank 'postgresql://root@127.0.0.1:26257?sslmode=disable'",
        "cockroach workload run bank --duration=1m 'postgresql://root@127.0.0.1:26257?sslmode=disable'",
    )
  '';
})
