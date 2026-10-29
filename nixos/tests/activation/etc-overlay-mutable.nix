{ lib, ... }:
{

  name = "activation-etc-overlay-mutable";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes.machine =
    { pkgs, ... }:
    {
      system.etc.overlay.enable = true;
      system.etc.overlay.mutable = true;

      environment.etc = {
        modetest = {
          text = "foo";
          mode = "300";
        };
        modetest2 = {
          text = "foo";
          mode = "0300";
        };
      };

      # Prerequisites
      boot.initrd.systemd.enable = true;

      specialisation.new-generation.configuration = {
        environment.etc."newgen".text = "newgen";
        # Regression test for https://github.com/NixOS/nixpkgs/issues/505475:
        # A symlink in a subdirectory that does not exist in the base generation's
        # lowerdir. If something creates that subdirectory at runtime before
        # switching (e.g. stage-2-init.sh creating /etc/nixos), overlayfs makes it
        # opaque, hiding lowerdir content added by the new generation.
        environment.etc."nixos/newlink".source = pkgs.emptyDirectory;
      };
      specialisation.newer-generation.configuration = {
        environment.etc."newergen".text = "newergen";
      };
    };

  testScript = # python
    ''
      newergen = machine.succeed("realpath /run/current-system/specialisation/newer-generation/bin/switch-to-configuration").rstrip()

      with subtest("/run/nixos-etc-metadata/ is mounted"):
        print(machine.succeed("mountpoint /run/nixos-etc-metadata"))

      with subtest("No temporary files leaked into stage 2"):
        machine.succeed("[ ! -e /etc-metadata-image ]")
        machine.succeed("[ ! -e /etc-basedir ]")

      with subtest("/etc is mounted as an overlay"):
        machine.succeed("findmnt --kernel --type overlay /etc")

      with subtest("modes work correctly"):
        machine.succeed("stat --format '%F' /etc/modetest | tee /dev/stderr | grep -Eq '^regular file$'")
        machine.succeed("stat --format '%a' /etc/modetest | tee /dev/stderr | grep -Eq '^300$'")
        machine.succeed("stat --format '%F' /etc/modetest2 | tee /dev/stderr | grep -Eq '^regular file$'")
        machine.succeed("stat --format '%a' /etc/modetest2 | tee /dev/stderr | grep -Eq '^300$'")

      with subtest("/etc/nixos created by stage-2-init is opaque in upperdir"):
        # stage-2-init.sh unconditionally runs `install -d /etc/nixos`. Since
        # /nixos is not in the lowerdir, overlayfs creates it as an opaque dir
        # in the upperdir. Verify this precondition for the regression test below.
        machine.succeed("test -d /.rw-etc/upper/nixos")
        print(machine.succeed("getfattr -h -d -m 'trusted.overlay' /.rw-etc/upper/nixos 2>&1 || true"))

      with subtest("switching to the same generation"):
        machine.succeed("/run/current-system/bin/switch-to-configuration test")

      with subtest("the initrd didn't get rebuilt"):
        machine.succeed("test /run/current-system/initrd -ef /run/current-system/specialisation/new-generation/initrd")

      with subtest("switching to a new generation"):
        machine.fail("stat /etc/newgen")
        machine.succeed("echo -n 'mutable' > /etc/mutable")

        # Directory
        machine.succeed("mkdir /etc/mountpoint")
        machine.succeed("mount -t tmpfs tmpfs /etc/mountpoint")
        machine.succeed("touch /etc/mountpoint/extra-file")

        # File
        machine.succeed("touch /etc/filemount")
        machine.succeed("mount --bind /dev/null /etc/filemount")

        machine.succeed("/run/current-system/specialisation/new-generation/bin/switch-to-configuration switch")

        assert machine.succeed("cat /etc/newgen") == "newgen"
        assert machine.succeed("cat /etc/mutable") == "mutable"

        # Regression test for https://github.com/NixOS/nixpkgs/issues/505475:
        # The opaque /etc/nixos in the upperdir (created by stage-2-init.sh
        # before /nixos existed in the lowerdir) must not hide lowerdir entries
        # added by the new generation. The activation script must have cleared
        # the stale opaque marker.
        print(machine.succeed("ls -la /etc/nixos/"))
        machine.succeed("test -L /etc/nixos/newlink")
        machine.fail("getfattr -h -n trusted.overlay.opaque /.rw-etc/upper/nixos")

        print(machine.succeed("findmnt /etc/mountpoint"))
        print(machine.succeed("stat /etc/mountpoint/extra-file"))
        print(machine.succeed("findmnt /etc/filemount"))

        machine.succeed(f"{newergen} switch")
        assert machine.succeed("cat /etc/newergen") == "newergen"

        tmpMounts = machine.succeed("find /run -maxdepth 1 -type d -regex '/run/nixos-etc\\..*'").rstrip()
        print(tmpMounts)
        metaMounts = machine.succeed("find /run -maxdepth 1 -type d -regex '/run/nixos-etc-metadata.*'").rstrip()
        print(metaMounts)

        numOfTmpMounts = len(tmpMounts.splitlines())
        numOfMetaMounts = len(metaMounts.splitlines())
        assert numOfTmpMounts == 0, f"Found {numOfTmpMounts} remaining tmpmounts"
        assert numOfMetaMounts == 1, f"Found {numOfMetaMounts} remaining metamounts"

      with subtest("stale opaque markers are cleared by initrd on boot (NixOS/nixpkgs#505475)"):
        # Simulate the bug precondition: an opaque /pam.d in the upperdir.
        # /pam.d is guaranteed to exist as a directory in the metadata layer.
        machine.succeed("mkdir -p /.rw-etc/upper/pam.d")
        machine.succeed("setfattr -h -n trusted.overlay.opaque -v y /.rw-etc/upper/pam.d")
        machine.succeed("getfattr -h -n trusted.overlay.opaque /.rw-etc/upper/pam.d")
        # Also create a non-opaque upperdir directory that exists in the
        # metadata layer, to ensure clear-etc-opaque tolerates the
        # already-clear case.
        machine.succeed("mkdir -p /.rw-etc/upper/systemd")

        # Reboot and verify the initrd rw-etc service cleared the opaque marker.
        machine.shutdown()
        machine.start()
        machine.wait_for_unit("multi-user.target")
        machine.fail("getfattr -h -n trusted.overlay.opaque /.rw-etc/upper/pam.d")
        machine.succeed("test -e /etc/pam.d/login")
    '';
}
