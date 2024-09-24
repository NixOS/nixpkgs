import ./make-test-python.nix ({ pkgs, ...} : {
  name = "timezone";
  meta.maintainers = with pkgs.lib.maintainers; [ ];

  nodes = {
    node_eutz = { pkgs, ... }: {
      time.timeZone = "Europe/Amsterdam";
    };

    node_nulltz = { pkgs, ... }: {
      time.timeZone = null;
    };
  };

  testScript = { nodes, ... }: ''
      node_eutz.wait_for_unit("dbus.socket")

      with subtest("static - Ensure timezone change gives the correct result"):
          node_eutz.fail("timedatectl set-timezone Asia/Tokyo")
          date_result = node_eutz.succeed('date -d @0 "+%Y-%m-%d %H:%M:%S"')
          assert date_result == "1970-01-01 01:00:00\n", "Timezone seems to be wrong"

      node_nulltz.wait_for_unit("dbus.socket")

      with subtest("imperative - Ensure timezone defaults to UTC"):
          date_result = node_nulltz.succeed('date -d @0 "+%Y-%m-%d %H:%M:%S"')
          print(date_result)
          assert (
              date_result == "1970-01-01 00:00:00\n"
          ), "Timezone seems to be wrong (not UTC)"

      with subtest("imperative - Ensure timezone adjustment produces expected result"):
          node_nulltz.succeed("timedatectl set-timezone Asia/Tokyo")

          # Adjustment should be taken into account
          date_result = node_nulltz.succeed('date -d @0 "+%Y-%m-%d %H:%M:%S"')
          print(date_result)
          assert date_result == "1970-01-01 09:00:00\n", "Timezone was not adjusted"

      with subtest("imperative - Ensure timezone adjustment persists across reboot"):
          # Adjustment should persist across a reboot
          node_nulltz.shutdown()
          node_nulltz.wait_for_unit("dbus.socket")
          date_result = node_nulltz.succeed('date -d @0 "+%Y-%m-%d %H:%M:%S"')
          print(date_result)
          assert (
              date_result == "1970-01-01 09:00:00\n"
          ), "Timezone adjustment was not persisted"
  '';
})
