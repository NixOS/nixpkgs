# This test runs simple etcd node

import ./make-test-python.nix ({ pkgs, ... } : {
  name = "etcd";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ offline ];
  };

  nodes = {
    node = { ... }: {
      services.etcd.enable = true;
    };
  };

  testScript = ''
    with subtest("should start etcd node"):
        node.start()
        node.wait_for_unit("etcd.service")

    with subtest("should write and read some values to etcd"):
<<<<<<< HEAD
        node.succeed("etcdctl put /foo/bar 'Hello world'")
=======
        node.succeed("etcdctl set /foo/bar 'Hello world'")
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        node.succeed("etcdctl get /foo/bar | grep 'Hello world'")
  '';
})
