import ./make-test-python.nix (
  { lib, pkgs, ... }:
  let
    slurmconfig = {
      services.slurm = {
        controlMachine = "control";
        nodeName = [ "node[1-3] CPUs=1 State=UNKNOWN" ];
        partitionName = [ "debug Nodes=node[1-3] Default=YES MaxTime=INFINITE State=UP" ];
        extraConfig = ''
          AccountingStorageHost=dbd
          AccountingStorageType=accounting_storage/slurmdbd
        '';
      };
      environment.systemPackages = [ mpitest ];
      networking.firewall.enable = false;
      systemd.tmpfiles.rules = [
        "f /etc/munge/munge.key 0400 munge munge - mungeverryweakkeybuteasytointegratoinatest"
      ];
    };

    mpitest =
      let
        mpitestC = pkgs.writeText "mpitest.c" ''
          #include <stdio.h>
          #include <stdlib.h>
          #include <mpi.h>

          int
          main (int argc, char *argv[])
          {
            int rank, size, length;
            char name[512];

            MPI_Init (&argc, &argv);
            MPI_Comm_rank (MPI_COMM_WORLD, &rank);
            MPI_Comm_size (MPI_COMM_WORLD, &size);
            MPI_Get_processor_name (name, &length);

            if ( rank == 0 ) printf("size=%d\n", size);

            printf ("%s: hello world from process %d of %d\n", name, rank, size);

            MPI_Finalize ();

            return EXIT_SUCCESS;
          }
        '';
      in
      pkgs.runCommand "mpitest" { } ''
        mkdir -p $out/bin
        ${lib.getDev pkgs.mpi}/bin/mpicc ${mpitestC} -o $out/bin/mpitest
      '';
  in
  {
    name = "slurm";

    meta.maintainers = [ lib.maintainers.markuskowa ];

    nodes =
      let
        computeNode =
          { ... }:
          {
            imports = [ slurmconfig ];
            # TODO slurmd port and slurmctld port should be configurations and
            # automatically allowed by the  firewall.
            services.slurm = {
              client.enable = true;
            };
          };
      in
      {

        control =
          { ... }:
          {
            imports = [ slurmconfig ];
            services.slurm = {
              server.enable = true;
            };
          };

        submit =
          { ... }:
          {
            imports = [ slurmconfig ];
            services.slurm = {
              enableStools = true;
            };
          };

        dbd =
          { pkgs, ... }:
          let
            passFile = pkgs.writeText "dbdpassword" "password123";
          in
          {
            networking.firewall.enable = false;
            systemd.tmpfiles.rules = [
              "f /etc/munge/munge.key 0400 munge munge - mungeverryweakkeybuteasytointegratoinatest"
            ];
            services.slurm.dbdserver = {
              enable = true;
              storagePassFile = "${passFile}";
            };
            services.mysql = {
              enable = true;
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
          };

        node1 = computeNode;
        node2 = computeNode;
        node3 = computeNode;
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
)
