{ pkgs, ... }:
{
  name = "timezone";
  meta.maintainers = [ ];

  nodes = {
    node_eutz =
      { pkgs, ... }:
      {
        time.timeZone = "Europe/Amsterdam";
      };

    node_nulltz =
      { pkgs, ... }:
      {
        time.timeZone = null;
      };
  };

  testScript =
    { nodes, ... }:
    ''
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

          # Stop systemd-timedated.service to clear /etc/localtime read cache
          node_nulltz.systemctl("stop systemd-timedated.service")
          timedatectl_result = node_nulltz.succeed("timedatectl status")
          print(timedatectl_result)
          assert "Asia/Tokyo" in timedatectl_result, "'timedatectl status' output is missing 'Asia/Tokyo'"

      with subtest("imperative - Ensure /etc/localtime symlink includes '/zoneinfo/' like icu expects"):
          # https://github.com/unicode-org/icu/blob/release-78.3/icu4c/source/common/putil.cpp#L686-L695
          readlink_result = node_nulltz.succeed("readlink --no-newline /etc/localtime")
          print(readlink_result)
          assert "/zoneinfo/" in readlink_result, f"/etc/localtime symlink is missing '/zoneinfo/': {readlink_result}"

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
}
