import ./make-test.nix ({ pkgs, ...} : {
  name = "zookeeper";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ nequissimus ];
  };

  nodes = {
    server = { ... }: {
      services.zookeeper = {
        enable = true;
      };

      networking.firewall.allowedTCPPorts = [ 2181 ];
    };
  };

  testScript = ''
    startAll;

    $server->waitForUnit("zookeeper");
    $server->waitForUnit("network.target");
    $server->waitForOpenPort(2181);

    $server->waitUntilSucceeds("${pkgs.zookeeper}/bin/zkCli.sh -server localhost:2181 create /foo bar");
    $server->waitUntilSucceeds("${pkgs.zookeeper}/bin/zkCli.sh -server localhost:2181 set /foo hello");
    $server->waitUntilSucceeds("${pkgs.zookeeper}/bin/zkCli.sh -server localhost:2181 get /foo | grep hello");
  '';
})
