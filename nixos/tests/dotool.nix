{ lib, pkgs, ... }:
let
  mkMachine = enable: {
    imports = [ ./common/user-account.nix ];

    programs.dotool = {
      # On the red machine, make sure that the default is false
      enable = lib.mkIf enable true;
      allowedUsers = [ "alice" ];
    };

    services.getty.autologinUser = "alice";
  };
in
{
  name = "dotool";
  meta.maintainers = with lib.maintainers; [ dtomvan ];

  # The idea is to test wether or not the dotool module actually grants extra
  # permissions or not. Just `nix-shell -p dotool` should not work without
  # root because of security concerns.
  nodes = {
    red = mkMachine false // {
      # install dotool without module
      environment.systemPackages = with pkgs; [ dotool ];
    };
    green = mkMachine true;
  };

  enableOCR = true;

  testScript = ''
    start_all()

    output = "/tmp/output"
    message = "Hello world"

    def begin(machine):
      machine.wait_for_unit("multi-user.target")
      machine.wait_for_text("alice")
      machine.fail(f"stat {output}")

    def find_message(machine):
      machine.wait_until_succeeds(f"grep -F '{message}' {output}")

    def run_dotool(account):
      return f"echo $'type echo \"{message}\" > {output}\nkey enter' | sudo -u {account} -i dotool"

    begin(green)
    with subtest("dotool works with the module enabled"):
      green.succeed(run_dotool("alice"))
      find_message(green)

    begin(red)
    with subtest("dotool fails with the module disabled"):
      red.fail(run_dotool("alice"))
      red.fail(f"stat {output}")

    with subtest("root can always use dotool"):
      red.succeed(run_dotool("root"))
      find_message(red)
  '';
}
