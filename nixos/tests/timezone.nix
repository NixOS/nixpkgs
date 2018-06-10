{
  timezone-static = import ./make-test.nix ({ pkgs, ... }: {
    name = "timezone-static";
    meta.maintainers = with pkgs.lib.maintainers; [ lheckemann ];

    machine.time.timeZone = "Europe/Amsterdam";

    testScript = ''
      $machine->waitForUnit("dbus.socket");
      $machine->fail("timedatectl set-timezone Asia/Tokyo");
      my @dateResult = $machine->execute('date -d @0 "+%Y-%m-%d %H:%M:%S"');
      $dateResult[1] eq "1970-01-01 01:00:00\n" or die "Timezone seems to be wrong";
    '';
  });

  timezone-imperative = import ./make-test.nix ({ pkgs, ... }: {
    name = "timezone-imperative";
    meta.maintainers = with pkgs.lib.maintainers; [ lheckemann ];

    machine.time.timeZone = null;

    testScript = ''
      $machine->waitForUnit("dbus.socket");

      # Should default to UTC
      my @dateResult = $machine->execute('date -d @0 "+%Y-%m-%d %H:%M:%S"');
      print $dateResult[1];
      $dateResult[1] eq "1970-01-01 00:00:00\n" or die "Timezone seems to be wrong";

      $machine->succeed("timedatectl set-timezone Asia/Tokyo");

      # Adjustment should be taken into account
      my @dateResult = $machine->execute('date -d @0 "+%Y-%m-%d %H:%M:%S"');
      print $dateResult[1];
      $dateResult[1] eq "1970-01-01 09:00:00\n" or die "Timezone was not adjusted";

      # Adjustment should persist across a reboot
      $machine->shutdown;
      $machine->waitForUnit("dbus.socket");
      my @dateResult = $machine->execute('date -d @0 "+%Y-%m-%d %H:%M:%S"');
      print $dateResult[1];
      $dateResult[1] eq "1970-01-01 09:00:00\n" or die "Timezone adjustment was not persisted";
    '';
  });
}
