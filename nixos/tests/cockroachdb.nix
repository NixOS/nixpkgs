# This performs a full 'end-to-end' test of a multi-node CockroachDB cluster
# using the built-in 'cockroach workload' command, to simulate a semi-realistic
# test load. Under the default set of parameters, it generally takes anywhere
# from 3-5 minutes to run and 1-2GB of RAM (though each of 3 workers gets 1GB
# allocated)
#
# CockroachDB requires synchronized system clocks within a small error window
# (~500ms by default) on each node in order to maintain a multi-node cluster.
# Cluster joins that are outside this window will fail, and nodes that skew
# outside the window after joining will promptly get kicked out.
#
# To accomodate this requirement, we set up an extra NTP daemon server node
# that hosts a stable 'single source of truth' clock for all the database
# nodes. This node always runs Chrony. The database nodes then depend on the
# systemd time synchronization target (appropriately named 'time-sync.target')
# in order to properly order themselves when joining the cluster. These nodes
# can use any NTP daemon client that they wish.
#
# Furthermore, as an optional parameter, we can use KVM/virtio infrastructure
# and load the 'ptp_kvm' driver inside the NTP guest. This driver allows the
# host machine running the tests to pass its clock through to the guest as a
# hardware clock that appears as a Precision Time Protocol (PTP) Clock device,
# generally /dev/ptp0. PTP devices can be measured and used as hardware
# reference clocks (similar to an on-board GPS clock) by NTP software. In our
# case, we use Chrony to synchronize to the reference clock, as it is the only
# NTP daemon we support that allows PTP sync. However, PTP virtio drivers are
# only available on x86_64 and require certain hardware features which aren't
# available in all scenarios for nested KVM guests (e.g. amazon ec2 can't
# load this driver for the guest). Therefore it is disabled by default.

{
  # Duration of the CockroachDB workload test.
  duration ? "1m"

  # Which workload to execute. Valid parameters are 'bank', 'kv', and 'tpcc'
, workload ? "bank"

  # The number of CockroachDB nodes to start up.
, nodeCount ? 3

  # The NTP daemon to use for the CockroachDB nodes. (The NTP server node
  # will always use Chrony.)
, ntpDaemon ? "chrony"

  # The amount of memory to give each database node. (The NTP server node
  # has a fixed amount of memory.)
, nodeMemSize ? 1024 # Benchmarks take a bit of memory by default...

  # Whether or not to use the KVM PTP 'virtualized' Clock Driver in the chronyd
  # node. This allows you to synchronize the chronyd clock to the host clock,
  # but it isn't available on all platforms. See the notes above for more
  # information.
, usePtpClockDriver ? false

  # Remaining arguments
, ...
}@args:

with builtins;

assert (nodeCount >= 1);
assert (nodeMemSize >= 1024);
assert (any (x: workload == x) [ "bank" "kv" ]); # tpcc seems unstable
assert (any (x: ntpDaemon == x) [ "chrony" "ntp" "timesyncd" ]);

import ./make-test.nix ({ pkgs, lib, ... }:
let
  ntpOpts = {

    chrony = {
      initstepslew = {
        enabled = true;
        threshold = 0.1;
      };
      bootAdjustmentOptions = {
        maxTries = 20;
        interval = 3;
        maxCorrection = 0.5;
        maxSkew = 0;
      };
    };

    ntp = {};
    timesyncd = {};
  };

  # Creates a node with the specified locality parameter.
  makeNode = locality:
    { nodes, pkgs, lib, config, ... }:

    let firstNodeIP = nodes.node1.config.networking.primaryIPAddress;
        isFirstNode = config.networking.primaryIPAddress == firstNodeIP;
    in {
      virtualisation.memorySize = nodeMemSize;

      # NTP Configuration of the daemon and the timeserver
      networking.timeServers = [ nodes.ntp_server.config.networking.primaryIPAddress ];

      services."${ntpDaemon}" = {
        enable = lib.mkForce true;
        servers = lib.mkForce config.networking.timeServers;
      } // ntpOpts."${ntpDaemon}";

      # Enable CockroachDB. Note that Cockroach will not start until
      # time-sync.target is active, which will require Chrony to perform its
      # first full synchronization.
      services.cockroachdb.enable = true;
      services.cockroachdb.insecure = true;
      services.cockroachdb.openPorts = true;
      services.cockroachdb.locality = locality;
      services.cockroachdb.listen.address = config.networking.primaryIPAddress;
      services.cockroachdb.join = lib.mkIf (!isFirstNode) firstNodeIP;

      # These make 'cockroach sql' commands briefer...
      environment.variables.COCKROACH_HOST = config.networking.primaryIPAddress;
      environment.variables.COCKROACH_INSECURE = "true";
      # ... but we need this too, because 'cockroach workload' currently
      # doesn't respect those variables. this is an easy way to make the needed
      # ODBC URI the same for any host. FIXME: remove if 'workload' ever
      # respects the prior variables.
      networking.extraHosts = "${config.networking.primaryIPAddress} crdb.local";
    };

  # A set of example localities, regions, and DCs for the node generator.
  localities  = map (c: "zone=${c}")   [ "us" "eu" "ap" "sa" ];
  regions     = map (r: "region=${r}") [ "east" "west" "south" ];
  datacenters = map (d: "dc=${d}")     [ "1" "2" "2b" ];

  # Picks out an element from one of the above sets, safely, based on
  # an index.
  getLocale = x: n: elemAt x (lib.mod (n - 1) (length x));

  # Make the node locality string for CRDB.
  makeNodeLocale = n: lib.concatStringsSep ","
    [ (getLocale localities n)
      (getLocale regions n)
      (getLocale datacenters n)
    ];

  # Create a trivial attrset so we can build the final node attrset
  nodeSet = map (n: { name = "node${toString n}"; value = n; }) (lib.range 1 nodeCount);
  nodeNames = map (n: n.name) nodeSet;

  # Turn the above nodeset into a set containing the NixOS configuration values
  crdbNodes = listToAttrs (map (v: {
    inherit (v) name;
    value = makeNode (makeNodeLocale v.value);
  }) nodeSet);

in {

  name = "cockroachdb";
  meta.maintainers = with pkgs.stdenv.lib.maintainers; [ thoughtpolice ];

  # The set of all nodes includes 1 NTP daemon node + N crdb nodes.
  nodes = {
    # Node that runs chrony as an NTP daemon for the Cockroach nodes. This lets
    # the cockroach node configurations use any arbitrary NTP daemon for testing
    # purposes without relying on PTP clock support.
    ntp_server = { nodes, pkgs, lib, config, ... }:
      { virtualisation.memorySize = 256;

        # Install the KVM PTP "Virtualized Clock" driver, if asked. This allows
        # a /dev/ptp0 device to appear as a reference clock, synchronized to
        # the host clock.
        boot.kernelModules = lib.mkIf usePtpClockDriver [ "ptp_kvm" ];

        # Disable firewall (easy hack) and disable any upstream timeservers
        networking.firewall.enable = false;
        networking.timeServers = lib.mkForce [ ];

        # Enable chrony and, optionally, use the PTP reference clock
        services.chrony.enable = true;
        services.chrony.skipInitialAdjustment = true;
        services.chrony.extraConfig = ''
          allow 192.168.0.0/16
        '' + (if usePtpClockDriver then ''
          refclock PHC /dev/ptp0 poll 2 prefer require refid KVM
          makestep 0.1 5
        '' else ''
          local stratum 8
        '');
      };

    # Cluster nodes
  } // crdbNodes;

  # Main testing script, split into several pieces for easier generation.
  testScript =
    let
      # Boot the NTP server for the DB nodes
      bootScript = ''
        $ntp_server->start; $ntp_server->waitForUnit("time-sync.target");
      '';

      # Script that starts all nodes, in order. NOTE: All the nodes must start
      # in order and you must NOT use startAll, because there's otherwise no
      # way to guarantee that node1 will start before the others try to join
      # it.
      startScript = lib.concatStringsSep "\n"
        (map (n: "$"+n+"->start; $"+n+"->waitForUnit(\"cockroachdb\");") nodeNames);

      # Script to initialize cluster from node1
      initScript = ''
        $node1->mustSucceed("cockroach sql -e 'SHOW ALL CLUSTER SETTINGS' 2>&1");
        $node1->mustSucceed("cockroach workload init ${workload} 'postgresql://root\@crdb.local:26257?sslmode=disable'");
      '';

      # Execute the cluster workload
      runScript = ''
        $node1->mustSucceed("cockroach workload run ${workload} --duration=${duration} 'postgresql://root\@crdb.local:26257?sslmode=disable'");
      '';

    in lib.concatStringsSep "\n" [
      bootScript
      startScript
      initScript
      runScript
    ];
}) args
