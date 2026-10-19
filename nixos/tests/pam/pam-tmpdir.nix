{ lib, ... }:
{
  name = "pam-tmpdir";
  meta.maintainers = with lib.maintainers; [ MrQubo ];

  nodes.machine = {
    config.users.users = {
      alice = {
        isNormalUser = true;
        uid = 1000;
      };
      bob = {
        isNormalUser = true;
        uid = 1001;
      };
    };
    config.boot.tmp.perUser = true;
  };

  testScript =
    # python
    ''
      # Looks like root shell for commands run directly with `.succeed()` doesn't go through PAM.
      with subtest("root: directory exists"):
          machine.succeed("su root -c 'stat /tmp/user/0'")
      with subtest("root: $TMPDIR set"):
          tmpdir = machine.succeed("su root -c 'printf %s $TMPDIR'")
          assert tmpdir == "/tmp/user/0", f'{tmpdir = }'

      with subtest("user login with su: directory exists and accessible"):
          machine.succeed("su alice -c 'stat /tmp/user/1000'")
      with subtest("user login with su: $TMPDIR set"):
          tmpdir = machine.succeed("su alice -c 'printf %s $TMPDIR'")
          assert tmpdir == "/tmp/user/1000", f'{tmpdir = }'

      with subtest("user login with runuser -l: directory exists and accessible"):
          machine.succeed("runuser bob -l -- -c 'stat /tmp/user/1001'")
      with subtest("user login with runuser -l: $TMPDIR set"):
          tmpdir = machine.succeed("runuser bob -l -c 'printf %s $TMPDIR'")
          assert tmpdir == "/tmp/user/1001", f'{tmpdir = }'

      with subtest("user can list /tmp/user/1000"):
          machine.succeed('runuser -u alice -- ls /tmp/user/1000')
      with subtest("user cannot list /tmp/user"):
          machine.fail('runuser -u alice -- ls /tmp/user')
      with subtest("user cannot list /tmp/user/0"):
          machine.fail('runuser -u alice -- ls /tmp/user/0')
      with subtest("user cannot list /tmp/user/1001"):
          machine.fail('runuser -u alice -- ls /tmp/user/1001')

      with subtest("user cannot write to /tmp/user"):
          machine.fail('runuser -u alice -- mkdir /tmp/user/1900')

      with subtest("user can write to /tmp/user/1000"):
          machine.succeed('runuser -u alice -- touch /tmp/user/1000/pam_tmpdir-nixos_test')
      with subtest("user cannot write to /tmp/user/0"):
          machine.fail('runuser -u alice -- touch /tmp/user/0/pam_tmpdir-nixos_test')
      with subtest("user cannot write to /tmp/user/1001"):
          machine.fail('runuser -u alice -- touch /tmp/user/1001/pam_tmpdir-nixos_test')

      with subtest("user can read from /tmp/user/1000"):
          machine.succeed('runuser -u alice -- cat /tmp/user/1000/pam_tmpdir-nixos_test')
      with subtest("user cannot read from /tmp/user/0"):
          machine.succeed('touch /tmp/user/0/pam_tmpdir-nixos_test')
          machine.fail('runuser -u alice -- cat /tmp/user/0/pam_tmpdir-nixos_test')
      with subtest("user cannot read from /tmp/user/1001"):
          machine.succeed('runuser -u bob -- touch /tmp/user/1001/pam_tmpdir-nixos_test')
          machine.fail('runuser -u alice -- cat /tmp/user/1001/pam_tmpdir-nixos_test')
    '';
}
