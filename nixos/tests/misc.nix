# Miscellaneous small tests that don't warrant their own VM run.

import ./make-test-python.nix ({ pkgs, ...} : rec {
  name = "misc";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco ];
  };

  foo = pkgs.writeText "foo" "Hello World";

  machine =
    { lib, ... }:
    with lib;
    { swapDevices = mkOverride 0
        [ { device = "/root/swapfile"; size = 128; } ];
      environment.variables.EDITOR = mkOverride 0 "emacs";
      documentation.nixos.enable = mkOverride 0 true;
      systemd.tmpfiles.rules = [ "d /tmp 1777 root root 10d" ];
      fileSystems = mkVMOverride { "/tmp2" =
        { fsType = "tmpfs";
          options = [ "mode=1777" "noauto" ];
        };
      };
      systemd.automounts = singleton
        { wantedBy = [ "multi-user.target" ];
          where = "/tmp2";
        };
      users.users.sybil = { isNormalUser = true; group = "wheel"; };
      security.sudo = { enable = true; wheelNeedsPassword = false; };
      boot.kernel.sysctl."vm.swappiness" = 1;
      boot.kernelParams = [ "vsyscall=emulate" ];
      system.extraDependencies = [ foo ];
    };

  testScript =
    ''
      import json


      def get_path_info(path):
          result = machine.succeed(f"nix path-info --json {path}")
          parsed = json.loads(result)
          return parsed


      with subtest("nix-db"):
          info = get_path_info("${foo}")

          if (
              info[0]["narHash"]
              != "sha256:0afw0d9j1hvwiz066z93jiddc33nxg6i6qyp26vnqyglpyfivlq5"
          ):
              raise Exception("narHash not set")

          if info[0]["narSize"] != 128:
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

      with subtest("whether the blkio controller is properly enabled"):
          machine.succeed("[ -e /sys/fs/cgroup/blkio/blkio.reset_stats ]")

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

      with subtest("whether automounting works"):
          machine.fail("grep '/tmp2 tmpfs' /proc/mounts")
          machine.succeed("touch /tmp2/x")
          machine.succeed("grep '/tmp2 tmpfs' /proc/mounts")

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
})
