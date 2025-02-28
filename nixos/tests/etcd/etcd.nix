# This test runs simple etcd node
import ../make-test-python.nix (
  { pkgs, ... }:
  {
    name = "etcd";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ offline ];
    };

    nodes = {
      node =
        { ... }:
        {
          services.etcd.enable = true;
        };
    };

    testScript = ''
      with subtest("should start etcd node"):
          node.start()
          node.wait_for_unit("etcd.service")
          # Add additional wait for actual readiness
          node.wait_until_succeeds("etcdctl endpoint health")

      with subtest("should write and read some values to etcd"):
          node.succeed("etcdctl put /foo/bar 'Hello world'")
          node.succeed("etcdctl get /foo/bar | grep 'Hello world'")
    '';
  }
)
