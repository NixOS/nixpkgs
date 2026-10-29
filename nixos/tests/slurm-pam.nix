{ lib, pkgs, ... }:

let

  slurmConf = "/etc/slurm.conf";
  inherit (import ./ssh-keys.nix pkgs)
    snakeOilPrivateKey
    snakeOilPublicKey
    ;
  sshConf = ''
    UserKnownHostsFile /dev/null
    StrictHostKeyChecking no
  '';
  sshConfigPubkey = pkgs.writeText "ssh_config_pubkey" (
    sshConf
    + ''

      BatchMode yes
      PreferredAuthentications publickey
      KbdInteractiveAuthentication no
      PasswordAuthentication no
      IdentityFile /root/privkey.snakeoil
    ''
  );
  sshConfigPassword = pkgs.writeText "ssh_config_password" (
    sshConf
    + ''
      BatchMode no
      PreferredAuthentications password
      PubkeyAuthentication no
      KbdInteractiveAuthentication no
      PasswordAuthentication yes
    ''
  );
  sshOpts = "-F " + sshConfigPubkey;
  sshPassOpts = "-F " + sshConfigPassword;
  adoptRemoteScript = pkgs.writeShellScript "slurm-pam-adopt-remote" ''
    echo $$ > /home/submitter/ssh.pid
    trap : TERM INT
    while true; do
      sleep 1
    done
  '';
  mkWaitJob =
    node: name:
    pkgs.writeText "${name}.sbatch" ''
      #!${pkgs.runtimeShell}
      #SBATCH --job-name=${name}
      #SBATCH --nodes=1
      #SBATCH --nodelist=${node}
      while true; do sleep 60; done
    '';

  slurmconfig =
    { config, ... }:
    {
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
          ProctrackType=proctrack/cgroup
          TaskPlugin=task/cgroup,task/affinity
          SlurmdDebug=debug
        '';
      };

      services.openssh = {
        enable = true;
        settings = {
          AllowUsers = [ "submitter" ];
          PubkeyAuthentication = true;
          # leave password auth available on the regular node for
          # regression testing plain pam_unix behavior
          KbdInteractiveAuthentication = false;
          PasswordAuthentication = true;
        };
      };

      environment.systemPackages = [
        pkgs.pamtester
        pkgs.sshpass
      ];

      networking.firewall.enable = false;
      systemd.tmpfiles.rules = [
        "f /etc/munge/munge.key 0400 munge munge - mungeverryweakkeybuteasytointegratoinatest"
      ];
      environment.etc."slurm.conf".source = "${config.services.slurm.etcSlurm}/slurm.conf";
      systemd.services.sshd.environment.SLURM_CONF = slurmConf;
      users.groups.submitter = { };
      users.users.submitter = {
        isNormalUser = true;
        createHome = true;
        initialPassword = "submitter";
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
          services.openssh.settings = {
            KbdInteractiveAuthentication = false;
            PasswordAuthentication = lib.mkForce false;
            PubkeyAuthentication = true;
          };
        };
      computePAMAdoptNode =
        { ... }:
        {
          imports = [ computeNode ];
          # NOTE: Prolog, Epilog needed for more advanced tests.
          #       This is an upstream recommended workaround for removing pam_systemd
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
          # disable `pam_systemd` on adopt node
          security.pam.services.sshd.startSession = lib.mkForce false;
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

    # Make sure cluster state is ready before testing PAM behavior.
    #
    # This shows that the controller is up, all compute nodes have registered,
    # and Slurm sees every test node as schedulable (`idle`). Without this,
    # later SSH failures would be ambiguous: they could come from PAM policy,
    # missing node registration, or startup races.
    with subtest("cluster_is_ready"):
        control.wait_for_unit("slurmctld.service")
        for node in [regular, pamslurm, pamslurmadopt]:
            node.wait_for_unit("slurmd")
        submit.wait_for_unit("multi-user.target")
        submit.wait_until_succeeds(
            "sinfo -Nh -o '%N %T' | grep -Fx 'regular idle' && "
            "sinfo -Nh -o '%N %T' | grep -Fx 'pamslurm idle' && "
            "sinfo -Nh -o '%N %T' | grep -Fx 'pamslurmadopt idle'"
        )

    # Sanity-check the Slurm cluster itself before layering PAM expectations on
    # top of it. This ensures the scheduler can place a job across all three
    # nodes, so later PAM-specific failures are not caused by a broken cluster.
    with subtest("run_distributed_command"):
        submit.succeed("srun -N 3 hostname | sort | uniq | wc -l | xargs test 3 -eq")

    # Verify that the generated PAM stacks match the intended integration:
    #
    # - `pamslurm` should include the legacy `pam_slurm.so`.
    # - `pamslurmadopt` should include `pam_slurm_adopt.so`.
    # - `pam_slurm_adopt.so` must be the last account module.
    # - `pam_systemd.so` must be absent because it conflicts with
    #   `pam_slurm_adopt`.
    #
    # This hopefully catches regressions before trying any live login.
    with subtest("pam_files_are_as_expected"):
        # `pam_systemd` conflicts with `pam_slurm_adopt`
        pamslurm.succeed("grep -q '${pkgs.slurm}/lib/security/pam_slurm.so' /etc/pam.d/sshd")
        pamslurmadopt.succeed("grep -q '${pkgs.slurm}/lib/security/pam_slurm_adopt.so' /etc/pam.d/sshd")
        pamslurmadopt.succeed(
            "awk '$1 == \"account\" { print $3 }' /etc/pam.d/sshd | tail -n1 | "
            "grep -Fx '${pkgs.slurm}/lib/security/pam_slurm_adopt.so'"
        )
        pamslurmadopt.fail("grep -q pam_systemd.so /etc/pam.d/sshd")

    # Install the test SSH private key on the submit host once so all later SSH
    # checks use the same credential and client configuration.
    with subtest("prepare_ssh_key"):
         submit.succeed(
           "install -m 0600 ${snakeOilPrivateKey} /root/privkey.snakeoil"
         )

    # Regression check: a normal node with no Slurm PAM restrictions
    # must still allow ordinary public-key SSH login for the test user.
    with subtest("regular_node_allows_pubkey_ssh"):
         submit.succeed(
            "ssh ${sshOpts} submitter@regular true",
             timeout=30
         )

    # Regression check: ordinary password SSH must also still work on
    # the regular node. This guards against accidentally breaking plain
    # `pam_unix` behavior while adding Slurm-specific PAM hooks elsewhere.
    with subtest("regular_node_allows_password_ssh"):
        submit.succeed(
            "sshpass -p submitter ssh ${sshPassOpts} submitter@regular true",
            timeout=30
        )

    # Negative companion to the previous test: wrong passwords must still be
    # rejected on the regular node, proving that the password path is actually
    # authenticating and not silently bypassed.
    with subtest("regular_node_rejects_wrong_password_ssh"):
        submit.fail(
            "sshpass -p wrong-password ssh ${sshPassOpts} submitter@regular true",
            timeout=30
        )

    # Direct PAM regression check on the regular node. This bypasses SSH and
    # exercises the local PAM service stack itself, confirming that correct
    # `pam_unix` authentication still succeeds.
    with subtest("regular_node_pam_unix_accepts_correct_password"):
        regular.succeed(
            "printf 'submitter\\n' | pamtester login submitter authenticate acct_mgmt"
        )

    # Negative companion to the previous test: wrong passwords must still be
    # rejected on the regular node, proving that the password path is actually
    # authenticating and not silently bypassed.
    with subtest("regular_node_pam_unix_rejects_wrong_password"):
        regular.fail(
            "printf 'wrong-password\\n' | pamtester login submitter authenticate"
        )

    # Core policy check for both Slurm-protected nodes: without any active job
    # owned by the user on the target node, SSH must be denied.
    #
    # This is the main negative regression test for the Slurm PAM integration.
    with subtest("deny_ssh_without_job"):
        submit.fail(
           "ssh ${sshOpts} submitter@pamslurm true",
            timeout=30
        )
        submit.fail(
           "ssh ${sshOpts} submitter@pamslurmadopt true",
            timeout=30
        )

    # Verify node-local visibility for the legacy `pam_slurm` integration.
    #
    # We start a long-running allocation specifically on `pamslurm` as the
    # `submitter` user, then confirm Slurm reports that exact node/user/job
    # combination. The important negative assertion is that this job must NOT
    # grant access to a different node (`pamslurmadopt`).
    #
    # We intentionally keep this as a visibility/isolation test rather than a
    # positive SSH-success test, since `pam_slurm` module is less
    # deterministicly to assert positive here than `pam_slurm_adopt`.
    with subtest("pam_slurm_job_visibility_is_node_local"):
        submit.succeed(
            "runuser -u submitter -- sh -lc "
            "\"srun --job-name=wait-pamslurm --nodelist=pamslurm sleep 300 "
            ">/tmp/wait-pamslurm.out 2>/tmp/wait-pamslurm.err &\""
        )
        submit.wait_until_succeeds(
            "squeue -h -u submitter -o '%N %u %T %j' | "
            "grep -Fx 'pamslurm submitter RUNNING wait-pamslurm'"
        )
        submit.fail(
            "ssh ${sshOpts} submitter@pamslurmadopt true",
            timeout=30
        )
        submit.succeed("runuser -u submitter -- scancel -n wait-pamslurm")
        submit.wait_until_succeeds(
            "! squeue -h -u submitter -o '%j' | grep -Fx wait-pamslurm"
        )

    # Positive integration tests for `pam_slurm_adopt`.
    #
    # This subtest checks the following:
    #
    # 1. a job can be created specifically on `pamslurmadopt`;
    # 2. Slurm reports that the job is running on that node;
    # 3. the node has local Slurm state for that job (`scontrol listpids`);
    # 4. SSH login is allowed while the job is active;
    # 5. a long-lived SSH session is adopted into Slurm's job tracking;
    # 6. cancelling the job tears down the adopted process;
    # 7. SSH access is denied again once the job is gone.
    #
    # Validates both policy enforcement and process adoption/cleanup.
    with subtest("pam_slurm_adopt_adopts_connection"):
        pamslurmadopt_job = submit.succeed(
            "runuser -u submitter -- sbatch --parsable ${mkWaitJob "pamslurmadopt" "wait-pamslurmadopt"}"
        ).strip()

        submit.wait_until_succeeds(
            f"test \"$(squeue -h -j {pamslurmadopt_job} -o %T)\" = RUNNING"
        )
        submit.wait_until_succeeds(
            f"squeue -h -j {pamslurmadopt_job} -o %N | grep -Fx pamslurmadopt"
        )
        pamslurmadopt.wait_until_succeeds(
            f"scontrol listpids | awk -v jid='{pamslurmadopt_job}' 'NR > 1 && $2 == jid {{ found = 1 }} END {{ exit !found }}'"
        )

        # Short SSH probe: verifies that login is allowed at all while the job
        # is active, before we move on to the stronger adoption assertions.
        submit.succeed(
            "ssh ${sshOpts} submitter@pamslurmadopt true",
            timeout=30
        )

        # Start a persistent SSH session whose remote process records its PID.
        # We later use that PID to prove the session was adopted into Slurm's
        # accounting/control path and then cleaned up when the job is cancelled.
        submit.succeed(
            "sh -lc '"
            "ssh ${sshOpts} submitter@pamslurmadopt ${adoptRemoteScript}"
            ">/tmp/adopt-ssh.log 2>&1 & "
            "echo -n \\$! > /tmp/adopt-ssh.clientpid'"
        )

        # Wait until the remote helper has started and published its PID.
        pamslurmadopt.wait_until_succeeds("test -s /home/submitter/ssh.pid")

        # Prove that the SSH-spawned remote process is visible through Slurm's
        # local process listing, i.e. that the session was adopted into the job.
        pamslurmadopt.wait_until_succeeds(
            "pid=$(cat /home/submitter/ssh.pid); "
            "scontrol listpids | awk 'NR > 1 { print $1 }' | grep -Fx \"$pid\""
        )
        remote_pid = pamslurmadopt.succeed("cat /home/submitter/ssh.pid").strip()

        # Cancel the allocation and verify the entire chain is torn down:
        # the Slurm job disappears, the adopted remote process exits, and the
        # local SSH client exits as well.
        submit.succeed(f"runuser -u submitter -- scancel {pamslurmadopt_job}")
        submit.wait_until_succeeds(
            f"test -z \"$(squeue -h -j {pamslurmadopt_job})\"",
            timeout=60,
        )
        pamslurmadopt.wait_until_succeeds(
            f"! test -e /proc/{remote_pid}",
            timeout=60,
        )
        submit.wait_until_succeeds(
            "! kill -0 $(cat /tmp/adopt-ssh.clientpid)",
            timeout=60,
        )

        # Once the job is gone, SSH must be denied
        # again on the adopt-protected node.
        submit.fail(
            "ssh ${sshOpts} submitter@pamslurmadopt true",
             timeout=30
        )
  '';
}
