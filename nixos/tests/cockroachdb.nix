import ./make-test.nix ({ pkgs, ...} : {
  name = "cockroachdb";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ ];
  };

  nodes = {
    master =
      { pkgs, config, ... }:

      {
        services.cockroachdb.enable = true;
        services.cockroachdb.package = pkgs.cockroachdb;
        services.cockroachdb.insecure = true;
      };
  };

  testScript = ''
    startAll;

    $master->waitForUnit("cockroachdb");
    $master->succeed("cockroach sql --insecure -e 'SHOW ALL CLUSTER SETTINGS'");
  '';
})
