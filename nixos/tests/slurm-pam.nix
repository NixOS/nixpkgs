{ lib, pkgs, ... }:

let
  inherit (import ./ssh-keys.nix pkgs)
    snakeOilPrivateKey
    snakeOilPublicKey
    ;
  slurmconfig = {
    services.slurm = {
      controlMachine = "control";
      nodeName = map (n: n + " CPUs=1 State=UNKNOWN") [
        "regular"
        "pamslurm"
        "pamslurmadopt"
      ];
      partitionName = [ "debug Nodes=ALL Default=YES MaxTime=INFINITE State=UP" ];
      extraConfig = ''
        PrologFlags=contain
        TaskPlugin=task/cgroup,task/affinity
        SlurmdDebug=debug
      '';
    };
    services.openssh = {
      enable = true;
      settings.AllowUsers = [ "submitter" ];
    };

    networking.firewall.enable = false;
    systemd.tmpfiles.rules = [
      "f /etc/munge/munge.key 0400 munge munge - mungeverryweakkeybuteasytointegratoinatest"
    ];
    users.groups.submitter = { };
    users.users.submitter = {
      isNormalUser = true;
      createHome = true;
      group = "submitter";
      openssh.authorizedKeys.keys = [ snakeOilPublicKey ];
    };
  };

in
{
  name = "slurm-pam";

  meta.maintainers = [ lib.maintainers.edwtjo ];

  nodes =
    let
      computeNode =
        { ... }:
        {
          imports = [ slurmconfig ];
          services.slurm = {
            client.enable = true;
          };
        };
      computePAMNode =
        { ... }:
        {
          imports = [ computeNode ];
          security.pam.services.sshd.slurm.enable = true;
        };
      computePAMAdoptNode =
        { ... }:
        {
          imports = [ computeNode ];
          # NOTE: Prolog, Epilog needed for more advanced tests
          services.slurm.extraConfig = ''
            LaunchParameters=ulimit_pam_adopt
            SrunProlog=${pkgs.writers.writeBash "slurm-prolog" ''
              loginctl enable-linger $SLURM_JOB_USER
              exit 0
            ''}
            TaskProlog=${pkgs.writers.writeBash "slurm-taskprolog" ''
              echo "export XDG_RUNTIME_DIR=/run/user/$SLURM_JOB_UID"
              echo "export XDG_SESSION_ID=$(</proc/self/sessionid)"
              echo "export XDG_SESSION_TYPE=tty"
              echo "export XDG_SESSION_CLASS=user"
            ''}
            SrunEpilog=${pkgs.writers.writeBash "slurm-epilog" ''
              #Only disable linger if this is the last job running for this user.
              O_P=0
              for pid in $(scontrol listpids | awk -v jid=$SLURM_JOB_ID 'NR!=1 { if ($2 != jid && $1 != "-1"){print $1} }'); do
                      ps --noheader -o euser p $pid | grep -q $SLURM_JOB_USER && O_P=1
              done
              if [ $O_P -eq 0 ]; then
                      loginctl disable-linger $SLURM_JOB_USER
              fi
              exit 0
            ''}
          '';
          security.pam.services.sshd.slurm.adopt.enable = true;
          security.pam.services.sshd.slurm.adopt.settings.action_adopt_failure = "allow";
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

      regular = computeNode;
      pamslurm = computePAMNode;
      pamslurmadopt = computePAMAdoptNode;
    };

  testScript = ''
    start_all()

    with subtest("can_start_slurmctld"):
        control.succeed("systemctl restart slurmctld")
        control.wait_for_unit("slurmctld.service")

    with subtest("can_start_slurmd"):
        for node in [regular, pamslurm, pamslurmadopt]:
            node.succeed("systemctl restart slurmd.service")
            node.wait_for_unit("slurmd")

    # Test that the cluster works and can distribute jobs;
    with subtest("run_distributed_command"):
        submit.succeed("srun -N 3 hostname | sort | uniq | wc -l | xargs test 3 -eq")

    # Test that we can SSH into nodes without pam or running jobs
    with subtest("run_ssh_regular"):
        submit.succeed(
            "cat ${snakeOilPrivateKey} > privkey.snakeoil"
        )
        submit.succeed("chmod 600 privkey.snakeoil")
        submit.succeed(
            "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i privkey.snakeoil submitter@regular true",
            timeout=30
        )

    with subtest("run_ssh_pam_slurm"):
      # Regular compute nodes with user access should accept SSH
      submit.succeed(
            "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i privkey.snakeoil submitter@regular true",
            timeout=30
        )
      # PAM SLURM nodes with user access should only accept with an active job
      submit.fail(
            "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i privkey.snakeoil submitter@pamslurm true",
            timeout=30
      )
      # Spawn a wait job
      submit.succeed("sbatch ${pkgs.writers.writeBash "mkWaitJob" ''
        #SBATCH --nodes 3
        while true; do sleep 60;done
      ''} >&2 &")

      # PAM SLURM should let us SSH into nodes with a job
      submit.succeed(
            "ssh -vvv -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i privkey.snakeoil submitter@pamslurm true",
            timeout=30
      )

      # PAM SLURM ADOPT should be able to adopt the connection as a job step
      submit.succeed(
            "ssh -vvv -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i privkey.snakeoil submitter@pamslurmadopt true",
            timeout=30
      )
  '';
}
