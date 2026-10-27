{
  name = "neo4j";

  nodes.server = {
    virtualisation.memorySize = 4096;
    virtualisation.diskSize = 1024;

    services.neo4j.enable = true;
    # require tls certs to be available
    services.neo4j.https.enable = false;
    services.neo4j.bolt.enable = false;
  };

  testScript = ''
    start_all()

    server.wait_for_unit("neo4j.service")
    server.wait_for_open_port(7474)
    server.succeed("curl -f http://localhost:7474/")
  '';
}
