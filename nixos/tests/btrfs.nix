{ pkgs, runTest }:
{
  autobalance = runTest {
    name = "btrfs-autobalance";
    meta.maintainers = with pkgs.lib.maintainers; [
      Deric-W
    ];

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
    meta.maintainers = with pkgs.lib.maintainers; [
      Deric-W
    ];

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

  locking = runTest {
    name = "btrfs-locking";
    meta.maintainers = with pkgs.lib.maintainers; [
      Deric-W
    ];

    nodes.machine =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          pkgs.coreutils
          pkgs.util-linux
          pkgs.gnused
        ];
        # somehow requires more free disk space that the other tests
        virtualisation.emptyDiskImages = [ 256 ];
        virtualisation.fileSystems."/mnt/test" = {
          fsType = "btrfs";
          device = "/dev/vdb";
          autoFormat = true;
          options = [ "X-mount.mkdir" ];
        };
        services.btrfs = {
          autoScrub.enable = true;
          autoBalance.enable = true;
        };
      };

    testScript = ''
      import contextlib

      @contextlib.contextmanager
      def run_service(service):
        machine.start_job(f"'{service}'")
        invocation_id = machine.succeed(
          f"systemctl show --value -p InvocationID '{service}'"
        ).rstrip()

        yield invocation_id

        machine.wait_until_fails(f"systemctl --quiet is-active '{service}'")
        machine.fail(f"systemctl is-failed '{service}'")
        output = machine.succeed(
          f"journalctl --no-pager _SYSTEMD_INVOCATION_ID={invocation_id}"
        )
        t.assertNotRegex(output, "(?i)warning:|error:")

      def wait_for_lock(invocation_id):
        machine.wait_until_succeeds(
          f"journalctl --no-pager _SYSTEMD_INVOCATION_ID={invocation_id}"
          " | grep --quiet 'Acquiring lock on '"
        )

      start_all()
      machine.wait_for_unit("multi-user.target")

      fs = "/mnt/test"
      escaped = "mnt-test"
      uuid = machine.succeed(
        f"btrfs filesystem show '{fs}' | sed -n -e '/uuid:/ {{s/^.*uuid: //;p }}'"
      ).rstrip()

      # disable timers (and possible triggered services) to prevent them
      # from interfering with the tests
      for service in ("scrub", "balance"):
        machine.stop_job(f"'btrfs-{service}@{escaped}.timer'")
        machine.stop_job(f"'btrfs-{service}@{escaped}.service'")

      # create btrfs runtime directory for manual locking
      machine.succeed("mkdir -p /run/btrfs")

      for service in ("scrub", "balance"):
        with subtest(f"Verify that {service} services wait for locks of their filesystem"):
          lockfile = f"/run/btrfs/maintainance-{uuid}.lock"
          _, _, pid = machine.succeed(
            f"flock -x --no-fork '{lockfile}' sleep infinity >&2 & echo $!"
          ).rstrip().rpartition("\n")
          with run_service(f"btrfs-{service}@{escaped}.service") as invocation_id:
            wait_for_lock(invocation_id)
            machine.succeed(f"kill -SIGTERM {pid}")

      for service in ("scrub", "balance"):
        with subtest(f"Verify that {service} services ignore locks for other file systems"):
          lockfile = "/run/btrfs/maintainance-other.lock"
          _, _, pid = machine.succeed(
            f"flock -x --no-fork '{lockfile}' sleep infinity >&2 & echo $!"
          ).rstrip().rpartition("\n")
          with run_service(f"btrfs-{service}@{escaped}.service"):
            pass
          machine.succeed(f"kill -SIGTERM {pid} && rm '{lockfile}'")

      for service in ("scrub", "balance"):
        with subtest(f"Verify that stopping a {service} service while waiting works"):
          lockfile = f"/run/btrfs/maintainance-{uuid}.lock"
          _, _, pid = machine.succeed(
            f"flock -x --no-fork '{lockfile}' sleep infinity >&2 & echo $!"
          ).rstrip().rpartition("\n")
          with run_service(f"btrfs-{service}@{escaped}.service") as invocation_id:
            wait_for_lock(invocation_id)
            machine.stop_job(f"btrfs-{service}@{escaped}.service")
          machine.succeed(f"kill -SIGTERM {pid}")
    '';
  };

  no-locking = runTest {
    name = "btrfs-no-locking";
    meta.maintainers = with pkgs.lib.maintainers; [
      Deric-W
    ];

    nodes.machine =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          pkgs.coreutils
          pkgs.util-linux
          pkgs.gnused
        ];
        # somehow requires more free disk space that the other tests
        virtualisation.emptyDiskImages = [ 256 ];
        virtualisation.fileSystems."/mnt/test" = {
          fsType = "btrfs";
          device = "/dev/vdb";
          autoFormat = true;
          options = [ "X-mount.mkdir" ];
        };
        services.btrfs = {
          allowConcurrency = true;
          autoScrub.enable = true;
          autoBalance.enable = true;
        };
      };

    testScript = ''
      def run_service(service):
        machine.start_job(f"'{service}'")
        invocation_id = machine.succeed(
          f"systemctl show --value -p InvocationID '{service}'"
        ).rstrip()
        machine.wait_until_fails(f"systemctl --quiet is-active '{service}'")
        machine.fail(f"systemctl is-failed '{service}'")
        output = machine.succeed(
          f"journalctl --no-pager _SYSTEMD_INVOCATION_ID={invocation_id}"
        )
        t.assertNotRegex(output, "(?i)warning:|error:")

      start_all()
      machine.wait_for_unit("multi-user.target")

      fs = "/mnt/test"
      escaped = "mnt-test"
      uuid = machine.succeed(
        f"btrfs filesystem show '{fs}' | sed -n -e '/uuid:/ {{s/^.*uuid: //;p }}'"
      ).rstrip()

      # disable timers (and possible triggered services) to prevent them
      # from interfering with the tests
      for service in ("scrub", "balance"):
        machine.stop_job(f"'btrfs-{service}@{escaped}.timer'")
        machine.stop_job(f"'btrfs-{service}@{escaped}.service'")

      # create btrfs runtime directory for manual locking
      machine.succeed("mkdir -p /run/btrfs")

      for service in ("scrub", "balance"):
        with subtest(f"Verify that {service} services do not wait for locks"):
          lockfile = f"/run/btrfs/maintainance-{uuid}.lock"
          _, _, pid = machine.succeed(
            f"flock -x --no-fork '{lockfile}' sleep infinity >&2 & echo $!"
          ).rstrip().rpartition("\n")
          run_service(f"btrfs-{service}@{escaped}.service")
          machine.succeed(f"kill -SIGTERM {pid}")
    '';
  };
}
