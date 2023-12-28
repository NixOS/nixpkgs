{ config, lib, ... }:
let
  testCfg = config.slurmTest;

  inherit (builtins) elem;
  inherit (lib)
    mkOption
    mkMerge
    mkIf
    types
    ;
in
{
  name = "slurm";

  meta.maintainers = [ lib.maintainers.markuskowa ];

  imports = [
    {
      options.slurmTest = {
        nComputeNodes = mkOption {
          type = types.int;
          description = "Number of compute nodes to create for the default slurm partition";
        };
        firstNodeId = mkOption {
          type = types.int;
          internal = true;
          default = 1;
        };
        lastNodeId = mkOption {
          type = types.int;
          internal = true;
          default = testCfg.firstNodeId + testCfg.nComputeNodes - 1;
        };
        nodeIdsRange = mkOption {
          type = types.str;
          internal = true;
          default = "${toString testCfg.firstNodeId}-${toString testCfg.lastNodeId}";
        };
      };
      config.nodes =
        let
          nodeNames = (map (n: "node${toString n}") (lib.range testCfg.firstNodeId testCfg.lastNodeId));
        in
        lib.genAttrs nodeNames (_: { slurmTestNode.roles = [ "compute" ]; });
    }
  ];

  defaults =
    { config, pkgs, ... }:
    let
      nodeCfg = config.slurmTestNode;
    in
    {
      options.slurmTestNode = {
        roles = mkOption {
          type = types.listOf (
            types.enum [
              "slurmctld"
              "dbd"
              "login"
              "compute"
            ]
          );
        };

        # NOTE: Using `callPackage` from the node's `pkgs` so that
        # `nixpkgs.overlays` are respected in case the test is re-used in
        # passthru tests or outside Nixpkgs
        mpitest.package = mkOption {
          type = types.package;
          default =
            pkgs.callPackage
              (
                { runCommand, mpi }:
                runCommand "mpitest" { nativeBuildInputs = [ mpi ]; } ''
                  mkdir -p $out/bin
                  mpicc ${./mpitest.c} -o $out/bin/mpitest
                ''
              )
              { };
        };
      };
      config = mkMerge [
        {
          services.slurm.client.enable = elem "compute" nodeCfg.roles;
          services.slurm.server.enable = elem "slurmctld" nodeCfg.roles;
          services.slurm.enableStools = elem "login" nodeCfg.roles;

          services.slurm.dbdserver.enable = elem "dbd" nodeCfg.roles;
          services.mysql.enable = elem "dbd" nodeCfg.roles;
        }
        {
          services.slurm = {

            controlMachine = "control";
            nodeName = [ "node[${testCfg.nodeIdsRange}] CPUs=1 State=UNKNOWN" ];
            partitionName = [
              "debug Nodes=node[${testCfg.nodeIdsRange}] Default=YES MaxTime=INFINITE State=UP"
            ];
            extraConfig = ''
              AccountingStorageHost=dbd
              AccountingStorageType=accounting_storage/slurmdbd
            '';

            dbdserver.storagePassFile = "${pkgs.writeText "dbdpassword" "password123"}";
          };

          services.mysql = {
            package = pkgs.mariadb;
            initialScript = pkgs.writeText "mysql-init.sql" ''
              CREATE USER 'slurm'@'localhost' IDENTIFIED BY 'password123';
              GRANT ALL PRIVILEGES ON slurm_acct_db.* TO 'slurm'@'localhost';
            '';
            ensureDatabases = [ "slurm_acct_db" ];
            ensureUsers = [
              {
                ensurePermissions = {
                  "slurm_acct_db.*" = "ALL PRIVILEGES";
                };
                name = "slurm";
              }
            ];
            settings.mysqld = {
              # recommendations from: https://slurm.schedmd.com/accounting.html#mysql-configuration
              innodb_buffer_pool_size = "1024M";
              innodb_log_file_size = "64M";
              innodb_lock_wait_timeout = 900;
            };
          };

          environment.systemPackages = [ nodeCfg.mpitest.package ];
          networking.firewall.enable = false;
          systemd.tmpfiles.rules = [
            "f /etc/munge/munge.key 0400 munge munge - mungeverryweakkeybuteasytointegratoinatest"
          ];
        }
      ];
    };

  slurmTest.nComputeNodes = 3;
  nodes = {
    control.slurmTestNode.roles = [ "slurmctld" ];
    submit.slurmTestNode.roles = [ "login" ];
    dbd.slurmTestNode.roles = [ "dbd" ];
  };

  testScript = ''
  start_all()

  # Make sure DBD is up after DB initialzation
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

  with subtest("run_PMIx_mpitest"):
      submit.succeed("srun -N 3 --mpi=pmix mpitest | grep size=3")
  '';
}
