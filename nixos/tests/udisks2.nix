{ pkgs, ... }:

let

  # FIXME: 404s
  stick = pkgs.fetchurl {
    url = "https://nixos.org/~eelco/nix/udisks-test.img.xz";
    sha256 = "0was1xgjkjad91nipzclaz5biv3m4b2nk029ga6nk7iklwi19l8b";
  };

in

{
  name = "udisks2";
  meta = {
    maintainers = [ ];
  };

  nodes = {
    machine = {
      services.udisks2.enable = true;
      imports = [ ./common/user-account.nix ];

      security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (subject.user == "alice") return "yes";
        });
      '';
    };

    # Seperate vm because it's not possible to reboot into a specialisation with
    # switch-to-configuration: https://github.com/NixOS/nixpkgs/issues/82851
    # For one of the test we check if manual changes are overridden during
    # reboot, therefore it's necessary to reboot into a declarative setup.
    machineWithMountOnMedia = {
      services.udisks2.enable = true;
      services.udisks2.mountOnMedia = true;
      imports = [ ./common/user-account.nix ];

      security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (subject.user == "alice") return "yes";
        });
      '';
    };
  };

  testScript = ''
    import lzma

    with lzma.open(
        "${stick}"
    ) as data, open(machine.state_dir / "usbstick.img", "wb") as stick:
        stick.write(data.read())

    def run(machine, mountOnMedia):
      root_dir = "/media" if mountOnMedia else "/run/media/alice"

      machine.systemctl("start udisks2.service")
      machine.wait_for_unit("udisks2.service")
      machine.succeed("udisksctl info -b /dev/vda >&2")
      machine.fail("udisksctl info -b /dev/sda1")

      with subtest(f"[{root_dir}] Attach a USB stick and wait for it to show up"):
        machine.send_monitor_command(
            f"drive_add 0 id=stick,if=none,file={stick.name},format=raw"
        )
        machine.send_monitor_command("device_add usb-storage,id=stick,drive=stick")
        machine.wait_until_succeeds("udisksctl info -b /dev/sda1")
        machine.succeed("udisksctl info -b /dev/sda1 | grep 'IdLabel:.*USBSTICK'")

      with subtest(f"[{root_dir}] Mount the stick as a non-root user and do some stuff with it"):
        machine.succeed("su - alice -c 'udisksctl info -b /dev/sda1'")
        machine.succeed("su - alice -c 'udisksctl mount -b /dev/sda1'")
        machine.succeed(
          f"su - alice -c 'cat {root_dir}/USBSTICK/test.txt' | grep -q 'Hello World'"
        )
        machine.succeed(f"su - alice -c 'echo foo > {root_dir}/USBSTICK/bar.txt'")

      with subtest(f"[{root_dir}] Unmounting the stick should make the mountpoint disappear"):
        machine.succeed("su - alice -c 'udisksctl unmount -b /dev/sda1'")
        machine.fail(f"[ -d {root_dir}/USBSTICK ]")

      with subtest(f"[{root_dir}] Remove the USB stick"):
        machine.send_monitor_command("device_del stick")
        machine.wait_until_fails("udisksctl info -b /dev/sda1")
        machine.fail("[ -e /dev/sda ]")

      machine.shutdown()

    run(machine, False)
    run(machineWithMountOnMedia, True)
  '';
}
