{ ... }:
{
  name = "aporia-x11";

  nodes.machine =
    { pkgs, ... }:
    let
      default-ascii-art = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/Lunarmagpie/aporia/main/examples/luna.ascii";
        hash = "sha256-9niyJnW48SBnM5jumpVvSBJy0kVvTgE4K45fIWZZ3VA=";
      };
    in
    {
      imports = [ ../common/user-account.nix ];

      environment.etc."aporia/qtile.x11" = {
        text = "qtile start";
        mode = "755";
      };

      users.users.alice.extraGroups = [ "seat" ];

      services = {
        displayManager = {
          aporia = {
            enable = true;
            settings.ascii = {
              name = "luna";
              text = (builtins.readFile default-ascii-art);
            };
          };
          defaultSession = "none+qtile";
        };

        seatd.enable = true;
        xserver = {
          enable = true;
          windowManager.qtile.enable = true;
        };
      };
    };

  testScript =
    { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
    in
    ''
      start_all()

      with subtest("ensure aporia starts"):
          machine.wait_until_tty_matches("1", "password:")
          machine.sleep(1)
          machine.screenshot("tty")

      with subtest("ensure we can login"):
          machine.send_key("ret")
          machine.send_chars("alice")
          machine.send_key("ret")
          machine.send_chars("${user.password}")
          machine.send_key("ret")

      with subtest("ensure x starts"):
          # machine.wait_for_x()
          # machine.wait_for_file("/home/alice/.Xauthority")
          # machine.succeed("xauth merge ~alice/.Xauthority")
          for i in range(50):
            machine.screenshot(f"qtile-{i}")
    '';
}
