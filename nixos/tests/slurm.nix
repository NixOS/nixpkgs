import ./make-test.nix ({ ... }:
let mungekey = "mungeverryweakkeybuteasytointegratoinatest";
    slurmconfig = {
      controlMachine = "control";
      nodeName = ''
        control
        NodeName=node[1-3] CPUs=1 State=UNKNOWN
      '';
      partitionName = "debug Nodes=node[1-3] Default=YES MaxTime=INFINITE State=UP";
    };
in {
  name = "slurm";

  nodes =
    let
    computeNode =
      { ...}:
      {
        # TODO slrumd port and slurmctld port should be configurations and
        # automatically allowed by the  firewall.
        networking.firewall.enable = false;
        services.slurm = {
          client.enable = true;
        } // slurmconfig;
      };
    in {

    control =
      { ...}:
      {
        networking.firewall.enable = false;
        services.slurm = {
          server.enable = true;
        } // slurmconfig;
      };

    submit =
      { ...}:
      {
        networking.firewall.enable = false;
        services.slurm = {
          enableStools = true;
        } // slurmconfig;
      };

    node1 = computeNode;
    node2 = computeNode;
    node3 = computeNode;
  };


  testScript =
  ''
  startAll;

  # Set up authentification across the cluster
  foreach my $node (($submit,$control,$node1,$node2,$node3))
  {
    $node->waitForUnit("default.target");

    $node->succeed("mkdir /etc/munge");
    $node->succeed("echo '${mungekey}' > /etc/munge/munge.key");
    $node->succeed("chmod 0400 /etc/munge/munge.key");
    $node->succeed("chown munge:munge /etc/munge/munge.key");
    $node->succeed("systemctl restart munged");
  }

  # Restart the services since they have probably failed due to the munge init
  # failure

  subtest "can_start_slurmctld", sub {
    $control->succeed("systemctl restart slurmctld");
    $control->waitForUnit("slurmctld.service");
  };

  subtest "can_start_slurmd", sub {
    foreach my $node (($node1,$node2,$node3))
    {
      $node->succeed("systemctl restart slurmd.service");
      $node->waitForUnit("slurmd");
    }
  };

  # Test that the cluster work and can distribute jobs;

  subtest "run_distributed_command", sub {
    # Run `hostname` on 3 nodes of the partition (so on all the 3 nodes).
    # The output must contain the 3 different names
    $submit->succeed("srun -N 3 hostname | sort | uniq | wc -l | xargs test 3 -eq");
  };
  '';
})
