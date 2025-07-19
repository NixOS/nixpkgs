{ lib, ... }:
{
  name = "ragnarwm";

  meta = {
    maintainers = with lib.maintainers; [ sigmanificient ];
  };

  nodes.machine =
    {
      pkgs,
      lib,
      nodes,
      ...
    }:
    {
      imports = [ ./common/user-account.nix ];

      services.xserver.enable = true;
      services.xserver.windowManager.ragnarwm.enable = true;

      services.displayManager.defaultSession = lib.mkForce "ragnar";
      services.displayManager.autoLogin = {
        enable = true;
        user = nodes.machine.users.users.alice.name;
      };

      environment.systemPackages = [ pkgs.kitty ];

      environment.etc."ragnarwm/ragnar.cfg".text = ''
        mod_key = "Super";

        keybinds = (
          {
            mod = "%mod_key";
            key = "KeyReturn";
            do = "runcmd";
            cmd = "kitty &";
          },
        );
      '';
    };

  testScript = ''
    with subtest("ensure x starts"):
        machine.wait_for_x()
        machine.wait_for_file("/home/alice/.Xauthority")
        machine.succeed("xauth merge ~alice/.Xauthority")

    with subtest("ensure we can open a new terminal"):
        # Sleeping a bit before the test, as it may help for sending keys
        machine.sleep(2)
        machine.send_key("meta_l-f1")
        # machine.wait_for_window(r"alice.*?machine")
        machine.sleep(2)
        machine.screenshot("terminal")
  '';
}
