import ./make-test-python.nix (
  { pkgs, ... }:
  let
    userUid = 1000;
    usersGid = 100;
    busybox =
      pkgs:
      pkgs.busybox.override {
        # Without this, the busybox binary drops euid to ruid for most applets, including id.
        # See https://bugs.busybox.net/show_bug.cgi?id=15101
        extraConfig = "CONFIG_FEATURE_SUID n";
      };
  in
  {
    name = "wrappers";

    nodes.machine =
      { config, pkgs, ... }:
      {
        ids.gids.users = usersGid;

        users.users = {
          regular = {
            uid = userUid;
            isNormalUser = true;
          };
        };

        security.apparmor.enable = true;

        security.wrappers = {
          suidRoot = {
            owner = "root";
            group = "root";
            setuid = true;
            source = "${busybox pkgs}/bin/busybox";
            program = "suid_root_busybox";
          };
          sgidRoot = {
            owner = "root";
            group = "root";
            setgid = true;
            source = "${busybox pkgs}/bin/busybox";
            program = "sgid_root_busybox";
          };
          withChown = {
            owner = "root";
            group = "root";
            source = "${pkgs.libcap}/bin/capsh";
            program = "capsh_with_chown";
            capabilities = "cap_chown+ep";
          };
        };
      };

    testScript = ''
      def cmd_as_regular(cmd):
        return "su -l regular -c '{0}'".format(cmd)

      def test_as_regular(cmd, expected):
        out = machine.succeed(cmd_as_regular(cmd)).strip()
        assert out == expected, "Expected {0} to output {1}, but got {2}".format(cmd, expected, out)

      def test_as_regular_in_userns_mapped_as_root(cmd, expected):
        out = machine.succeed(f"su -l regular -c '${pkgs.util-linux}/bin/unshare -rm {cmd}'").strip()
        assert out == expected, "Expected {0} to output {1}, but got {2}".format(cmd, expected, out)

      test_as_regular('${busybox pkgs}/bin/busybox id -u', '${toString userUid}')
      test_as_regular('${busybox pkgs}/bin/busybox id -ru', '${toString userUid}')
      test_as_regular('${busybox pkgs}/bin/busybox id -g', '${toString usersGid}')
      test_as_regular('${busybox pkgs}/bin/busybox id -rg', '${toString usersGid}')

      test_as_regular('/run/wrappers/bin/suid_root_busybox id -u', '0')
      test_as_regular('/run/wrappers/bin/suid_root_busybox id -ru', '${toString userUid}')
      test_as_regular('/run/wrappers/bin/suid_root_busybox id -g', '${toString usersGid}')
      test_as_regular('/run/wrappers/bin/suid_root_busybox id -rg', '${toString usersGid}')

      test_as_regular('/run/wrappers/bin/sgid_root_busybox id -u', '${toString userUid}')
      test_as_regular('/run/wrappers/bin/sgid_root_busybox id -ru', '${toString userUid}')
      test_as_regular('/run/wrappers/bin/sgid_root_busybox id -g', '0')
      test_as_regular('/run/wrappers/bin/sgid_root_busybox id -rg', '${toString usersGid}')

      test_as_regular_in_userns_mapped_as_root('/run/wrappers/bin/suid_root_busybox id -u', '0')
      test_as_regular_in_userns_mapped_as_root('/run/wrappers/bin/suid_root_busybox id -ru', '0')
      test_as_regular_in_userns_mapped_as_root('/run/wrappers/bin/suid_root_busybox id -g', '0')
      test_as_regular_in_userns_mapped_as_root('/run/wrappers/bin/suid_root_busybox id -rg', '0')

      test_as_regular_in_userns_mapped_as_root('/run/wrappers/bin/sgid_root_busybox id -u', '0')
      test_as_regular_in_userns_mapped_as_root('/run/wrappers/bin/sgid_root_busybox id -ru', '0')
      test_as_regular_in_userns_mapped_as_root('/run/wrappers/bin/sgid_root_busybox id -g', '0')
      test_as_regular_in_userns_mapped_as_root('/run/wrappers/bin/sgid_root_busybox id -rg', '0')

      # Test that in nonewprivs environment the wrappers simply exec their target.
      test_as_regular('${pkgs.util-linux}/bin/setpriv --no-new-privs /run/wrappers/bin/suid_root_busybox id -u', '${toString userUid}')
      test_as_regular('${pkgs.util-linux}/bin/setpriv --no-new-privs /run/wrappers/bin/suid_root_busybox id -ru', '${toString userUid}')
      test_as_regular('${pkgs.util-linux}/bin/setpriv --no-new-privs /run/wrappers/bin/suid_root_busybox id -g', '${toString usersGid}')
      test_as_regular('${pkgs.util-linux}/bin/setpriv --no-new-privs /run/wrappers/bin/suid_root_busybox id -rg', '${toString usersGid}')

      test_as_regular('${pkgs.util-linux}/bin/setpriv --no-new-privs /run/wrappers/bin/sgid_root_busybox id -u', '${toString userUid}')
      test_as_regular('${pkgs.util-linux}/bin/setpriv --no-new-privs /run/wrappers/bin/sgid_root_busybox id -ru', '${toString userUid}')
      test_as_regular('${pkgs.util-linux}/bin/setpriv --no-new-privs /run/wrappers/bin/sgid_root_busybox id -g', '${toString usersGid}')
      test_as_regular('${pkgs.util-linux}/bin/setpriv --no-new-privs /run/wrappers/bin/sgid_root_busybox id -rg', '${toString usersGid}')

      # We are only testing the permitted set, because it's easiest to look at with capsh.
      machine.fail(cmd_as_regular('${pkgs.libcap}/bin/capsh --has-p=CAP_CHOWN'))
      machine.fail(cmd_as_regular('${pkgs.libcap}/bin/capsh --has-p=CAP_SYS_ADMIN'))
      machine.succeed(cmd_as_regular('/run/wrappers/bin/capsh_with_chown --has-p=CAP_CHOWN'))
      machine.fail(cmd_as_regular('/run/wrappers/bin/capsh_with_chown --has-p=CAP_SYS_ADMIN'))

      # Test that the only user of apparmor policy includes generated by
      # wrappers works. Ideally this'd be located in a test for the module that
      # actually makes the apparmor policy for ping, but there's no convenient
      # test for that one.
      machine.succeed("ping -c 1 127.0.0.1")
    '';
  }
)
