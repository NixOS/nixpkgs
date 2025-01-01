import ./make-test-python.nix (
  { pkgs, ... }:
  let

    perlEnv = pkgs.perl.withPackages (p: [ p.NetZooKeeper ]);

  in
  {
    name = "zookeeper";
    meta = with pkgs.lib.maintainers; {
      maintainers = [
        nequissimus
        ztzg
      ];
    };

    nodes = {
      server =
        { ... }:
        {
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

      server.wait_until_succeeds(
          "${perlEnv}/bin/perl -E 'use Net::ZooKeeper qw(:acls); $z=Net::ZooKeeper->new(q(localhost:2181)); $z->create(qw(/perl foo acl), ZOO_OPEN_ACL_UNSAFE) || die $z->get_error()'"
      )
      server.wait_until_succeeds(
          "${perlEnv}/bin/perl -E 'use Net::ZooKeeper qw(:acls); $z=Net::ZooKeeper->new(q(localhost:2181)); $z->get(qw(/perl)) eq qw(foo) || die $z->get_error()'"
      )
    '';
  }
)
