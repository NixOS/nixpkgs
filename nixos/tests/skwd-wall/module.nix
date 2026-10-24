{ lib, pkgs, ... }:
{
  name = "skwd-wall-v2";
  meta.maintainers = with lib.maintainers; [
    HomieDerPrakti
    futurekismo
  ];

  nodes.machine = { pkgs, ... }: {
    imports = [ ../../modules/programs/skwd-wall-v2.nix ];
    services.skwd-walld.enable = true;

    users.users.tester = {
      isNormalUser = true;
      password = "";
    };
  };

  testScript = ''
    import shlex
    machine.wait_for_unit("multi-user.target")

    machine.succeed("skwd-wall-v2 --version")
    machine.succeed("skwd-walld --version")
    machine.succeed("skwd-paper-v2 --version")
    machine.succeed("skwd-lens --version")
    machine.succeed("skwd-helm --version")

    machine.succeed("loginctl enable-linger tester")

    machine.wait_for_unit("user@1000.service")

    def user(command):
      return "su - tester -c " + shlex.quote("export XDG_RUNTIME_DIR=/run/user/1000; " + command)

    machine.succeed(user("systemctl --user start skwd-walld.service"))
    machine.wait_until_succeeds(user("systemctl --user is-active skwd-walld.service"))

    machine.succeed(user("systemctl --user show-environment | grep -q SKWD_LENS_HOME"))

    model_path = machine.succeed(user("systemctl --user show-environment | grep SKWD_LENS_HOME | cut -d= -f2-")).strip()
    machine.succeed(f"test -d {model_path}")

    status = machine.succeed(user("systemctl --user status skwd-walld.service"))
    print(status)
  '';
}
