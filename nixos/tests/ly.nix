import ./make-test-python.nix (
  { ... }:

  {
    name = "ly";

    nodes.machine =
      { ... }:
      {
        imports = [ ./common/user-account.nix ];
        services.displayManager.ly = {
          enable = true;
          settings = {
            load = false;
            save = false;
          };
        };
        services.xserver.enable = true;
        services.displayManager.defaultSession = "none+icewm";
        services.xserver.windowManager.icewm.enable = true;
      };

    testScript =
      { nodes, ... }:
      let
        user = nodes.machine.users.users.alice;
      in
      ''
        start_all()
        machine.wait_until_tty_matches("2", "password:")
        machine.send_key("ctrl-alt-f2")
        machine.sleep(1)
        machine.screenshot("ly")
        machine.send_chars("alice")
        machine.send_key("tab")
        machine.send_chars("${user.password}")
        machine.send_key("ret")
        machine.wait_for_file("/run/user/${toString user.uid}/lyxauth")
        machine.succeed("xauth merge /run/user/${toString user.uid}/lyxauth")
        machine.wait_for_window("^IceWM ")
        machine.screenshot("icewm")
      '';
  }
)
