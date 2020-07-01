# This performs a full 'end-to-end' test of a multi-node CockroachDB cluster
# using the built-in 'cockroach workload' command, to simulate a semi-realistic
# test load. It generally takes anywhere from 3-5 minutes to run and 1-2GB of
# RAM (though each of 3 workers gets 2GB allocated)
#
# CockroachDB requires synchronized system clocks within a small error window
# (~500ms by default) on each node in order to maintain a multi-node cluster.
# Cluster joins that are outside this window will fail, and nodes that skew
# outside the window after joining will promptly get kicked out.
#
# To accomodate this, we use QEMU/virtio infrastructure and load the 'ptp_kvm'
# driver inside a guest. This driver allows the host machine to pass its clock
# through to the guest as a hardware clock that appears as a Precision Time
# Protocol (PTP) Clock device, generally /dev/ptp0. PTP devices can be measured
# and used as hardware reference clocks (similar to an on-board GPS clock) by
# NTP software. In our case, we use Chrony to synchronize to the reference
# clock.
#
# This test is currently NOT enabled as a continuously-checked NixOS test.
# Ideally, this test would be run by Hydra and Borg on all relevant changes,
# except:
#
#   - Not every build machine is compatible with the ptp_kvm driver.
#     Virtualized EC2 instances, for example, do not support loading the ptp_kvm
#     driver into guests. However, bare metal builders (e.g. Packet) do seem to
#     work just fine. In practice, this means x86_64-linux builds would fail
#     randomly, depending on which build machine got the job. (This is probably
#     worth some investigation; I imagine it's based on ptp_kvm's usage of paravirt
#     support which may not be available in 'nested' environments.)
#
#   - ptp_kvm is not supported on aarch64, otherwise it seems likely Cockroach
#     could be tested there, as well. This seems to be due to the usage of
#     the TSC in ptp_kvm, which isn't supported (easily) on AArch64. (And:
#     testing stuff, not just making sure it builds, is important to ensure
#     aarch64 support remains viable.)
#
# For future developers who are reading this message, are daring and would want
# to fix this, some options are:
#
#   - Just test a single node cluster instead (boring and less thorough).
#   - Move all CI to bare metal packet builders, and we can at least do x86_64-linux.
#   - Get virtualized clocking working in aarch64, somehow.
#   - Add a 4th node that acts as an NTP service and uses no PTP clocks for
#     references, at the client level. This bloats the node and memory
#     requirements, but would probably allow both aarch64/x86_64 to work.
#

let

  # Creates a node. If 'joinNode' parameter, a string containing an IP address,
  # is non-null, then the CockroachDB server will attempt to join/connect to
  # the cluster node specified at that address.
  makeNode = locality: myAddr: joinNode:
    { nodes, pkgs, lib, config, ... }:

    {
      # Bank/TPC-C benchmarks take some memory to complete
      virtualisation.memorySize = 2048;

      # Install the KVM PTP "Virtualized Clock" driver. This allows a /dev/ptp0
      # device to appear as a reference clock, synchronized to the host clock.
      # Because CockroachDB *requires* a time-synchronization mechanism for
      # the system time in a cluster scenario, this is necessary to work.
      boot.kernelModules = [ "ptp_kvm" ];

      # Enable and configure Chrony, using the given virtualized clock passed
      # through by KVM.
      services.chrony.enable = true;
      services.chrony.servers = lib.mkForce [ ];
      services.chrony.extraConfig = ''
        refclock PHC /dev/ptp0 poll 2 prefer require refid KVM
        makestep 0.1 3
      '';

      # Enable CockroachDB. In order to ensure that Chrony has performed its
      # first synchronization at boot-time (which may take ~10 seconds) before
      # starting CockroachDB, we block the ExecStartPre directive using the
      # 'waitsync' command. This ensures Cockroach doesn't have its system time
      # leap forward out of nowhere during startup/execution.
      #
      # Note that the default threshold for NTP-based skew in CockroachDB is
      # ~500ms by default, so making sure it's started *after* accurate time
      # synchronization is extremely important.
      services.cockroachdb.enable = true;
      services.cockroachdb.insecure = true;
      services.cockroachdb.openPorts = true;
      services.cockroachdb.locality = locality;
      services.cockroachdb.listen.address = myAddr;
      services.cockroachdb.join = lib.mkIf (joinNode != null) joinNode;

      systemd.services.chronyd.unitConfig.ConditionPathExists = "/dev/ptp0";

      # Hold startup until Chrony has performed its first measurement (which
      # will probably result in a full timeskip, thanks to makestep)
      systemd.services.cockroachdb.preStart = ''
        ${pkgs.chrony}/bin/chronyc waitsync
      '';
    };

in import ./make-test-python.nix ({ pkgs, ...} : {
  name = "cockroachdb";
  meta.maintainers = with pkgs.stdenv.lib.maintainers;
    [ thoughtpolice ];

  nodes = {
    node1 = makeNode "country=us,region=east,dc=1"  "192.168.1.1" null;
    node2 = makeNode "country=us,region=west,dc=2b" "192.168.1.2" "192.168.1.1";
    node3 = makeNode "country=eu,region=west,dc=2"  "192.168.1.3" "192.168.1.1";
  };

  # NOTE: All the nodes must start in order and you must NOT use startAll, because
  # there's otherwise no way to guarantee that node1 will start before the others try
  # to join it.
  testScript = ''
    for node in node1, node2, node3:
        node.start()
        node.wait_for_unit("cockroachdb")
    node1.succeed(
        "cockroach sql --host=192.168.1.1 --insecure -e 'SHOW ALL CLUSTER SETTINGS' 2>&1",
        "cockroach workload init bank 'postgresql://root@192.168.1.1:26257?sslmode=disable'",
        "cockroach workload run bank --duration=1m 'postgresql://root@192.168.1.1:26257?sslmode=disable'",
    )
  '';
})
