{ ... }:
{
  name = "aporia-wayland";

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [ ../common/user-account.nix ];

      environment.etc."aporia/qtile.wayland" = {
        text = "qtile start -b wayland";
        mode = "755";
      };

      services = {
        displayManager.aporia.enable = true;

        seatd.enable = true;
        xserver.windowManager.qtile.enable = true;
      };

      users.users.alice.extraGroups = [ "seat" ];
    };

  testScript =
    { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
    in
    ''
      start_all()
      machine.wait_until_tty_matches("1", "password:")
      machine.sleep(1)
      machine.screenshot("tty")
      machine.send_key("ret")
      machine.send_chars("alice")
      machine.send_key("ret")
      machine.send_chars("${user.password}")
      machine.send_key("ret")
      machine.sleep(5) # wayland do not support wait_for_window
      machine.screenshot("qtile")
    '';
}
