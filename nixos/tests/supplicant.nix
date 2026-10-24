{ lib, ... }:
let
  wired = {
    driver = "wired";
    extraConf = "ap_scan=0";
    userControlled.enable = true;
  };
in
{
  name = "supplicant";
  meta.maintainers = [ ];

  nodes.machine = {
    networking.supplicant.LAN = wired;
    # The patched supplicant uses client sockets to check an existing control socket.
    systemd.tmpfiles.rules = [ "d /run/wpa_supplicant/client 0700 root root -" ];
    specialisation = {
      explicit.configuration.networking.supplicant.eth1 = wired;
      withoutSupplicant.configuration.networking.supplicant = lib.mkForce { };
    };
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
    machine.wait_until_succeeds("wpa_cli -s /tmp -p /run/wpa_supplicant -i eth1 ping | grep -Fx PONG")

    # A new explicit assignment must retire the already running catch-all,
    # even though its template remains configured for the other interfaces.
    machine.succeed("/run/booted-system/specialisation/explicit/bin/switch-to-configuration test")
    machine.wait_for_unit("supplicant-eth1.service")
    machine.wait_until_succeeds("test $(systemctl is-active supplicant-lan@eth1.service) = inactive")
    machine.wait_until_succeeds("wpa_cli -s /tmp -p /run/wpa_supplicant -i eth1 ping | grep -Fx PONG")
    machine.succeed("udevadm info --query=property /sys/class/net/eth1 | grep '^SYSTEMD_WANTS=' | grep -F 'supplicant-eth1.service'")

    # Removing the explicit assignment restores the catch-all instance.
    machine.succeed("/run/booted-system/bin/switch-to-configuration test")
    machine.wait_until_succeeds("systemctl is-active supplicant-lan@eth1.service")
    machine.fail("systemctl is-active supplicant-eth1.service")
    machine.wait_until_succeeds("wpa_cli -s /tmp -p /run/wpa_supplicant -i eth1 ping | grep -Fx PONG")

    # Replaying unchanged rules must keep a still-needed instance running.
    main_pid = machine.succeed("systemctl show --property=MainPID --value supplicant-lan@eth1.service")
    machine.succeed("systemctl restart supplicant-udev-trigger.service", "udevadm settle")
    machine.wait_until_succeeds("systemctl is-active supplicant-lan@eth1.service")
    assert main_pid == machine.succeed("systemctl show --property=MainPID --value supplicant-lan@eth1.service")

    # Enabling the catch-all after boot must also start it for an active NIC.
    machine.succeed("/run/booted-system/specialisation/withoutSupplicant/bin/switch-to-configuration test")
    machine.fail("systemctl is-active supplicant-lan@eth1.service")
    machine.wait_for_unit("sys-subsystem-net-devices-eth1.device")
    machine.succeed("/run/booted-system/bin/switch-to-configuration test")
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
