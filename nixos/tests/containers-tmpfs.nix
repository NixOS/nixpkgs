{ pkgs, lib, ... }:
{
  name = "containers-tmpfs";
  meta = {
    maintainers = with lib.maintainers; [ patryk27 ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [ ../modules/installer/cd-dvd/channel.nix ];
      virtualisation.writableStore = true;

      containers.tmpfs = {
        autoStart = true;
        tmpfs = [
          # Mount var as a tmpfs
          "/var"

          # Add a nested mount inside a tmpfs
          "/var/log"

          # Add a tmpfs on a path that does not exist
          "/some/random/path"
        ];
        config = { };
      };

      virtualisation.additionalPaths = [ pkgs.stdenv ];
    };

  testScript = ''
    machine.wait_for_unit("default.target")
    assert "tmpfs" in machine.succeed("nixos-container list")

    with subtest("tmpfs container is up"):
        assert "up" in machine.succeed("nixos-container status tmpfs")


    def tmpfs_cmd(command):
        return f"nixos-container run tmpfs -- {command} 2>/dev/null"


    with subtest("/var is mounted as a tmpfs"):
        machine.succeed(tmpfs_cmd("mountpoint -q /var"))

    with subtest("/var/log is mounted as a tmpfs"):
        assert "What: tmpfs" in machine.succeed(
            tmpfs_cmd("systemctl status var-log.mount --no-pager")
        )
        machine.succeed(tmpfs_cmd("mountpoint -q /var/log"))

    with subtest("/some/random/path is mounted as a tmpfs"):
        assert "What: tmpfs" in machine.succeed(
            tmpfs_cmd("systemctl status some-random-path.mount --no-pager")
        )
        machine.succeed(tmpfs_cmd("mountpoint -q /some/random/path"))

    with subtest(
        "files created in the container in a non-tmpfs directory are visible on the host."
    ):
        # This establishes legitimacy for the following tests
        machine.succeed(
            tmpfs_cmd("touch /root/test.file"),
            tmpfs_cmd("ls -l  /root | grep -q test.file"),
            "test -e /var/lib/nixos-containers/tmpfs/root/test.file",
        )

    with subtest(
        "/some/random/path is writable and that files created there are not "
        + "in the hosts container dir but in the tmpfs"
    ):
        machine.succeed(
            tmpfs_cmd("touch /some/random/path/test.file"),
            tmpfs_cmd("test -e /some/random/path/test.file"),
        )
        machine.fail("test -e /var/lib/nixos-containers/tmpfs/some/random/path/test.file")

    with subtest(
        "files created in the hosts container dir in a path where a tmpfs "
        + "file system has been mounted are not visible to the container as "
        + "they do not exist in the tmpfs"
    ):
        machine.succeed(
            "touch /var/lib/nixos-containers/tmpfs/var/test.file",
            "test -e /var/lib/nixos-containers/tmpfs/var/test.file",
            "ls -l /var/lib/nixos-containers/tmpfs/var/ | grep -q test.file 2>/dev/null",
        )
        machine.fail(tmpfs_cmd("ls -l /var | grep -q test.file"))
  '';
}
