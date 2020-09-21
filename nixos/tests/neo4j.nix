import ./make-test-python.nix {
  name = "neo4j";

  nodes = {
    master =
      { ... }:

      {
        services.neo4j.enable = true;
        # require tls certs to be available
        services.neo4j.https.enable = false;
        services.neo4j.bolt.enable = false;
      };
  };

  testScript = ''
    start_all()

    master.wait_for_unit("neo4j")
    master.wait_for_open_port(7474)
    master.succeed("curl http://localhost:7474/")
  '';
}
