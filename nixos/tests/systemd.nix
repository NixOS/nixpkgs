import ./make-test-python.nix ({ pkgs, ... }: {
  name = "systemd";

  machine = { lib, ... }: {
    imports = [ common/user-account.nix common/x11.nix ];

    virtualisation.emptyDiskImages = [ 512 ];

    fileSystems = lib.mkVMOverride {
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
      #!${pkgs.stdenv.shell}
      PATH=${lib.makeBinPath (with pkgs; [ utillinux coreutils ])}
      mount -t 9p shared -o trans=virtio,version=9p2000.L /tmp/shared
      touch /tmp/shared/shutdown-test
      umount /tmp/shared
    '';

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
  };

  testScript = ''
    import re
    import subprocess

    machine.wait_for_x()
    # wait for user services
    machine.wait_for_unit("default.target", "alice")

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

    with subtest("systemd-shutdown works"):
        machine.shutdown()
        machine.wait_for_unit("multi-user.target")
        machine.succeed("test -e /tmp/shared/shutdown-test")

    # Test settings from /etc/sysctl.d/50-default.conf are applied
    with subtest("systemd sysctl settings are applied"):
        machine.wait_for_unit("multi-user.target")
        assert "fq_codel" in machine.succeed("sysctl net.core.default_qdisc")

    # Test cgroup accounting is enabled
    with subtest("systemd cgroup accounting is enabled"):
        machine.wait_for_unit("multi-user.target")
        assert "yes" in machine.succeed(
            "systemctl show testservice1.service -p IOAccounting"
        )

        retcode, output = machine.execute("systemctl status testservice1.service")
        assert retcode in [0, 3]  # https://bugs.freedesktop.org/show_bug.cgi?id=77507
        assert "CPU:" in output
  '';
})
