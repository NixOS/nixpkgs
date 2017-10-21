# This test runs simple etcd node

import ./make-test.nix ({ pkgs, ... } : {
  name = "etcd";

  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ offline ];
  };

  nodes = {
    node = { config, pkgs, nodes, ... }: {
      services.etcd.enable = true;
    };
  };

  testScript = ''
    subtest "should start etcd node", sub {
      $node->start();
      $node->waitForUnit("etcd.service");
    };

    subtest "should write and read some values to etcd", sub {
      $node->succeed("etcdctl set /foo/bar 'Hello world'");
      $node->succeed("etcdctl get /foo/bar | grep 'Hello world'");
    }
  '';
})
