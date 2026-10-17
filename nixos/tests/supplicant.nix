{ lib, ... }:
let
  wired = {
    driver = "wired";
    extraConf = "ap_scan=0";
  };
in
{
  name = "supplicant";
  meta.maintainers = [ ];

  nodes.machine = {
    networking.supplicant.LAN = wired;
  };

  nodes.predictable = {
    networking.usePredictableInterfaceNames = lib.mkForce true;
    # The test harness normally renames the NIC to eth1 and assigns its IP.
    # Let systemd name it instead; the test uses the driver's serial console.
    boot.initrd.services.udev.rules = lib.mkForce "";
    networking.interfaces = lib.mkForce { };
    networking.supplicant.LAN = wired;
  };

  nodes.explicit = {
    networking.supplicant = {
      eth1 = wired;
      LAN = wired;
    };
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("supplicant-lan@eth1.service")
    machine.fail("test -e /etc/systemd/system/multi-user.target.wants/supplicant-lan@.service")

    # The instance is reachable only through the udev rules, and udev does not
    # replay "add" for an interface that already exists. Re-running the trigger
    # has to bring it back, or a rebuild would leave it stopped until a reboot.
    machine.succeed("systemctl stop supplicant-lan@eth1.service")
    machine.succeed("systemctl restart supplicant-udev-trigger.service")
    # Triggering the uevent does not wait for systemd to queue the start job.
    machine.wait_until_succeeds("systemctl is-active supplicant-lan@eth1.service")

    # Renamed wired interfaces must still receive their own instance.
    predictable.wait_for_unit("multi-user.target")
    interfaces = predictable.succeed(
        "find /sys/class/net -mindepth 1 -maxdepth 1 -name 'en*' -printf '%f\\n'"
    ).split()
    assert interfaces, "No predictably named wired interfaces found"
    for interface in interfaces:
        predictable.wait_for_unit(f"supplicant-lan@{interface}.service")
        predictable.succeed(
            f"udevadm info --query=property /sys/class/net/{interface}"
            f" | grep '^SYSTEMD_WANTS=' | grep -F 'supplicant-lan@{interface}.service'"
        )
        predictable.succeed(f"systemctl stop supplicant-lan@{interface}.service")
    predictable.succeed("systemctl restart supplicant-udev-trigger.service")
    for interface in interfaces:
        predictable.wait_until_succeeds(f"systemctl is-active supplicant-lan@{interface}.service")

    # An explicit configuration takes precedence over the LAN catch-all.
    explicit.wait_for_unit("multi-user.target")
    explicit.wait_for_unit("supplicant-eth1.service")
    explicit.succeed(
        "udevadm info --query=property /sys/class/net/eth1 | grep -F SUPPLICANT_ASSIGNED"
    )
    explicit.fail("systemctl is-active supplicant-lan@eth1.service")
  '';
}
