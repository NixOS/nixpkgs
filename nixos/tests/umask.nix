{ pkgs, ... }:
{
  name = "umask";
  meta.maintainers = with pkgs.lib.maintainers; [ majiir ];

  nodes.machine = {
    users.users.test = {
      isNormalUser = true;
    };
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    home_mode = machine.succeed("stat -c '%a' /home/test").strip()
    assert home_mode == "700", f"Home directory has incorrect permissions: {home_mode}"

    machine.succeed("su test -l -c 'mkdir /home/test/foo'")
    dir_mode = machine.succeed("stat -c '%a' /home/test/foo").strip()
    assert dir_mode == "755", f"New directory has incorrect permissions: {dir_mode}"

    machine.succeed("su test -l -c 'touch /home/test/foo/bar'")
    file_mode = machine.succeed("stat -c '%a' /home/test/foo/bar").strip()
    assert file_mode == "644", f"New file has incorrect permissions: {file_mode}"
  '';
}
