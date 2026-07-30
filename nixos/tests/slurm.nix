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
        AuthAltTypes=auth/jwt
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

  sbatchOutput = "/tmp/shared/sbatch.log";
  sbatchScript = pkgs.writeText "sbatchScript" ''
    #!${pkgs.runtimeShell}
    #SBATCH --nodes 1
    #SBATCH --ntasks 1
    #SBATCH --output ${sbatchOutput}

    echo "sbatch success"
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
          systemd.tmpfiles.rules = [
            "f /var/spool/slurmctld/jwt_hs256.key 0400 slurm slurm - thisisjustanexamplejwttoken0000"
          ];
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
          };
        };

      rest =
        { ... }:
        {
          imports = [ slurmconfig ];
          services.slurm.rest.enable = true;
        };

      node1 = computeNode;
      node2 = computeNode;
      node3 = computeNode;
    };

  testScript = ''
    start_all()

    with subtest("can_start_slurmdbd"):
        dbd.wait_for_unit("slurmdbd.service")
        dbd.wait_for_open_port(6819)

    with subtest("cluster_is_initialized"):
        control.wait_for_unit("multi-user.target")
        control.wait_for_unit("slurmctld.service")
        control.wait_for_open_port(6817)

        for node in [node1, node2, node3]:
            node.wait_for_unit("slurmd.service")
            node.wait_for_open_port(6818)

        submit.wait_for_unit("multi-user.target")

        control.wait_until_succeeds(
            "sacctmgr -nP list cluster format=cluster | grep -qx default"
        )

        # Test that the cluster works and can distribute jobs;
        control.wait_until_succeeds(
            "sinfo -Nh -o '%N %T' | grep -Fx 'node1 idle' && "
            "sinfo -Nh -o '%N %T' | grep -Fx 'node2 idle' && "
            "sinfo -Nh -o '%N %T' | grep -Fx 'node3 idle'"
        )

    with subtest("run_distributed_command"):
        # Run `hostname` on 3 nodes of the partition (so on all the 3 nodes).
        # The output must contain the 3 different names
        submit.succeed(
            "test \"$(srun -J distributed-hostname-check -N 3 hostname | sort -u | tr '\n' ' ')\" = 'node1 node2 node3 '"
        )

    with subtest("check_slurm_dbd_job_for_srun"):
        # find the srun job from above in the database
        submit.wait_until_succeeds(
            "sacct -X -P -n --name=distributed-hostname-check -o JobName,State | "
            "grep -Eq '^distributed-hostname-check\\|COMPLETED(\\+.*)?$'"
    )

    with subtest("run_PMIx_mpitest"):
        submit.succeed(
            "out=$(srun -N 3 --mpi=pmix mpitest); "
            "echo \"$out\"; "
            "echo \"$out\" | grep -Fx 'size=3'; "
            "test \"$(echo \"$out\" | grep -c 'hello world from process')\" -eq 3"
        )

    with subtest("run_sbatch"):
        submit.succeed(
            "jobid=$(sbatch --parsable --wait ${sbatchScript}); "
            "echo \"$jobid\" > /tmp/sbatch.jobid"
        )
        submit.succeed("grep -Fx 'sbatch success' ${sbatchOutput}")
        submit.wait_until_succeeds(
            "sacct -X -j $(cat /tmp/sbatch.jobid) -n -o State | grep -Eq 'COMPLETED|COMPLETED\\+'"
        )
        submit.succeed("test -z \"$(squeue -h)\"")

    with subtest("cluster_returns_to_idle"):
        control.wait_until_succeeds(
            "sinfo -Nh -o '%N %T' | grep -Fx 'node1 idle' && "
            "sinfo -Nh -o '%N %T' | grep -Fx 'node2 idle' && "
            "sinfo -Nh -o '%N %T' | grep -Fx 'node3 idle'"
        )

    with subtest("rest"):
        rest.wait_for_unit("slurmrestd.service")
        rest.wait_for_open_port(6820)

        token = control.succeed("scontrol token").split('=', 1)[1].strip()

        rest.succeed(
            "${pkgs.curl}/bin/curl -fsS "
            "-H X-SLURM-USER-TOKEN:%s "
            "http://localhost:6820/slurm/v0.0.43/diag | grep -q 'meta'" % token
        )

    with subtest("rest_rejects_invalid_token"):
        rest.fail(
            "${pkgs.curl}/bin/curl -fsS "
            "-H X-SLURM-USER-TOKEN:not-a-real-token "
            "http://localhost:6820/slurm/v0.0.43/diag"
        )
  '';
}
