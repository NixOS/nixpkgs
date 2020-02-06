import ./make-test-python.nix ({ lib, ... }:
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
          storagePass = "password123";
        };
        services.mysql = {
          enable = true;
          package = pkgs.mariadb;
          initialScript = pkgs.writeText "mysql-init.sql" ''
            CREATE USER 'slurm'@'localhost' IDENTIFIED BY 'password123';
            GRANT ALL PRIVILEGES ON slurm_acct_db.* TO 'slurm'@'localhost';
          '';
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
  start_all()

  # Set up authentification across the cluster
  for node in [submit, control, dbd, node1, node2, node3]:

      node.wait_for_unit("default.target")

      node.succeed("mkdir /etc/munge")
      node.succeed(
          "echo '${mungekey}' > /etc/munge/munge.key"
      )
      node.succeed("chmod 0400 /etc/munge/munge.key")
      node.succeed("chown munge:munge /etc/munge/munge.key")
      node.succeed("systemctl restart munged")

      node.wait_for_unit("munged")


  # Restart the services since they have probably failed due to the munge init
  # failure
  with subtest("can_start_slurmdbd"):
      dbd.succeed("systemctl restart slurmdbd")
      dbd.wait_for_unit("slurmdbd.service")
      dbd.wait_for_open_port(6819)

  # there needs to be an entry for the current
  # cluster in the database before slurmctld is restarted
  with subtest("add_account"):
      control.succeed("sacctmgr -i add cluster default")
      # check for cluster entry
      control.succeed("sacctmgr list cluster | awk '{ print $1 }' | grep default")

  with subtest("can_start_slurmctld"):
      control.succeed("systemctl restart slurmctld")
      control.wait_for_unit("slurmctld.service")

  with subtest("can_start_slurmd"):
      for node in [node1, node2, node3]:
          node.succeed("systemctl restart slurmd.service")
          node.wait_for_unit("slurmd")

  # Test that the cluster works and can distribute jobs;

  with subtest("run_distributed_command"):
      # Run `hostname` on 3 nodes of the partition (so on all the 3 nodes).
      # The output must contain the 3 different names
      submit.succeed("srun -N 3 hostname | sort | uniq | wc -l | xargs test 3 -eq")

      with subtest("check_slurm_dbd"):
          # find the srun job from above in the database
          control.succeed("sleep 5")
          control.succeed("sacct | grep hostname")
  '';
})
