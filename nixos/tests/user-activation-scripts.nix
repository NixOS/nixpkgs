{ lib, ... }:
{
  name = "user-activation-scripts";
  meta = with lib.maintainers; {
    maintainers = [ chkno ];
  };

  nodes.machine = {
    system.switch.enable = true;
    system.userActivationScripts.foo = "mktemp ~/user-activation-ran.XXXXXX";
    users.users.alice = {
      initialPassword = "pass1";
      isNormalUser = true;
    };
    systemd.user.tmpfiles.users.alice.rules = [ "r %h/file-to-remove" ];
    specialisation.changed.configuration.system.userActivationScripts.bar = "true";
  };

  testScript = ''
    def verify_user_activation_run_count(n):
        t.assertEqual(
            n,
            int(machine.succeed('find /home/alice/ -name user-activation-ran.\\* | wc -l').rstrip())
        )


    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("getty@tty1.service")
    machine.wait_until_tty_matches("1", "login: ")
    machine.send_chars("alice\n")
    machine.wait_until_tty_matches("1", "Password: ")
    machine.send_chars("pass1\n")
    machine.send_chars("touch login-ok\n")
    machine.wait_for_file("/home/alice/login-ok")
    verify_user_activation_run_count(1)

    machine.succeed("touch /home/alice/file-to-remove")
    machine.succeed("/run/current-system/bin/switch-to-configuration test")
    verify_user_activation_run_count(2)
    machine.succeed("[[ ! -f /home/alice/file-to-remove ]] || false")
    # Activation must not be killed while running.
    machine.fail("journalctl -b _SYSTEMD_USER_UNIT=nixos-activation.service | grep -q 'code=killed'")

    # Changed activation script: still exactly one run.
    machine.succeed("/run/current-system/specialisation/changed/bin/switch-to-configuration test")
    verify_user_activation_run_count(3)
    machine.fail("journalctl -b _SYSTEMD_USER_UNIT=nixos-activation.service | grep -q 'code=killed'")
  '';
}
