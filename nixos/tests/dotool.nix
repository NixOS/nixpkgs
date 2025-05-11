{ lib, ... }:
{
  name = "dotool";
  meta.maintainers = with lib.maintainers; [ dtomvan ];

  enableOCR = true;

  nodes.machine = {
    imports = [ ./common/user-account.nix ];

    programs.dotool = {
      enable = true;
      allowedUsers = [ "alice" ];
    };

    services.getty.autologinUser = "alice";
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("multi-user.target")
    machine.wait_for_text("alice")
    machine.succeed("echo 'type echo \"Hello world\" > /tmp/output' | sudo -u alice -i dotool")
    machine.succeed("echo 'key enter' | sudo -u alice -i dotool")
    machine.wait_until_succeeds("grep -F 'Hello world' /tmp/output")
  '';
}
