import ./make-test-python.nix ({ pkgs, ... }: {
  name = "swraid";
  meta = { };

  nodes.machine = { pkgs, lib, ... }:
    {
      virtualisation = {
        emptyDiskImages = [ 16 16 16 ];
      };
      boot.initrd = {
        services.swraid = {
          enable = true;
          mdadmConf = ''
            ARRAY /dev/md0 devices=/dev/vdb,/dev/vdc,/dev/vdd
          '';
        };
      };
      hardware.raid.swraid.monitor.enable = true;
    };

  testScript = ''
    machine.require_unit_state("mdcheck_start.timer", "active")
    machine.require_unit_state("mdcheck_start.service", "inactive")
    # conditional check would not pass since an mdcheck hasn't been started
    machine.require_unit_state("mdcheck_continue.timer", "inactive")
    machine.require_unit_state("mdcheck_continue.service", "inactive")
    # ensure mdadm's unconfigured systemd unit mdmonitor.service isn't sitting around causing confusion
    assert 'LoadError' in machine.get_unit_info("mdmonitor.service")

    # ensure timers don't interfere with test script
    machine.systemctl("disable mdcheck_start.timer")
    machine.systemctl("disable mdcheck_continue.timer")

    # Create a raid
    machine.succeed("mdadm --create --force /dev/md0 -n 3 --level=raid5 /dev/vdb /dev/vdc /dev/vdd")
    machine.wait_until_succeeds('[[ "$(cat /sys/devices/virtual/block/md0/md/sync_action)" = "idle" ]]')

    # Reboot to ensure last_sync_action is cleared to none
    machine.shutdown()
    machine.start()
    machine.wait_for_unit("multi-user.target")

    last_sync_action = machine.succeed("cat /sys/devices/virtual/block/md0/md/last_sync_action")
    if last_sync_action.strip() != "none":
      raise Exception("last_sync_action expected none, but was %s" % last_sync_action)

    # note: mdcheck takes at least 2 minutes even though the check operation is
    # a few seconds; the mdcheck script only checks the array status every 2 min
    machine.systemctl("start mdcheck_start.service")
    machine.require_unit_state("mdcheck_start.service", "inactive") # not failed

    last_sync_action = machine.succeed("cat /sys/devices/virtual/block/md0/md/last_sync_action")
    if last_sync_action.strip() != "check":
      raise Exception("last_sync_action expected check, but was %s" % last_sync_action)
  '';
})
