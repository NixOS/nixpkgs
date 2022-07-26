import ./make-test-python.nix ({ pkgs, ... }: {
  name = "systemd";

  nodes.machine = { lib, ... }: {
    imports = [ common/user-account.nix common/x11.nix ];

    virtualisation.emptyDiskImages = [ 512 512 ];

    environment.systemPackages = [ pkgs.cryptsetup ];

    virtualisation.fileSystems = {
      "/test-x-initrd-mount" = {
        device = "/dev/vdb";
        fsType = "ext2";
        autoFormat = true;
        noCheck = true;
        options = [ "x-initrd.mount" ];
      };
    };

    systemd.extraConfig = "DefaultEnvironment=\"XXX_SYSTEM=foo\"";
    systemd.user.extraConfig = "DefaultEnvironment=\"XXX_USER=bar\"";
    services.journald.extraConfig = "Storage=volatile";
    test-support.displayManager.auto.user = "alice";

    systemd.shutdown.test = pkgs.writeScript "test.shutdown" ''
      #!${pkgs.runtimeShell}
      PATH=${lib.makeBinPath (with pkgs; [ util-linux coreutils ])}
      mount -t 9p shared -o trans=virtio,version=9p2000.L /tmp/shared
      touch /tmp/shared/shutdown-test
      umount /tmp/shared
    '';

    systemd.services.oncalendar-test = {
      description = "calendar test";
      # Japan does not have DST which makes the test a little bit simpler
      startAt = "Wed 10:00 Asia/Tokyo";
      script = "true";
    };

    systemd.services.testservice1 = {
      description = "Test Service 1";
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "oneshot";
      script = ''
        if [ "$XXX_SYSTEM" = foo ]; then
          touch /system_conf_read
        fi
      '';
    };

    systemd.user.services.testservice2 = {
      description = "Test Service 2";
      wantedBy = [ "default.target" ];
      serviceConfig.Type = "oneshot";
      script = ''
        if [ "$XXX_USER" = bar ]; then
          touch "$HOME/user_conf_read"
        fi
      '';
    };

    systemd.watchdog = {
      device = "/dev/watchdog";
      runtimeTime = "30s";
      rebootTime = "10min";
      kexecTime = "5min";
    };
  };

  testScript = ''
    import re
    import subprocess

    machine.wait_for_x()
    # wait for user services
    machine.wait_for_unit("default.target", "alice")

    # Regression test for https://github.com/NixOS/nixpkgs/issues/105049
    with subtest("systemd reads timezone database in /etc/zoneinfo"):
        timer = machine.succeed("TZ=UTC systemctl show --property=TimersCalendar oncalendar-test.timer")
        assert re.search("next_elapse=Wed ....-..-.. 01:00:00 UTC", timer), f"got {timer.strip()}"

    # Regression test for https://github.com/NixOS/nixpkgs/issues/35415
    with subtest("configuration files are recognized by systemd"):
        machine.succeed("test -e /system_conf_read")
        machine.succeed("test -e /home/alice/user_conf_read")
        machine.succeed("test -z $(ls -1 /var/log/journal)")

    # Regression test for https://github.com/NixOS/nixpkgs/issues/50273
    with subtest("DynamicUser actually allocates a user"):
        assert "iamatest" in machine.succeed(
            "systemd-run --pty --property=Type=oneshot --property=DynamicUser=yes --property=User=iamatest whoami"
        )

    with subtest("regression test for https://bugs.freedesktop.org/show_bug.cgi?id=77507"):
        retcode, output = machine.execute("systemctl status testservice1.service")
        assert retcode in [0, 3]  # https://bugs.freedesktop.org/show_bug.cgi?id=77507

    # Regression test for https://github.com/NixOS/nixpkgs/issues/35268
    with subtest("file system with x-initrd.mount is not unmounted"):
        machine.succeed("mountpoint -q /test-x-initrd-mount")
        machine.shutdown()

        subprocess.check_call(
            [
                "qemu-img",
                "convert",
                "-O",
                "raw",
                "vm-state-machine/empty0.qcow2",
                "x-initrd-mount.raw",
            ]
        )
        extinfo = subprocess.check_output(
            [
                "${pkgs.e2fsprogs}/bin/dumpe2fs",
                "x-initrd-mount.raw",
            ]
        ).decode("utf-8")
        assert (
            re.search(r"^Filesystem state: *clean$", extinfo, re.MULTILINE) is not None
        ), ("File system was not cleanly unmounted: " + extinfo)

    # Regression test for https://github.com/NixOS/nixpkgs/pull/91232
    with subtest("setting transient hostnames works"):
        machine.succeed("hostnamectl set-hostname --transient machine-transient")
        machine.fail("hostnamectl set-hostname machine-all")

    with subtest("systemd-shutdown works"):
        machine.shutdown()
        machine.wait_for_unit("multi-user.target")
        machine.succeed("test -e /tmp/shared/shutdown-test")

    # Test settings from /etc/sysctl.d/50-default.conf are applied
    with subtest("systemd sysctl settings are applied"):
        machine.wait_for_unit("multi-user.target")
        assert "fq_codel" in machine.succeed("sysctl net.core.default_qdisc")

    # Test systemd is configured to manage a watchdog
    with subtest("systemd manages hardware watchdog"):
        machine.wait_for_unit("multi-user.target")

        # It seems that the device's path doesn't appear in 'systemctl show' so
        # check it separately.
        assert "WatchdogDevice=/dev/watchdog" in machine.succeed(
            "cat /etc/systemd/system.conf"
        )

        output = machine.succeed("systemctl show | grep Watchdog")
        # assert "RuntimeWatchdogUSec=30s" in output
        # for some reason RuntimeWatchdogUSec, doesn't seem to be updated in here.
        assert "RebootWatchdogUSec=10min" in output
        assert "KExecWatchdogUSec=5min" in output

    # Test systemd cryptsetup support
    with subtest("systemd successfully reads /etc/crypttab and unlocks volumes"):
        # create a luks volume and put a filesystem on it
        machine.succeed(
            "echo -n supersecret | cryptsetup luksFormat -q /dev/vdc -",
            "echo -n supersecret | cryptsetup luksOpen --key-file - /dev/vdc foo",
            "mkfs.ext3 /dev/mapper/foo",
        )

        # create a keyfile and /etc/crypttab
        machine.succeed("echo -n supersecret > /var/lib/luks-keyfile")
        machine.succeed("chmod 600 /var/lib/luks-keyfile")
        machine.succeed("echo 'luks1 /dev/vdc /var/lib/luks-keyfile luks' > /etc/crypttab")

        # after a reboot, systemd should unlock the volume and we should be able to mount it
        machine.shutdown()
        machine.succeed("systemctl status systemd-cryptsetup@luks1.service")
        machine.succeed("mkdir -p /tmp/luks1")
        machine.succeed("mount /dev/mapper/luks1 /tmp/luks1")

    # Do some IP traffic
    output_ping = machine.succeed(
        "systemd-run --wait -- /run/wrappers/bin/ping -c 1 127.0.0.1 2>&1"
    )

    with subtest("systemd reports accounting data on system.slice"):
        output = machine.succeed("systemctl status system.slice")
        assert "CPU:" in output
        assert "Memory:" in output

        assert "IP:" in output
        assert "0B in, 0B out" not in output

        assert "IO:" in output
        assert "0B read, 0B written" not in output

    with subtest("systemd per-unit accounting works"):
        assert "IP traffic received: 84B" in output_ping
        assert "IP traffic sent: 84B" in output_ping

    with subtest("systemd environment is properly set"):
        machine.systemctl("daemon-reexec")  # Rewrites /proc/1/environ
        machine.succeed("grep -q TZDIR=/etc/zoneinfo /proc/1/environ")
  '';
})
