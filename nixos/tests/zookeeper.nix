import ./make-test-python.nix ({ pkgs, ...} : {
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
    start_all()

    server.wait_for_unit("zookeeper")
    server.wait_for_unit("network.target")
    server.wait_for_open_port(2181)

    server.wait_until_succeeds(
        "${pkgs.zookeeper}/bin/zkCli.sh -server localhost:2181 create /foo bar"
    )
    server.wait_until_succeeds(
        "${pkgs.zookeeper}/bin/zkCli.sh -server localhost:2181 set /foo hello"
    )
    server.wait_until_succeeds(
        "${pkgs.zookeeper}/bin/zkCli.sh -server localhost:2181 get /foo | grep hello"
    )
  '';
})
