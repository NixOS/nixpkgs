{ pkgs, runTest }:
{
  autobalance = runTest {
    name = "btrfs-autobalance";

    nodes.machine = { ... }: {
      virtualisation.emptyDiskImages = [ 128 ];
      # test sandbox permissiveness and command line escaping
      virtualisation.fileSystems."/home/test/btrfs autobalance test" = {
        fsType = "btrfs";
        device = "/dev/vdb";
        autoFormat = true;
        options = [ "X-mount.mkdir" ];
      };
      services.btrfs.autoBalance = {
        enable = true;
        # test that ranges are accepted
        musage = "..3";
        dlimit = 1;
        mlimit = "..1";
      };
    };

    testScript = ''
      def run_balance(fs):
        machine.start_job(f"'btrfs-balance@{fs}.service'")
        machine.wait_until_fails(f"systemctl --quiet is-active 'btrfs-balance@{fs}.service'")
        machine.fail(f"systemctl is-failed 'btrfs-balance@{fs}.service'")
        invocation_id = machine.succeed(
          f"systemctl show --value -p InvocationID 'btrfs-balance@{fs}.service'"
        )
        output = machine.succeed(
          f"journalctl --no-pager _SYSTEMD_INVOCATION_ID={invocation_id}"
        )
        t.assertNotRegex(output, "(?i)warning:|error:")

      start_all()
      machine.wait_for_unit("multi-user.target")

      fs = "/home/test/btrfs autobalance test"
      escaped = r"home-test-btrfs\x20autobalance\x20test"

      with subtest("Verify that the configured timers and file systems are active"):
        machine.require_unit_state(f"{escaped}.mount", "active")
        machine.require_unit_state(f"btrfs-balance@{escaped}.timer", "active")

      # disable timers (and possible triggered services) to prevent them
      # from interfering with the tests
      machine.stop_job(f"'btrfs-balance@{escaped}.timer'")
      machine.stop_job(f"'btrfs-balance@{escaped}.service'")

      with subtest("Verify that balancing works"):
        run_balance(escaped)
        result = machine.succeed(f"btrfs balance status '{fs}'").rstrip()
        t.assertEqual(result, f"No balance found on '{fs}'")

      with subtest("Verify that balancing causes filesystems to be mounted"):
        machine.stop_job(f"'{escaped}.mount'")
        run_balance(escaped)
        machine.require_unit_state(f"{escaped}.mount", "active")

      with subtest("Verify that the service can balance private mountpoints"):
        machine.succeed(f"chmod 000 '{fs}'")
        machine.succeed("chmod 000 /home/test")
        run_balance(escaped)
    '';
  };

  autoscrub = runTest {
    name = "btrfs-autoscrub";

    nodes.machine =
      { ... }:
      {
        virtualisation.emptyDiskImages = [ 128 ];
        # test sandbox permissiveness and command line escaping
        virtualisation.fileSystems."/home/test/btrfs autoscrub test" = {
          fsType = "btrfs";
          device = "/dev/vdb";
          autoFormat = true;
          options = [ "X-mount.mkdir" ];
        };
        services.btrfs.autoScrub = {
          enable = true;
          # test that setting the limit works
          limit = "1G";
        };
      };

    testScript = ''
      def run_scrub(fs):
        machine.start_job(f"'btrfs-scrub@{fs}.service'")
        machine.wait_until_fails(f"systemctl --quiet is-active 'btrfs-scrub@{fs}.service'")
        machine.fail(f"systemctl is-failed 'btrfs-scrub@{fs}.service'")
        invocation_id = machine.succeed(
          f"systemctl show --value -p InvocationID 'btrfs-scrub@{fs}.service'"
        )
        output = machine.succeed(
          f"journalctl --no-pager _SYSTEMD_INVOCATION_ID={invocation_id}"
        )
        t.assertNotRegex(output, "(?i)warning:|error:")

      start_all()
      machine.wait_for_unit("multi-user.target")

      fs = "/home/test/btrfs autoscrub test"
      escaped = r"home-test-btrfs\x20autoscrub\x20test"

      with subtest("Verify that the configured timers and file systems are active"):
        machine.require_unit_state(f"{escaped}.mount", "active")
        machine.require_unit_state(f"btrfs-scrub@{escaped}.timer", "active")

      # disable timers (and possible triggered services) to prevent them
      # from interfering with the tests
      machine.stop_job(f"'btrfs-scrub@{escaped}.timer'")
      machine.stop_job(f"'btrfs-scrub@{escaped}.service'")

      with subtest("Verify that scrubbing works"):
        run_scrub(escaped)
        result = machine.succeed(f"btrfs scrub status '{fs}'")
        t.assertRegex(result, r"Status:\s*finished")

      with subtest("Verify that scrubbing causes filesystems to be mounted"):
        machine.stop_job(f"'{escaped}.mount'")
        run_scrub(escaped)
        machine.require_unit_state(f"{escaped}.mount", "active")

      with subtest("Verify that the service can scrub private mountpoints"):
        machine.succeed(f"chmod 000 '{fs}'")
        machine.succeed("chmod 000 /home/test")
        run_scrub(escaped)

      with subtest("Verify that the service can scrub device files directly"):
        run_scrub("dev-vdb")
    '';
  };
}
