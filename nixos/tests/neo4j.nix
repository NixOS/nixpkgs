import ./make-test.nix {
  name = "neo4j";

  nodes = {
    master =
      { ... }:

      {
        services.neo4j.enable = true;
      };
  };

  testScript = ''
    startAll;

    $master->waitForUnit("neo4j");
    $master->sleep(20); # Hopefully this is long enough!!
    $master->succeed("curl http://localhost:7474/");
  '';
}
