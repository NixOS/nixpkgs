import ./make-test.nix {
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

    # Regression test for https://github.com/NixOS/nixpkgs/issues/35415
    subtest "configuration files are recognized by systemd", sub {
      $machine->succeed('test -e /system_conf_read');
      $machine->succeed('test -e /home/alice/user_conf_read');
      $machine->succeed('test -z $(ls -1 /var/log/journal)');
    };

    # Regression test for https://github.com/NixOS/nixpkgs/issues/35268
    subtest "file system with x-initrd.mount is not unmounted", sub {
      $machine->shutdown;
      $machine->waitForUnit('multi-user.target');
      # If the file system was unmounted during the shutdown the file system
      # has a last mount time, because the file system wasn't checked.
      $machine->fail('dumpe2fs /dev/vdb | grep -q "^Last mount time: *n/a"');
    };
  '';
}
