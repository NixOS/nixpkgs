import ./make-test.nix ({ pkgs, ... }: {
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
    services.xserver.displayManager.auto.user = "alice";

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
    $machine->waitForX;
    # wait for user services
    $machine->waitForUnit("default.target","alice");

    # Regression test for https://github.com/NixOS/nixpkgs/issues/35415
    subtest "configuration files are recognized by systemd", sub {
      $machine->succeed('test -e /system_conf_read');
      $machine->succeed('test -e /home/alice/user_conf_read');
      $machine->succeed('test -z $(ls -1 /var/log/journal)');
    };

    # Regression test for https://github.com/NixOS/nixpkgs/issues/50273
    subtest "DynamicUser actually allocates a user", sub {
        $machine->succeed('systemd-run --pty --property=Type=oneshot --property=DynamicUser=yes --property=User=iamatest whoami | grep iamatest');
    };

    # Regression test for https://github.com/NixOS/nixpkgs/issues/35268
    subtest "file system with x-initrd.mount is not unmounted", sub {
      $machine->succeed('mountpoint -q /test-x-initrd-mount');
      $machine->shutdown;
      system('qemu-img', 'convert', '-O', 'raw',
             'vm-state-machine/empty2.qcow2', 'x-initrd-mount.raw');
      my $extinfo = `${pkgs.e2fsprogs}/bin/dumpe2fs x-initrd-mount.raw`;
      die "File system was not cleanly unmounted: $extinfo"
        unless $extinfo =~ /^Filesystem state: *clean$/m;
    };

    subtest "systemd-shutdown works", sub {
      $machine->shutdown;
      $machine->waitForUnit('multi-user.target');
      $machine->succeed('test -e /tmp/shared/shutdown-test');
    };

   # Test settings from /etc/sysctl.d/50-default.conf are applied
   subtest "systemd sysctl settings are applied", sub {
     $machine->waitForUnit('multi-user.target');
     $machine->succeed('sysctl net.core.default_qdisc | grep -q "fq_codel"');
   };

   # Test cgroup accounting is enabled
   subtest "systemd cgroup accounting is enabled", sub {
     $machine->waitForUnit('multi-user.target');
     $machine->succeed('systemctl show testservice1.service -p IOAccounting | grep -q "yes"');
     $machine->succeed('systemctl status testservice1.service | grep -q "CPU:"');
   };
  '';
})
