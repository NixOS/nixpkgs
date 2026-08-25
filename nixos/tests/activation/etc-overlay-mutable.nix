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
        # Small regular file: inlined into the metadata erofs image.
        inlinetest = {
          text = "inline-content\n";
          mode = "0640";
        };
        # Empty regular file: served directly from the metadata erofs image
        # without payload or content.
        emptytest = {
          text = "";
          mode = "0644";
        };
        # Large regular file (>4096 bytes): served from the basedir data layer
        # via overlay redirect, not inlined.
        bigfile = {
          text = lib.strings.replicate 5000 "a";
          mode = "0644";
        };
      };

      systemd.services =
        let
          sleeper = "/run/current-system/sw/bin/sleep infinity";
        in
        {
          # The /etc copy gets a namespace-local child mount: umount
          # propagation is blocked, the service must be restarted.
          sandboxed = {
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              ExecStart = sleeper;
              PrivateMounts = true;
              BindReadOnlyPaths = [ "/etc/pam.d" ];
            };
          };
          # Plain slave namespace: receives the mount replacement via
          # propagation, must not be restarted.
          ns-slave = {
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              ExecStart = sleeper;
              PrivateMounts = true;
            };
          };
          # Explicitly opted out of receiving host mount changes. Must
          # neither see the new /etc nor be restarted.
          ns-private = {
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              ExecStart = sleeper;
              MountFlags = "private";
            };
          };
          # Stranded like `sandboxed`, but opted out of the restart.
          opted-out = {
            wantedBy = [ "multi-user.target" ];
            restartOnStaleEtc = false;
            serviceConfig = {
              ExecStart = sleeper;
              PrivateMounts = true;
              BindReadOnlyPaths = [ "/etc/pam.d" ];
            };
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

      with subtest("small regular files are inlined into the metadata image"):
        assert machine.succeed("cat /etc/inlinetest") == "inline-content\n"
        machine.succeed("stat --format '%a' /etc/inlinetest | tee /dev/stderr | grep -Eq '^640$'")
        # Inlined files are stored in the metadata erofs image, not redirected
        # to the basedir data layer, so they carry no overlay redirect xattr.
        machine.fail("getfattr -h -n trusted.overlay.redirect /run/nixos-etc-metadata/inlinetest")

      with subtest("empty regular files are served from the metadata image"):
        assert machine.succeed("cat /etc/emptytest") == ""
        machine.succeed("stat --format '%F %s %a' /etc/emptytest | tee /dev/stderr | grep -Eq '^regular empty file 0 644$'")
        machine.fail("getfattr -h -n trusted.overlay.redirect /run/nixos-etc-metadata/emptytest")

      with subtest("large regular files are served from the basedir"):
        assert machine.succeed("wc -c < /etc/bigfile").strip() == "5000"
        assert machine.succeed("head -c 10 /etc/bigfile") == "aaaaaaaaaa"
        machine.succeed("getfattr -h -n trusted.overlay.redirect /run/nixos-etc-metadata/bigfile")

      def main_pid(service_name):
          return machine.succeed(f"systemctl show -P MainPID {service_name}.service").strip()

      with subtest("switching to the same generation"):
        machine.succeed("/run/current-system/bin/switch-to-configuration test")

      # The switch above already replaced the /etc mount once. Capture the
      # main PIDs now so that we can use them later in our assertions.
      pids = {service: main_pid(service) for service in ["sandboxed", "ns-slave", "ns-private", "opted-out"]}

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

      with subtest("stranded mount namespaces are restarted, propagated ones are not"):
        # The namespace-local bind mount under /etc blocked the umount
        # propagation. The unit kept the old /etc and must have been
        # restarted by the switch.
        assert main_pid("sandboxed") != pids["sandboxed"], "sandboxed was not restarted"
        pid = main_pid("sandboxed")
        assert machine.succeed(f"nsenter -t {pid} -m cat /etc/newgen") == "newgen"

        # The plain slave namespace received the mount replacement via
        # propagation, so restarting it would be gratuitous.
        assert main_pid("ns-slave") == pids["ns-slave"], "ns-slave was restarted"
        assert machine.succeed(f"nsenter -t {pids['ns-slave']} -m cat /etc/newgen") == "newgen"

        # MountFlags=private opted out of host mount changes: not
        # restarted, still on the old /etc.
        assert main_pid("ns-private") == pids["ns-private"], "ns-private was restarted"
        machine.fail(f"nsenter -t {pids['ns-private']} -m test -e /etc/newgen")

        # Stranded, but restartOnStaleEtc = false must be honored.
        assert main_pid("opted-out") == pids["opted-out"], "opted-out was restarted"
        machine.fail(f"nsenter -t {pids['opted-out']} -m test -e /etc/newgen")

      with subtest("switching to yet another generation"):
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
