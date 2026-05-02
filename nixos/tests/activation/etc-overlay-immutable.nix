{ lib, ... }:
{

  name = "activation-etc-overlay-immutable";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes.machine =
    { pkgs, ... }:
    {
      system.etc.overlay.enable = true;
      system.etc.overlay.mutable = false;

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

      # Prerequisites
      systemd.sysusers.enable = true;
      users.mutableUsers = false;
      boot.initrd.systemd.enable = true;
      time.timeZone = "Utc";

      # The standard resolvconf service tries to write to /etc and crashes,
      # which makes nixos-rebuild exit uncleanly when switching into the new generation
      services.resolved.enable = true;

      environment.etc = {
        "mountpoint/.keep".text = "keep";
        "filemount".text = "keep";
      };

      specialisation.new-generation.configuration = {
        environment.etc."newgen".text = "newgen";
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
        machine.succeed("stat --format '%F' /etc/modetest | tee /dev/stderr | grep -q 'regular file'")
        machine.succeed("stat --format '%F' /etc/modetest2 | tee /dev/stderr | grep -q 'regular file'")

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

      with subtest("direct symlinks point to the target without indirection"):
        assert machine.succeed("readlink -n /etc/localtime") == "/etc/zoneinfo/Utc"

      with subtest("/etc/mtab points to the right file"):
        assert "/proc/mounts" == machine.succeed("readlink --no-newline /etc/mtab")

      with subtest("Correct mode on the source password files"):
        assert machine.succeed("stat -c '%a' /var/lib/nixos/etc/passwd") == "644\n"
        assert machine.succeed("stat -c '%a' /var/lib/nixos/etc/group") == "644\n"
        assert machine.succeed("stat -c '%a' /var/lib/nixos/etc/shadow") == "0\n"
        assert machine.succeed("stat -c '%a' /var/lib/nixos/etc/gshadow") == "0\n"

      with subtest("Password files are symlinks to /var/lib/nixos/etc"):
        assert machine.succeed("readlink -f /etc/passwd") == "/var/lib/nixos/etc/passwd\n"
        assert machine.succeed("readlink -f /etc/group") == "/var/lib/nixos/etc/group\n"
        assert machine.succeed("readlink -f /etc/shadow") == "/var/lib/nixos/etc/shadow\n"
        assert machine.succeed("readlink -f /etc/gshadow") == "/var/lib/nixos/etc/gshadow\n"

      with subtest("switching to the same generation"):
        machine.succeed("/run/current-system/bin/switch-to-configuration test")

      with subtest("the initrd didn't get rebuilt"):
        machine.succeed("test /run/current-system/initrd -ef /run/current-system/specialisation/new-generation/initrd")

      with subtest("switching to a new generation"):
        machine.fail("stat /etc/newgen")

        machine.succeed("mount -t tmpfs tmpfs /etc/mountpoint")
        machine.succeed("touch /etc/mountpoint/extra-file")
        machine.succeed("mount --bind /dev/null /etc/filemount")

        machine.succeed("/run/current-system/specialisation/new-generation/bin/switch-to-configuration switch")

        assert machine.succeed("cat /etc/newgen") == "newgen"

        print(machine.succeed("findmnt /etc/mountpoint"))
        print(machine.succeed("ls /etc/mountpoint"))
        print(machine.succeed("stat /etc/mountpoint/extra-file"))
        print(machine.succeed("findmnt /etc/filemount"))

        machine.succeed(f"{newergen} switch")

        tmpMounts = machine.succeed("find /run -maxdepth 1 -type d -regex '/run/nixos-etc\\..*'").rstrip()
        print(tmpMounts)
        metaMounts = machine.succeed("find /run -maxdepth 1 -type d -regex '/run/nixos-etc-metadata.*'").rstrip()
        print(metaMounts)

        numOfTmpMounts = len(tmpMounts.splitlines())
        numOfMetaMounts = len(metaMounts.splitlines())
        assert numOfTmpMounts == 0, f"Found {numOfTmpMounts} remaining tmpmounts"
        assert numOfMetaMounts == 1, f"Found {numOfMetaMounts} remaining metamounts"
    '';
}
