# End-to-end test of a two-node YugabyteDB cluster: a row written through the
# YSQL endpoint of the first node must be readable through the YSQL endpoint of
# the second node, demonstrating that the distributed SQL layer is working
# across machines.
#
# Each node runs `yugabyted`, which supervises a yb-master (only the first node,
# since the default fault-tolerance is "none" => replication factor 1) and a
# yb-tserver. Every yb-tserver exposes a PostgreSQL-compatible YSQL server on
# port 5433 that serves the whole distributed database, so we can write on one
# node and read on the other.

{ lib, ... }:

let
  node1Ip = "192.168.1.1";
  node2Ip = "192.168.1.2";

  baseDir = "/var/lib/yugabyte";

  # YugabyteDB's hybrid clock crashes a node when the wall-clock skew between
  # cluster members exceeds max_clock_skew_usec (default 0.5s). Two QEMU guests
  # on a busy builder can briefly drift further than that, so widen the bound
  # generously to keep this functional test from flaking. The value must match
  # on yb-master and yb-tserver.
  maxClockSkewUsec = 5000000;

  startCommand =
    {
      advertiseAddress,
      join ? null,
    }:
    lib.concatStringsSep " " (
      [
        "yugabyted start"
        "--advertise_address ${advertiseAddress}"
        "--base_dir ${baseDir}"
        "--insecure"
        "--ui false"
        "--master_flags=max_clock_skew_usec=${toString maxClockSkewUsec}"
        "--tserver_flags=max_clock_skew_usec=${toString maxClockSkewUsec}"
      ]
      ++ lib.optional (join != null) "--join ${join}"
    );

  node =
    { pkgs, ... }:
    {
      # YugabyteDB (yb-master + yb-tserver + an embedded PostgreSQL for YSQL)
      # needs a fair amount of RAM and CPU; on a single emulated core the
      # processes start too slowly for yugabyted's internal startup timeouts.
      virtualisation.memorySize = 4096;
      virtualisation.cores = 4;

      # yb-tserver rejects writes unless at least ~3 GB is free on the data
      # directory (reject_writes_min_disk_space_mb defaults to
      # max_disk_throughput_mbps * 10), so the default ~1 GB test disk is far
      # too small. Give it room to accept writes.
      virtualisation.diskSize = 8192;

      # The nodes talk to each other over a handful of RPC/SQL ports; opening the
      # firewall is overkill for a sandboxed test network.
      networking.firewall.enable = false;

      environment.systemPackages = [ pkgs.yugabyte ];
    };
in
{
  name = "yugabyte";
  meta.maintainers = with lib.maintainers; [ layus ];

  nodes = {
    node1 = node;
    node2 = node;
  };

  testScript = ''
    def dump_diagnostics(node):
        _, out = node.execute(
            "echo '=== yugabyted status ==='; "
            "yugabyted status --base_dir ${baseDir} 2>&1; "
            "echo '=== listening sockets ==='; ss -tlnp; "
            "echo '=== yugabyted.log ==='; tail -n 80 ${baseDir}/logs/yugabyted.log 2>&1; "
            "echo '=== master logs ==='; "
            "tail -n 120 $(ls -t ${baseDir}/data/yb-data/master/logs/*.INFO 2>/dev/null | head -n1) 2>&1; "
            "echo '=== tserver logs ==='; "
            "tail -n 120 $(ls -t ${baseDir}/data/yb-data/tserver/logs/*.INFO 2>/dev/null | head -n1) 2>&1"
        )
        print(out)

    start_all()
    node1.wait_for_unit("multi-user.target")
    node2.wait_for_unit("multi-user.target")

    ysqlsh1 = "ysqlsh -h ${node1Ip} -p 5433 -U yugabyte -d yugabyte"
    ysqlsh2 = "ysqlsh -h ${node2Ip} -p 5433 -U yugabyte -d yugabyte"

    try:
        with subtest("first node starts and serves YSQL"):
            node1.succeed("${startCommand { advertiseAddress = node1Ip; }} >&2")
            node1.wait_until_succeeds(f"{ysqlsh1} -c 'SELECT 1'", timeout=600)

        with subtest("second node joins the cluster and serves YSQL"):
            node2.succeed("${
              startCommand {
                advertiseAddress = node2Ip;
                join = node1Ip;
              }
            } >&2")
            node2.wait_until_succeeds(f"{ysqlsh2} -c 'SELECT 1'", timeout=600)

        with subtest("write on node1 is visible on node2"):
            node1.succeed(
                f"{ysqlsh1} -c \"CREATE TABLE items (id int PRIMARY KEY, name text)\"",
                f"{ysqlsh1} -c \"INSERT INTO items VALUES (1, 'hello'), (2, 'world')\"",
            )
            rows = node2.succeed(
                f"{ysqlsh2} -tAc 'SELECT name FROM items ORDER BY id'"
            ).split()
            assert rows == ["hello", "world"], f"unexpected rows read from node2: {rows!r}"
    except Exception:
        dump_diagnostics(node1)
        dump_diagnostics(node2)
        raise
  '';
}
