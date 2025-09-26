{ runTest }:
{
  default = runTest {
    name = "sddm";

    nodes.machine = {
      imports = [ ./common/user-account.nix ];
      services.xserver.enable = true;
      services.displayManager.sddm.enable = true;
      services.displayManager.defaultSession = "none+icewm";
      services.xserver.windowManager.icewm.enable = true;
    };

    enableOCR = true;

    testScript =
      { nodes, ... }:
      let
        user = nodes.machine.users.users.alice;
      in
      ''
        start_all()
        machine.wait_for_text("(?i)select your user")
        machine.screenshot("sddm")
        machine.send_chars("${user.password}\n")
        machine.wait_for_file("/tmp/xauth_*")
        machine.wait_until_succeeds("test -s /tmp/xauth_*")
        machine.succeed("xauth merge /tmp/xauth_*")
        machine.wait_for_window("^IceWM ")
      '';
  };

  autoLogin = runTest (
    { lib, ... }:
    {
      name = "sddm-autologin";
      meta = with lib.maintainers; {
        maintainers = [ ttuegel ];
      };

      nodes.machine = {
        imports = [ ./common/user-account.nix ];
        services.xserver.enable = true;
        services.displayManager = {
          sddm.enable = true;
          autoLogin = {
            enable = true;
            user = "alice";
          };
        };
        services.displayManager.defaultSession = "none+icewm";
        services.xserver.windowManager.icewm.enable = true;
      };

      testScript = ''
        start_all()
        machine.wait_for_file("/tmp/xauth_*")
        machine.wait_until_succeeds("test -s /tmp/xauth_*")
        machine.succeed("xauth merge /tmp/xauth_*")
        machine.wait_for_window("^IceWM ")
      '';
    }
  );
}
