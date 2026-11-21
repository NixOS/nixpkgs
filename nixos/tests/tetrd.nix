{ ... }: {
  name = "tetrd";

  node.pkgsReadOnly = false;

  nodes.machine = {
    nixpkgs.config.allowUnfreePackages = [ "tetrd" ];
    services.tetrd.enable = true;
    networking.resolvconf.enable = true;
  };

  testScript = ''
    # Fail fast: wait_until_* defaults to 900s.
    DNS_TIMEOUT = 30

    def start_tetrd():
        machine.systemctl("start tetrd.service")
        machine.wait_until_succeeds(
            "systemctl is-active --quiet tetrd.service", timeout=DNS_TIMEOUT
        )

    def stop_tetrd():
        machine.systemctl("stop tetrd.service")
        machine.wait_until_fails(
            "systemctl is-active --quiet tetrd.service", timeout=DNS_TIMEOUT
        )

    def assert_owner(path, ref):
        machine.succeed(f'test "$(stat -c %u {path})" = "$(stat -c %u {ref})"')

    def unit_has(unit, *needles):
        text = machine.succeed(f"systemctl cat {unit}")
        for n in needles:
            if n not in text:
                raise Exception(f"{unit} missing {n!r}")

    def write_dns(ns):
        machine.succeed(f"printf 'nameserver {ns}\\n' > /run/tetrd-dns/resolv.conf")

    def wait_dns(ns, present=True):
        cmd = f"resolvconf -l tetrd | grep -q {ns}"
        if present:
            machine.wait_until_succeeds(cmd, timeout=DNS_TIMEOUT)
        else:
            machine.wait_until_fails(cmd, timeout=DNS_TIMEOUT)

    machine.wait_for_unit("multi-user.target")

    with subtest("package and lnsock"):
        for bin in ("tetrd", "tetrd-app", "tetrd-service"):
            machine.succeed(f"test -x /run/current-system/sw/bin/{bin}")
        machine.succeed("test -x /run/wrappers/bin/tetrd-lnsock")
        machine.succeed("getent group tetrd-usb")

        machine.succeed("mkdir -p /run/tetrd/run && touch /run/tetrd/run/tetrd.sock")
        machine.succeed("/run/wrappers/bin/tetrd-lnsock /run/tetrd-deadbeef.sock")
        machine.succeed("test -L /run/tetrd-deadbeef.sock")
        machine.succeed("test \"$(readlink /run/tetrd-deadbeef.sock)\" = /run/tetrd/run/tetrd.sock")
        for bad in (
            "/run/tetrd-NOTHEX00.sock",  # uppercase
            "/run/tetrd-abcd.sock",  # too short
            "/tmp/evil.sock",
            "/run/other.sock",
        ):
            machine.fail(f"/run/wrappers/bin/tetrd-lnsock {bad}")
        machine.fail(
            "/run/wrappers/bin/tetrd-lnsock /run/tetrd-"
            + ("a" * 65)
            + ".sock"
        )
        machine.succeed("ln -sfn /run/tetrd/run/tetrd.sock /run/tetrd-nothex.sock")
        machine.succeed("/run/wrappers/bin/tetrd-lnsock --cleanup")
        machine.fail("test -e /run/tetrd-deadbeef.sock")
        machine.succeed("test -L /run/tetrd-nothex.sock")
        machine.succeed("rm -f /run/tetrd-nothex.sock")

    with subtest("service layout"):
        start_tetrd()
        unit_has(
            "tetrd.service",
            "CAP_NET_ADMIN",
            "tetrd-usb",
            "DevicePolicy=closed",
            "DeviceAllow=char-usb_device",
            "DeviceAllow=/dev/net/tun",
            "/run/tetrd-dns/resolv.conf",
        )
        machine.fail("systemctl cat tetrd.service | grep -q CAP_DAC_OVERRIDE")
        machine.succeed("test -d /run/tetrd/run -a -d /run/tetrd/etc")
        machine.succeed("test -f /run/tetrd-dns/resolv.conf -a -f /run/tetrd/resolv.conf.state")
        machine.fail("readlink /etc/resolv.conf | grep -q /run/tetrd")
        machine.succeed("test -e /etc/resolv.conf")
        assert_owner("/run/tetrd-dns/resolv.conf", "/run/tetrd-dns")
        assert_owner("/run/tetrd/resolv.conf.state", "/run/tetrd")

    with subtest("dns units present"):
        machine.succeed("systemctl is-active --quiet tetrd-dns.path")
        machine.succeed("systemctl is-active --quiet tetrd-dns.service")
        unit_has("tetrd-dns.path", "PathModified=/run/tetrd-dns")
        unit_has("tetrd-dns-arm.service", "tetrd-dns-apply.timer")

    with subtest("resolvconf publish and clear"):
        write_dns("1.1.1.1")
        wait_dns("1.1.1.1")
        machine.succeed("grep -q 1.1.1.1 /etc/resolv.conf")
        machine.succeed(": > /run/tetrd-dns/resolv.conf")
        wait_dns("1.1.1.1", present=False)

    with subtest("apply oneshot"):
        write_dns("8.8.8.8")
        machine.systemctl("start tetrd-dns-apply.service")
        wait_dns("8.8.8.8")
        machine.succeed("grep -q 8.8.8.8 /etc/resolv.conf")

    with subtest("stop clears resolvconf stanza"):
        stop_tetrd()
        machine.fail("resolvconf -l tetrd | grep -q 8.8.8.8")

    with subtest("recreate missing resolv file keeps DNS watch"):
        start_tetrd()
        machine.wait_until_succeeds(
            "test -f /run/tetrd-dns/resolv.conf", timeout=DNS_TIMEOUT
        )
        machine.succeed("rm -f /run/tetrd-dns/resolv.conf")
        machine.wait_until_succeeds(
            "test -f /run/tetrd-dns/resolv.conf", timeout=DNS_TIMEOUT
        )
        assert_owner("/run/tetrd-dns/resolv.conf", "/run/tetrd-dns")
        write_dns("9.9.9.9")
        wait_dns("9.9.9.9")
        stop_tetrd()
  '';
}
