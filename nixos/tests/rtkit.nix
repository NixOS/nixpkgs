{ lib, ... }:

{
  name = "rtkit";

  meta.maintainers = with lib.maintainers; [ rvl ];

  nodes.machine =
    { config, pkgs, ... }:
    {
      assertions = [
        {
          assertion = config.security.polkit.enable;
          message = "rtkit needs polkit to handle authorization";
        }
      ];

      imports = [ ./common/user-account.nix ];
      services.getty.autologinUser = "alice";

      security.rtkit.enable = true;

      # Modified configuration with higher maximum realtime priority.
      specialisation.withHigherPrio.configuration = {
        security.rtkit.args = [
          "--max-realtime-priority=89"
          "--our-realtime-priority=90"
        ];
      };

      # Target process for testing - belongs to a logind session.
      systemd.user.services.sleeper = {
        description = "Guinea pig service";
        serviceConfig = {
          ExecStart = "@${pkgs.coreutils}/bin/sleep sleep inf";
          # rtkit-daemon won't grant real-time to threads unless they have a rttime limit.
          LimitRTTIME = 200000;
        };
        wantedBy = [ "default.target" ];
      };

      # Target process for testing - doesn't belong to a session.
      systemd.services."sleeper@" = {
        description = "Guinea pig system service for %I";
        serviceConfig = {
          ExecStart = "@${pkgs.coreutils}/bin/sleep sleep inf";
          LimitRTTIME = 200000;
          User = "%I";
        };
      };
      systemd.targets.multi-user.wants = [ "sleeper@alice.service" ];

      # Install chrt to check outcomes of rtkit calls
      environment.systemPackages = [ pkgs.util-linux ];

      # Provide a little logging of polkit checks - otherwise it's
      # impossible to know what's going on.
      security.polkit.debug = true;
      security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          const ns = "org.freedesktop.RealtimeKit1.";
          const acquireHighPrio = ns + "acquire-high-priority";
          const acquireRT = ns + "acquire-real-time";
          if (action.id == acquireHighPrio || action.id == acquireRT) {
            polkit.log("rtkit: Checking " + action.id + " for " + subject.user + "\n  " + subject);
          }
        });
      '';
    };

  interactive.nodes.machine =
    { pkgs, ... }:
    {
      security.rtkit.args = [ "--debug" ];
      systemd.services.strace-rtkit =
        let
          target = "rtkit-daemon.service";
        in
        {
          bindsTo = [ target ];
          after = [ target ];
          scriptArgs = target;
          script = ''
            pid=$(systemctl show -P MainPID $1)
            strace -tt -s 100 -e trace=all -p $pid
          '';
          path = [ pkgs.strace ];
        };
    };

  testScript =
    { nodes, ... }:
    let
      specialisations = "${nodes.machine.system.build.toplevel}/specialisation";
      uid = toString nodes.machine.users.users.alice.uid;
    in
    ''
      import json
      import shlex
      from collections import namedtuple
      from typing import Any, Optional

      Result = namedtuple("Result", ["command", "machine", "status", "out", "value"])
      Value = namedtuple("Value", ["type", "data"])

      def busctl(node: Machine, *args: Any, user: Optional[str] = None) -> Result:
          command = f"busctl --json=short {shlex.join(map(str, args))}"
          if user is not None:
              command = f"su - {user} -c {shlex.quote(command)}"
          (status, out) = node.execute(command)
          out = out.strip()
          value = json.loads(out, object_hook=lambda x: Value(**x)) if status == 0 and out else None
          return Result(command, node, status, out, value)

      def assert_result_success(result: Result):
          if result.status != 0:
              result.machine.log(f"output: {result.out}")
              raise Exception(f"command `{result.command}` failed (exit code {result.status})")

      def assert_result_fail(result: Result):
          if result.status == 0:
              raise Exception(f"command `{result.command}` unexpectedly succeeded")

      def rtkit_make_process_realtime(node: Machine, pid: int, priority: int, user: Optional[str] = None) -> Result:
          return busctl(node, "call", "org.freedesktop.RealtimeKit1", "/org/freedesktop/RealtimeKit1", "org.freedesktop.RealtimeKit1", "MakeThreadRealtimeWithPID", "ttu", pid, 0, priority, user=user)

      def get_max_realtime_priority() -> int:
          result = busctl(machine, "get-property", "org.freedesktop.RealtimeKit1", "/org/freedesktop/RealtimeKit1", "org.freedesktop.RealtimeKit1", "MaxRealtimePriority")
          assert_result_success(result)
          assert result.value.type == "i", f"""Unexpected MaxRealtimePriority property type ({result.value})"""
          return int(result.value.data)

      def parse_chrt(out: str, field: str) -> str:
          return next(map(lambda l: l.split(": ")[1], filter(lambda l: field in l, out.splitlines())))

      def get_pid(node: Machine, unit: str, user: Optional[str] = None) -> int:
          node.wait_for_unit(unit, user=user)
          (status, out) = node.systemctl(f"show -P MainPID {unit}", user=user)
          if status == 0:
              return int(out.strip())
          else:
              node.log(out)
              raise Exception(f"unable to determine MainPID of {unit} (systemctl exit code {status})")

      def assert_sched(node: Machine, pid: int, policy: Optional[str] = None, priority: Optional[int] = None):
          out = node.succeed(f"chrt -p {pid}")
          node.log(out)
          if policy is not None:
              thread_policy = parse_chrt(out, "policy")
              assert policy in thread_policy, f"Expected {policy} scheduling policy, but got: {thread_policy}"
          if priority is not None:
              thread_priority = parse_chrt(out, "priority")
              assert str(priority) == thread_priority, f"Expected scheduling priority {priority}, but got: {thread_priority}"

      machine.wait_for_unit("basic.target")

      rtprio = 20
      higher_rtprio = 42
      max_rtprio = get_max_realtime_priority()

      with subtest("maximum sched_rr priority"):
          assert max_rtprio >= rtprio, f"""MaxRealtimePriority ({max_rtprio}) too low"""
          assert higher_rtprio > max_rtprio, f"""Test value higher_rtprio ({higher_rtprio}) insufficient compared to MaxRealtimePriority ({max_rtprio})"""

      # wait for autologin and systemd user service manager
      machine.wait_for_unit("multi-user.target")
      machine.wait_for_unit("user@${uid}.service")

      with subtest("polkit sanity check"):
          pid = get_pid(machine, "sleeper.service", user="alice")
          machine.succeed(f"pkcheck -p {pid} -a org.freedesktop.RealtimeKit1.acquire-real-time")

      with subtest("chrt sanity check"):
          print(machine.succeed("chrt --rr --max"))
          pid = get_pid(machine, "sleeper.service", user="alice")
          machine.succeed(f"chrt --rr --pid {rtprio} {pid}")
          assert_sched(machine, pid, policy="SCHED_RR", priority=rtprio)
          machine.stop_job("sleeper.service", user="alice")
          machine.start_job("sleeper.service", user="alice")

      # Permission granted by policy from rtkit package.
      with subtest("local user process can acquire real-time scheduling"):
          pid = get_pid(machine, "sleeper.service", user="alice")
          result = rtkit_make_process_realtime(machine, pid, rtprio, user="alice")
          assert_result_success(result)
          assert_sched(machine, pid, policy="SCHED_RR", priority=rtprio)

      # User must not get higher priority than the maximum
      with subtest("real-time scheduling priority is limited"):
          machine.stop_job("sleeper.service", user="alice")
          machine.start_job("sleeper.service", user="alice")
          pid = get_pid(machine, "sleeper.service", user="alice")
          with machine.nested("rtkit call must fail"):
              result = rtkit_make_process_realtime(machine, pid, max_rtprio + 1, user="alice")
              assert_result_fail(result)
          assert_sched(machine, pid, policy="SCHED_OTHER")

      # This is a local shop for local people - we'll have no trouble here.
      # In this test, the target process belongs to alice, but doesn't
      # have a user session, so it's considered non-local.
      with subtest("non-local user process cannot acquire real-time scheduling"):
          pid = get_pid(machine, "sleeper@alice.service")
          with machine.nested("rtkit call must fail"):
              result = rtkit_make_process_realtime(machine, pid, rtprio, "alice")
              assert_result_fail(result)
          assert_sched(machine, pid, policy="SCHED_OTHER")

      # Switch to alternate configuration then ask for higher priority.
      with subtest("command-line arguments allow increasing maximum rtprio"):
          machine.succeed("${specialisations}/withHigherPrio/bin/switch-to-configuration test")
          pid = get_pid(machine, "sleeper.service", user="alice")
          result = rtkit_make_process_realtime(machine, pid, higher_rtprio, user="alice")
          assert_result_success(result)
          assert_sched(machine, pid, policy="SCHED_RR", priority=higher_rtprio)
    '';
}
