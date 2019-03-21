import ./make-test.nix ({ pkgs, ... }:

let

  stick = pkgs.fetchurl {
    url = http://nixos.org/~eelco/nix/udisks-test.img.xz;
    sha256 = "0was1xgjkjad91nipzclaz5biv3m4b2nk029ga6nk7iklwi19l8b";
  };

in

{
  name = "udisks2";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco ];
  };

  machine =
    { ... }:
    { services.udisks2.enable = true;
      imports = [ ./common/user-account.nix ];

      security.polkit.extraConfig =
        ''
          polkit.addRule(function(action, subject) {
            if (subject.user == "alice") return "yes";
          });
        '';
    };

  testScript =
    ''
      my $stick = $machine->stateDir . "/usbstick.img";
      system("xz -d < ${stick} > $stick") == 0 or die;

      $machine->succeed("udisksctl info -b /dev/vda >&2");
      $machine->fail("udisksctl info -b /dev/sda1");

      # Attach a USB stick and wait for it to show up.
      $machine->sendMonitorCommand("drive_add 0 id=stick,if=none,file=$stick,format=raw");
      $machine->sendMonitorCommand("device_add usb-storage,id=stick,drive=stick");
      $machine->waitUntilSucceeds("udisksctl info -b /dev/sda1");
      $machine->succeed("udisksctl info -b /dev/sda1 | grep 'IdLabel:.*USBSTICK'");

      # Mount the stick as a non-root user and do some stuff with it.
      $machine->succeed("su - alice -c 'udisksctl info -b /dev/sda1'");
      $machine->succeed("su - alice -c 'udisksctl mount -b /dev/sda1'");
      $machine->succeed("su - alice -c 'cat /run/media/alice/USBSTICK/test.txt'") =~ /Hello World/ or die;
      $machine->succeed("su - alice -c 'echo foo > /run/media/alice/USBSTICK/bar.txt'");

      # Unmounting the stick should make the mountpoint disappear.
      $machine->succeed("su - alice -c 'udisksctl unmount -b /dev/sda1'");
      $machine->fail("[ -d /run/media/alice/USBSTICK ]");

      # Remove the USB stick.
      $machine->sendMonitorCommand("device_del stick");
      $machine->waitUntilFails("udisksctl info -b /dev/sda1");
      $machine->fail("[ -e /dev/sda ]");
    '';

})
