{ lib, ... }:
{
  name = "systemd-initrd-terminfo";

  meta.maintainers = [ lib.maintainers.elvishjerricco ];

  nodes.machine =
    { config, ... }:
    {
      boot.initrd.systemd = {
        enable = true;
        extraBin.script = "${config.boot.initrd.systemd.package.util-linux}/bin/script";
      };
      testing.initrdBackdoor = true;
    };

  testScript = ''
    machine.wait_for_unit("initrd.target")
    rc, out = machine.execute("echo q | script -q -e -c 'yes | less' /dev/null")
    assert "terminals database is inaccessible" not in out
  '';
}
