import ./make-test.nix ({ lib, ... }:
let
    mungekey = "mungeverryweakkeybuteasytointegratoinatest";

    slurmconfig = {
      controlMachine = "control";
      nodeName = [ "node[1-3] CPUs=1 State=UNKNOWN" ];
      partitionName = [ "debug Nodes=node[1-3] Default=YES MaxTime=INFINITE State=UP" ];
      extraConfig = ''
        AccountingStorageHost=dbd
        AccountingStorageType=accounting_storage/slurmdbd
      '';
    };
in {
  name = "slurm";

  meta.maintainers = [ lib.maintainers.markuskowa ];

  nodes =
    let
    computeNode =
      { ...}:
      {
        # TODO slurmd port and slurmctld port should be configurations and
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

    dbd =
      { pkgs, ... } :
      {
        networking.firewall.enable = false;
        services.slurm.dbdserver = {
          enable = true;
        };
        services.mysql = {
          enable = true;
          package = pkgs.mysql;
          ensureDatabases = [ "slurm_acct_db" ];
          ensureUsers = [{
            ensurePermissions = { "slurm_acct_db.*" = "ALL PRIVILEGES"; };
            name = "slurm";
          }];
          extraOptions = ''
            # recommendations from: https://slurm.schedmd.com/accounting.html#mysql-configuration
            innodb_buffer_pool_size=1024M
            innodb_log_file_size=64M
            innodb_lock_wait_timeout=900
          '';
        };
      };

    node1 = computeNode;
    node2 = computeNode;
    node3 = computeNode;
  };


  testScript =
  ''
  startAll;

  # Set up authentification across the cluster
  foreach my $node (($submit,$control,$dbd,$node1,$node2,$node3))
  {
    $node->waitForUnit("default.target");

    $node->succeed("mkdir /etc/munge");
    $node->succeed("echo '${mungekey}' > /etc/munge/munge.key");
    $node->succeed("chmod 0400 /etc/munge/munge.key");
    $node->succeed("chown munge:munge /etc/munge/munge.key");
    $node->succeed("systemctl restart munged");

    $node->waitForUnit("munged");
  };

  # Restart the services since they have probably failed due to the munge init
  # failure
  subtest "can_start_slurmdbd", sub {
    $dbd->succeed("systemctl restart slurmdbd");
    $dbd->waitForUnit("slurmdbd.service");
    $dbd->waitForOpenPort(6819);
  };

  # there needs to be an entry for the current
  # cluster in the database before slurmctld is restarted
  subtest "add_account", sub {
    $control->succeed("sacctmgr -i add cluster default");
  };

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

  # Test that the cluster works and can distribute jobs;

  subtest "run_distributed_command", sub {
    # Run `hostname` on 3 nodes of the partition (so on all the 3 nodes).
    # The output must contain the 3 different names
    $submit->succeed("srun -N 3 hostname | sort | uniq | wc -l | xargs test 3 -eq");
  };

  subtest "check_slurm_dbd", sub {
    # find the srun job from above in the database
    $submit->succeed("sacct | grep hostname");
  };
  '';
})
