# Miscellaneous small tests that don't warrant their own VM run.
{ pkgs, ... }:

let
  inherit (pkgs) lib;
  tests = {
    default = testsForPackage { nixPackage = pkgs.nix; };
    lix = testsForPackage { nixPackage = pkgs.lix; };
  };

  testsForPackage = args: lib.recurseIntoAttrs {
    # If the attribute is not named 'test'
    # You will break all the universe on the release-*.nix side of things.
    # `discoverTests` relies on `test` existence to perform a `callTest`.
    test = testMiscFeatures args;
    passthru.override = args': testsForPackage (args // args');
  };

  testMiscFeatures = { nixPackage, ... }: pkgs.testers.nixosTest (
  let
    foo = pkgs.writeText "foo" "Hello World";
  in {
    name = "misc";
    meta.maintainers = with lib.maintainers; [ raitobezarius ];

    nodes.machine =
      { lib, ... }:
      { swapDevices = lib.mkOverride 0
          [ { device = "/root/swapfile"; size = 128; } ];
        environment.variables.EDITOR = lib.mkOverride 0 "emacs";
        documentation.nixos.enable = lib.mkOverride 0 true;
        systemd.tmpfiles.rules = [ "d /tmp 1777 root root 10d" ];
        systemd.tmpfiles.settings."10-test"."/tmp/somefile".d = {};
        virtualisation.fileSystems = { "/tmp2" =
          { fsType = "tmpfs";
            options = [ "mode=1777" "noauto" ];
          };
          # Tests https://discourse.nixos.org/t/how-to-make-a-derivations-executables-have-the-s-permission/8555
          "/user-mount/point" = {
            device = "/user-mount/source";
            fsType = "none";
            options = [ "bind" "rw" "user" "noauto" ];
          };
          "/user-mount/denied-point" = {
            device = "/user-mount/denied-source";
            fsType = "none";
            options = [ "bind" "rw" "noauto" ];
          };
        };
        systemd.automounts = lib.singleton
          { wantedBy = [ "multi-user.target" ];
            where = "/tmp2";
          };
        users.users.sybil = { isNormalUser = true; group = "wheel"; };
        users.users.alice = { isNormalUser = true; };
        security.sudo = { enable = true; wheelNeedsPassword = false; };
        boot.kernel.sysctl."vm.swappiness" = 1;
        boot.kernelParams = [ "vsyscall=emulate" ];
        system.extraDependencies = [ foo ];

        nix.package = nixPackage;
      };

    testScript =
      ''
        import json


        def get_path_info(path):
            result = machine.succeed(f"nix --option experimental-features nix-command path-info --json {path}")
            parsed = json.loads(result)
            return parsed


        with subtest("nix-db"):
            out = "${foo}"
            info = get_path_info(out)
            print(info)

            pathinfo = info[0] if isinstance(info, list) else info[out]

            if (
                pathinfo["narHash"]
                != "sha256-BdMdnb/0eWy3EddjE83rdgzWWpQjfWPAj3zDIFMD3Ck="
            ):
                raise Exception("narHash not set")

            if pathinfo["narSize"] != 128:
                raise Exception("narSize not set")

        with subtest("nixos-version"):
            machine.succeed("[ `nixos-version | wc -w` = 2 ]")

        with subtest("nixos-rebuild"):
            assert "NixOS module" in machine.succeed("nixos-rebuild --help")

        with subtest("Sanity check for uid/gid assignment"):
            assert "4" == machine.succeed("id -u messagebus").strip()
            assert "4" == machine.succeed("id -g messagebus").strip()
            assert "users:x:100:" == machine.succeed("getent group users").strip()

        with subtest("Regression test for GMP aborts on QEMU."):
            machine.succeed("expr 1 + 2")

        with subtest("the swap file got created"):
            machine.wait_for_unit("root-swapfile.swap")
            machine.succeed("ls -l /root/swapfile | grep 134217728")

        with subtest("whether kernel.poweroff_cmd is set"):
            machine.succeed('[ -x "$(cat /proc/sys/kernel/poweroff_cmd)" ]')

        with subtest("whether the io cgroupv2 controller is properly enabled"):
            machine.succeed("grep -q '\\bio\\b' /sys/fs/cgroup/cgroup.controllers")

        with subtest("whether we have a reboot record in wtmp"):
            machine.shutdown
            machine.wait_for_unit("multi-user.target")
            machine.succeed("last | grep reboot >&2")

        with subtest("whether we can override environment variables"):
            machine.succeed('[ "$EDITOR" = emacs ]')

        with subtest("whether hostname (and by extension nss_myhostname) works"):
            assert "machine" == machine.succeed("hostname").strip()
            assert "machine" == machine.succeed("hostname -s").strip()

        with subtest("whether systemd-udevd automatically loads modules for our hardware"):
            machine.succeed("systemctl start systemd-udev-settle.service")
            machine.wait_for_unit("systemd-udev-settle.service")
            assert "mousedev" in machine.succeed("lsmod")

        with subtest("whether systemd-tmpfiles-clean works"):
            machine.succeed(
                "touch /tmp/foo", "systemctl start systemd-tmpfiles-clean", "[ -e /tmp/foo ]"
            )
            # move into the future
            machine.succeed(
                'date -s "@$(($(date +%s) + 1000000))"',
                "systemctl start systemd-tmpfiles-clean",
            )
            machine.fail("[ -e /tmp/foo ]")

        with subtest("whether systemd-tmpfiles settings works"):
            machine.succeed("[ -e /tmp/somefile ]")

        with subtest("whether automounting works"):
            machine.fail("grep '/tmp2 tmpfs' /proc/mounts")
            machine.succeed("touch /tmp2/x")
            machine.succeed("grep '/tmp2 tmpfs' /proc/mounts")

        with subtest(
            "Whether mounting by a user is possible with the `user` option in fstab (#95444)"
        ):
            machine.succeed("mkdir -p /user-mount/source")
            machine.succeed("touch /user-mount/source/file")
            machine.succeed("chmod -R a+Xr /user-mount/source")
            machine.succeed("mkdir /user-mount/point")
            machine.succeed("chown alice:users /user-mount/point")
            machine.succeed("su - alice -c 'mount /user-mount/point'")
            machine.succeed("su - alice -c 'ls /user-mount/point/file'")
        with subtest(
            "Whether mounting by a user is denied without the `user` option in  fstab"
        ):
            machine.succeed("mkdir -p /user-mount/denied-source")
            machine.succeed("touch /user-mount/denied-source/file")
            machine.succeed("chmod -R a+Xr /user-mount/denied-source")
            machine.succeed("mkdir /user-mount/denied-point")
            machine.succeed("chown alice:users /user-mount/denied-point")
            machine.fail("su - alice -c 'mount /user-mount/denied-point'")

        with subtest("shell-vars"):
            machine.succeed('[ -n "$NIX_PATH" ]')

        with subtest("nix-db"):
            machine.succeed("nix-store -qR /run/current-system | grep nixos-")

        with subtest("Test sysctl"):
            machine.wait_for_unit("systemd-sysctl.service")
            assert "1" == machine.succeed("sysctl -ne vm.swappiness").strip()
            machine.execute("sysctl vm.swappiness=60")
            assert "60" == machine.succeed("sysctl -ne vm.swappiness").strip()

        with subtest("Test boot parameters"):
            assert "vsyscall=emulate" in machine.succeed("cat /proc/cmdline")
      '';
  });
  in
  tests
