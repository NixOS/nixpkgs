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
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ];
  };

  nodes.machine =
    { ... }:
    {
      services.udisks2.enable = true;
      imports = [ ./common/user-account.nix ];

      security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (subject.user == "alice") return "yes";
        });
      '';
    };

  testScript = ''
    import lzma

    machine.systemctl("start udisks2")
    machine.wait_for_unit("udisks2.service")

    with lzma.open(
        "${stick}"
    ) as data, open(machine.state_dir / "usbstick.img", "wb") as stick:
        stick.write(data.read())

    machine.succeed("udisksctl info -b /dev/vda >&2")
    machine.fail("udisksctl info -b /dev/sda1")

    # Attach a USB stick and wait for it to show up.
    machine.send_monitor_command(
        f"drive_add 0 id=stick,if=none,file={stick.name},format=raw"
    )
    machine.send_monitor_command("device_add usb-storage,id=stick,drive=stick")
    machine.wait_until_succeeds("udisksctl info -b /dev/sda1")
    machine.succeed("udisksctl info -b /dev/sda1 | grep 'IdLabel:.*USBSTICK'")

    # Mount the stick as a non-root user and do some stuff with it.
    machine.succeed("su - alice -c 'udisksctl info -b /dev/sda1'")
    machine.succeed("su - alice -c 'udisksctl mount -b /dev/sda1'")
    machine.succeed(
        "su - alice -c 'cat /run/media/alice/USBSTICK/test.txt' | grep -q 'Hello World'"
    )
    machine.succeed("su - alice -c 'echo foo > /run/media/alice/USBSTICK/bar.txt'")

    # Unmounting the stick should make the mountpoint disappear.
    machine.succeed("su - alice -c 'udisksctl unmount -b /dev/sda1'")
    machine.fail("[ -d /run/media/alice/USBSTICK ]")

    # Remove the USB stick.
    machine.send_monitor_command("device_del stick")
    machine.wait_until_fails("udisksctl info -b /dev/sda1")
    machine.fail("[ -e /dev/sda ]")
  '';

}
