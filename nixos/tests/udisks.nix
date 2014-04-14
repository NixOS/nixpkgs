{ pkgs, ... }:

let

  stick = pkgs.fetchurl {
    url = http://nixos.org/~eelco/nix/udisks-test.img.xz;
    sha256 = "0was1xgjkjad91nipzclaz5biv3m4b2nk029ga6nk7iklwi19l8b";
  };

in

{

  machine =
    { config, pkgs, ... }:
    { services.udisks.enable = true;
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

      $machine->succeed("udisks --enumerate | grep /org/freedesktop/UDisks/devices/vda");
      $machine->fail("udisks --enumerate | grep /org/freedesktop/UDisks/devices/sda1");

      # Attach a USB stick and wait for it to show up.
      $machine->sendMonitorCommand("usb_add disk:$stick");
      $machine->waitUntilSucceeds("udisks --enumerate | grep /org/freedesktop/UDisks/devices/sda1");
      $machine->succeed("udisks --show-info /dev/sda1 | grep 'label:.*USBSTICK'");

      # Mount the stick as a non-root user and do some stuff with it.
      $machine->succeed("su - alice -c 'udisks --enumerate | grep /org/freedesktop/UDisks/devices/sda1'");
      $machine->succeed("su - alice -c 'udisks --mount /dev/sda1'");
      $machine->succeed("su - alice -c 'cat /media/USBSTICK/test.txt'") =~ /Hello World/;
      $machine->succeed("su - alice -c 'echo foo > /media/USBSTICK/bar.txt'");

      # Unmounting the stick should make the mountpoint disappear.
      $machine->succeed("su - alice -c 'udisks --unmount /dev/sda1'");
      $machine->fail("[ -d /media/USBSTICK ]");

      # Remove the USB stick.
      $machine->sendMonitorCommand("usb_del 0.3"); # FIXME
      $machine->waitUntilFails("udisks --enumerate | grep /org/freedesktop/UDisks/devices/sda1");
      $machine->fail("[ -e /dev/sda ]");
    '';

}