import ./make-test-python.nix ({ pkgs, ... }: {
  name = "usbguard";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ tnias ];
  };

  nodes.machine =
    { ... }:
    {
      services.usbguard = {
        enable = true;
        IPCAllowedUsers = [ "alice" "root" ];

        # As virtual USB devices get attached to the "QEMU USB Hub" we need to
        # allow Hubs. Otherwise we would have to explicitly allow them too.
        rules = ''
          allow with-interface equals { 09:00:00 }
        '';
      };
      imports = [ ./common/user-account.nix ];
    };

  testScript = ''
    # create a blank disk image for our fake USB stick
    with open(machine.state_dir / "usbstick.img", "wb") as stick:
        stick.write(b"\x00" * (1024 * 1024))

    # wait for machine to have started and the usbguard service to be up
    machine.wait_for_unit("usbguard.service")

    with subtest("IPC access control"):
        # User "alice" is allowed to access the IPC interface
        machine.succeed("su alice -c 'usbguard list-devices'")

        # User "bob" is not allowed to access the IPC interface
        machine.fail("su bob -c 'usbguard list-devices'")

    with subtest("check basic functionality"):
        # at this point we expect that no USB HDD is connected
        machine.fail("usbguard list-devices | grep -E 'QEMU USB HARDDRIVE'")

        # insert usb device
        machine.send_monitor_command(
            f"drive_add 0 id=stick,if=none,file={stick.name},format=raw"
        )
        machine.send_monitor_command("device_add usb-storage,id=stick,drive=stick")

        # the attached USB HDD should show up after a short while
        machine.wait_until_succeeds("usbguard list-devices | grep -E 'QEMU USB HARDDRIVE'")

        # at this point there should be a **blocked** USB HDD
        machine.succeed("usbguard list-devices | grep -E 'block.*QEMU USB HARDDRIVE'")
        machine.fail("usbguard list-devices | grep -E ' allow .*QEMU USB HARDDRIVE'")

        # allow storage devices
        machine.succeed("usbguard allow-device 'with-interface { 08:*:* }'")

        # at this point there should be an **allowed** USB HDD
        machine.succeed("usbguard list-devices | grep -E ' allow .*QEMU USB HARDDRIVE'")
        machine.fail("usbguard list-devices | grep -E ' block .*QEMU USB HARDDRIVE'")
  '';
})
