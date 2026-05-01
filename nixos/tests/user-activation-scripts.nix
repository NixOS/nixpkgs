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
  };

  testScript = ''
    def verify_user_activation_run_count(n):
        machine.succeed(
            '[[ "$(find /home/alice/ -name user-activation-ran.\\* | wc -l)" == %s ]]' % n
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
  '';
}
