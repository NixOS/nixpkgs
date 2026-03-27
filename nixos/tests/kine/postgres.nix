{ pkgs, ... }:

{
  name = "kine-postgres";

  meta = {
    maintainers = pkgs.kine.meta.maintainers;
  };

  nodes.machine =
    { pkgs, ... }:
    {
      services.kine = {
        enable = true;
        database = {
          type = "postgres";
          createLocally = true;
        };
      };

      environment.systemPackages = [ pkgs.etcd ];
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("postgresql.service")
    machine.wait_for_unit("kine.service")
    machine.wait_for_open_port(2379)

    with subtest("should accept etcdctl requests"):
        machine.wait_until_succeeds(
            "etcdctl --endpoints=http://127.0.0.1:2379 put /health/check ok"
        )

    with subtest("should write and read key-value pairs"):
        machine.succeed(
            "etcdctl --endpoints=http://127.0.0.1:2379 put /test/key 'hello kine postgres'"
        )
        machine.succeed(
            "etcdctl --endpoints=http://127.0.0.1:2379 get /test/key | grep 'hello kine postgres'"
        )

    with subtest("should update existing key-value pairs"):
        machine.succeed(
            "etcdctl --endpoints=http://127.0.0.1:2379 put /test/key 'updated value'"
        )
        machine.succeed(
            "etcdctl --endpoints=http://127.0.0.1:2379 get /test/key | grep 'updated value'"
        )
        machine.fail(
            "etcdctl --endpoints=http://127.0.0.1:2379 get /test/key | grep 'hello kine postgres'"
        )

    with subtest("should verify data persists in postgres"):
        machine.succeed(
            "etcdctl --endpoints=http://127.0.0.1:2379 put /persist/key 'persistent data'"
        )
        machine.succeed(
            "sudo -u kine psql -d kine -c 'SELECT count(*) FROM kine' | grep -E '^\s+[0-9]+'"
        )
  '';
}
