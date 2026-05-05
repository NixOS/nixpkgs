{ pkgs, ... }:

{
  name = "kine-sqlite";

  meta = {
    maintainers = pkgs.kine.meta.maintainers;
  };

  nodes.machine =
    { pkgs, ... }:
    {
      services.kine = {
        enable = true;
        database.type = "sqlite";
      };

      environment.systemPackages = [ pkgs.etcd ];
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("kine.service")
    machine.wait_for_open_port(2379)

    with subtest("should accept etcdctl requests"):
        machine.wait_until_succeeds(
            "etcdctl --endpoints=http://127.0.0.1:2379 put /health/check ok"
        )

    with subtest("should write and read key-value pairs"):
        machine.succeed(
            "etcdctl --endpoints=http://127.0.0.1:2379 put /test/key 'hello kine sqlite'"
        )
        machine.succeed(
            "etcdctl --endpoints=http://127.0.0.1:2379 get /test/key | grep 'hello kine sqlite'"
        )

    with subtest("should update existing key-value pairs"):
        machine.succeed(
            "etcdctl --endpoints=http://127.0.0.1:2379 put /test/key 'updated value'"
        )
        machine.succeed(
            "etcdctl --endpoints=http://127.0.0.1:2379 get /test/key | grep 'updated value'"
        )
        machine.fail(
            "etcdctl --endpoints=http://127.0.0.1:2379 get /test/key | grep 'hello kine sqlite'"
        )
  '';
}
