import ./make-test-python.nix (
  { pkgs, ... }:
  rec {
    name = "tracee-integration";
    meta.maintainers = pkgs.tracee.meta.maintainers;

    passthru.hello-world-builder =
      pkgs:
      pkgs.dockerTools.buildImage {
        name = "hello-world";
        tag = "latest";
        config.Cmd = [ "${pkgs.hello}/bin/hello" ];
      };

    nodes = {
      machine =
        { config, pkgs, ... }:
        {
          # EventFilters/trace_only_events_from_new_containers and
          # Test_EventFilters/trace_only_events_from_"dockerd"_binary_and_contain_it's_pid
          # require docker/dockerd
          virtualisation.docker.enable = true;

          environment.systemPackages = with pkgs; [
            # required by Test_EventFilters/trace_events_from_ls_and_which_binary_in_separate_scopes
            which
            # the go integration tests as a binary
            tracee.passthru.tests.integration-test-cli
          ];
        };
    };

    testScript =
      let
        skippedTests = [
          # these comm tests for some reason do not resolve.
          # something about the test is different as it works fine if I replicate
          # the policies and run tracee myself but doesn't work in the integration
          # test either with the automatic run or running the commands by hand
          # while it's searching.
          "Test_EventFilters/comm:_event:_args:_trace_event_set_in_a_specific_policy_with_args_from_ls_command"
          "Test_EventFilters/comm:_event:_trace_events_set_in_two_specific_policies_from_ls_and_uname_commands"

          # worked at some point, seems to be flakey
          "Test_EventFilters/pid:_event:_args:_trace_event_sched_switch_with_args_from_pid_0"
        ];
      in
      ''
        with subtest("prepare for integration tests"):
          machine.wait_for_unit("docker.service")
          machine.succeed('which bash')

          # EventFilters/trace_only_events_from_new_containers also requires a container called "hello-world"
          machine.succeed('docker load < ${passthru.hello-world-builder pkgs}')

          # exec= needs fully resolved paths
          machine.succeed(
            'mkdir /tmp/testdir',
            'cp $(which who) /tmp/testdir/who',
            'cp $(which uname) /tmp/testdir/uname',
          )

        with subtest("run integration tests"):
          # Test_EventFilters/trace_event_set_in_a_specific_scope expects to be in a dir that includes "integration"
          # tests must be ran with 1 process
          print(machine.succeed(
            'mkdir /tmp/integration',
            'cd /tmp/integration && export PATH="/tmp/testdir:$PATH" && integration.test -test.v -test.parallel 1 -test.skip="^${builtins.concatStringsSep "$|^" skippedTests}$"'
          ))
      '';
  }
)
