{ lib, ... }:
{
  name = "xmonad-xdg-autostart";
  meta.maintainers = with lib.maintainers; [ oxalica ];

  nodes.machine =
    { pkgs, config, ... }:
    {
      imports = [
        ./common/x11.nix
        ./common/user-account.nix
      ];
      test-support.displayManager.auto.user = "alice";
      services.displayManager.defaultSession = "none+xmonad";
      services.xserver.windowManager.xmonad.enable = true;
      services.xserver.desktopManager.runXdgAutostartIfNone = true;

      environment.systemPackages = [
        (pkgs.writeTextFile {
          name = "test-xdg-autostart";
          destination = "/etc/xdg/autostart/test-xdg-autostart.desktop";
          text = ''
            [Desktop Entry]
            Name=test-xdg-autoatart
            Type=Application
            Terminal=false
            Exec=${pkgs.coreutils}/bin/touch ${config.users.users.alice.home}/xdg-autostart-executed
          '';
        })
      ];
    };

  testScript =
    { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
    in
    ''
      machine.wait_for_x()
      machine.wait_for_file("${user.home}/xdg-autostart-executed")
    '';
}
