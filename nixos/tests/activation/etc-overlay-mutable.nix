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
        # Bake a directory into the lowerdir so a tmpfs can be mounted on
        # top and transfer_submounts has to walk into it on switch.
        "dirmount/.keep".text = "";
        # Bake a regular file into the lowerdir so a file bind can land on
        # it without resolve_mountpoint copying it up into the upperdir.
        lowerfilemount = {
          text = "";
          mode = "0644";
        };
        # https://github.com/NixOS/nixpkgs/pull/507963
        "managed-subdir/managed-link".source = pkgs.emptyDirectory;
        "managed-subdir/replaced-link".source = pkgs.emptyDirectory;
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

      # The default writable store (overlayfs) does not support file-backed
      # erofs. nix.enable=false because nix-daemon-init chowns the 9p store.
      virtualisation.writableStore = false;
      nix.enable = false;

      specialisation.new-generation.configuration = {
        environment.etc."newgen".text = "newgen";
        # https://github.com/NixOS/nixpkgs/issues/505475
        environment.etc."nixos/newlink".source = pkgs.emptyDirectory;
      };
      specialisation.newer-generation.configuration = {
        environment.etc."newergen".text = "newergen";
      };
    };

  testScript = # python
    ''
      newergen = machine.succeed("realpath /run/current-system/specialisation/newer-generation/bin/switch-to-configuration").rstrip()

      with subtest("/etc is mounted as an overlay"):
        machine.succeed("findmnt --kernel --type overlay /etc")

      with subtest("file-backed erofs fast path was used in initrd"):
        machine.fail("journalctl -b -o cat | grep -F 'falling back to a loop device'")
        machine.fail("losetup --noheadings | grep etc-metadata")

      with subtest("modes work correctly"):
        machine.succeed("stat --format '%F' /etc/modetest | tee /dev/stderr | grep -Eq '^regular file$'")
        machine.succeed("stat --format '%a' /etc/modetest | tee /dev/stderr | grep -Eq '^300$'")
        machine.succeed("stat --format '%F' /etc/modetest2 | tee /dev/stderr | grep -Eq '^regular file$'")
        machine.succeed("stat --format '%a' /etc/modetest2 | tee /dev/stderr | grep -Eq '^300$'")

      with subtest("/etc/nixos created by stage-2-init is opaque in upperdir"):
        # stage-2-init runs `install -d /etc/nixos`; /nixos is not in the
        # lowerdir so overlayfs makes it opaque (precondition for #505475).
        machine.succeed("test -d /.rw-etc/upper/nixos")
        print(machine.succeed("getfattr -h -d -m 'trusted.overlay' /.rw-etc/upper/nixos 2>&1 || true"))

      with subtest("switching to the same generation"):
        machine.succeed("/run/current-system/bin/switch-to-configuration test")

      with subtest("the initrd didn't get rebuilt"):
        machine.succeed("test /run/current-system/initrd -ef /run/current-system/specialisation/new-generation/initrd")

      with subtest("switching to a new generation"):
        machine.fail("stat /etc/newgen")
        machine.succeed("echo -n 'mutable' > /etc/mutable")

        # #507963: whiteout must be removed on switch.
        machine.succeed("rm /etc/managed-subdir/managed-link")
        machine.succeed("test -c /.rw-etc/upper/managed-subdir/managed-link")

        # Directory submount, target only in upperdir.
        machine.succeed("mkdir /etc/mountpoint")
        machine.succeed("mount -t tmpfs tmpfs /etc/mountpoint")
        machine.succeed("touch /etc/mountpoint/extra-file")

        # Directory submount, target only in lowerdir.
        machine.succeed("mount -t tmpfs tmpfs /etc/dirmount")
        machine.succeed("touch /etc/dirmount/extra-file")

        # File submount, target only in upperdir.
        machine.succeed("touch /etc/filemount")
        machine.succeed("mount --bind /dev/null /etc/filemount")

        # File submount, target only in lowerdir.
        machine.succeed("mount --bind /dev/null /etc/lowerfilemount")
        machine.fail("test -e /.rw-etc/upper/lowerfilemount")

        # systemd's RestrictSUIDSGID= seccomp filter blanket-blocks openat2
        # with ENOSYS (it cannot inspect struct open_how). Run the switch
        # under it so transfer_submounts is exercised without openat2.
        machine.succeed(
            "systemd-run --wait --collect --pipe -p RestrictSUIDSGID=yes -- "
            "/run/current-system/specialisation/new-generation/bin/switch-to-configuration switch"
        )

        assert machine.succeed("cat /etc/newgen") == "newgen"
        assert machine.succeed("cat /etc/mutable") == "mutable"
        machine.succeed("test -L /etc/managed-subdir/managed-link")
        machine.fail("test -e /.rw-etc/upper/managed-subdir/managed-link")

        # #505475: opaque marker must be cleared on switch.
        print(machine.succeed("ls -la /etc/nixos/"))
        machine.succeed("test -L /etc/nixos/newlink")
        machine.fail("getfattr -h -n trusted.overlay.opaque /.rw-etc/upper/nixos")

        print(machine.succeed("findmnt /etc/mountpoint"))
        print(machine.succeed("stat /etc/mountpoint/extra-file"))
        print(machine.succeed("findmnt /etc/dirmount"))
        print(machine.succeed("stat /etc/dirmount/extra-file"))
        machine.fail("test -e /.rw-etc/upper/dirmount")
        print(machine.succeed("findmnt /etc/filemount"))
        print(machine.succeed("findmnt /etc/lowerfilemount"))
        # The lowerdir-only target must not have been copied up.
        machine.fail("test -e /.rw-etc/upper/lowerfilemount")

        machine.succeed(f"{newergen} switch")
        assert machine.succeed("cat /etc/newergen") == "newergen"

        leftovers = machine.succeed("find /run -maxdepth 1 -type d -regex '/run/nixos-etc.*'").rstrip()
        assert leftovers == "", f"Found leftover mounts under /run: {leftovers}"

      with subtest("upperdir is reconciled against the metadata layer on boot (NixOS/nixpkgs#507963)"):
        machine.succeed("test -L /etc/managed-subdir/managed-link")
        machine.succeed("test -L /etc/managed-subdir/replaced-link")

        # 1. Delete a managed symlink -> whiteout in upperdir.
        machine.succeed("rm /etc/managed-subdir/managed-link")
        machine.succeed("test -c /.rw-etc/upper/managed-subdir/managed-link")
        machine.fail("test -e /etc/managed-subdir/managed-link")

        # 2. Replace a managed symlink with a regular file -> copy in upperdir.
        machine.succeed("rm /etc/managed-subdir/replaced-link")
        machine.succeed("echo -n mine > /etc/managed-subdir/replaced-link")
        machine.succeed("test -f /.rw-etc/upper/managed-subdir/replaced-link")
        assert machine.succeed("cat /etc/managed-subdir/replaced-link") == "mine"

        # 3. Unmanaged files (no lowerdir counterpart) must survive.
        machine.succeed("echo -n keep > /etc/managed-subdir/user-file")
        machine.succeed("echo -n keep > /etc/unmanaged-file")

        # 4. Stale overlay xattrs on a managed directory must be cleared
        #    (#505475). redirect/origin are relative to the old lowerdir.
        machine.succeed("mkdir -p /.rw-etc/upper/pam.d")
        machine.succeed("setfattr -h -n trusted.overlay.opaque -v y /.rw-etc/upper/pam.d")
        machine.succeed("setfattr -h -n trusted.overlay.redirect -v /elsewhere /.rw-etc/upper/pam.d")
        machine.succeed("getfattr -h -n trusted.overlay.opaque /.rw-etc/upper/pam.d")

        print(machine.succeed("ls -la /.rw-etc/upper/managed-subdir/"))

        machine.succeed("sync")
        machine.crash()
        machine.start()
        machine.wait_for_unit("multi-user.target")

        print(machine.succeed("ls -la /etc/managed-subdir/ /.rw-etc/upper/managed-subdir/"))

        machine.succeed("test -L /etc/managed-subdir/managed-link")
        machine.fail("test -e /.rw-etc/upper/managed-subdir/managed-link")
        machine.succeed("test -L /etc/managed-subdir/replaced-link")
        machine.fail("test -e /.rw-etc/upper/managed-subdir/replaced-link")

        machine.fail("getfattr -h -n trusted.overlay.opaque /.rw-etc/upper/pam.d")
        machine.fail("getfattr -h -n trusted.overlay.redirect /.rw-etc/upper/pam.d")
        machine.succeed("test -e /etc/pam.d/login")

        assert machine.succeed("cat /etc/managed-subdir/user-file") == "keep"
        assert machine.succeed("cat /etc/unmanaged-file") == "keep"
    '';
}
