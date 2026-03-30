{ pkgs, ... }:
{
  name = "maestral";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ peterhoeg ];
  };

  nodes =
    let
      common =
        attrs:
        pkgs.lib.recursiveUpdate {
          imports = [ ./common/user-account.nix ];
          systemd.user.services.maestral = {
            description = "Maestral Dropbox Client";
            serviceConfig.Type = "exec";
          };
        } attrs;

    in
    {
      cli =
        { ... }:
        common {
          systemd.user.services.maestral = {
            wantedBy = [ "default.target" ];
            serviceConfig.ExecStart = "${pkgs.maestral}/bin/maestral start --foreground";
          };
        };

      gui =
        { ... }:
        common {
          services.xserver.enable = true;
          services.desktopManager.plasma6.enable = true;

          services.displayManager = {
            sddm.enable = true;
            defaultSession = "plasma";
            autoLogin = {
              enable = true;
              user = "alice";
            };
          };

          systemd.user.services = {
            maestral = {
              wantedBy = [ "graphical-session.target" ];
              serviceConfig.ExecStart = "${pkgs.maestral-gui}/bin/maestral_qt";
            };
            # PowerDevil doesn't like our VM
            plasma-powerdevil.enable = false;
          };
        };
    };

  testScript =
    { nodes, ... }:
    let
      user = nodes.cli.users.users.alice;
    in
    ''
      start_all()

      with subtest("CLI"):
        # we need SOME way to give the user an active login session
        cli.execute("loginctl enable-linger ${user.name}")
        cli.systemctl("start user@${toString user.uid}")
        cli.wait_for_unit("maestral.service", "${user.name}")

      with subtest("GUI"):
        gui.wait_for_x()
        gui.wait_for_file("/run/user/1000/xauth_*")
        gui.wait_until_succeeds("test -s /run/user/1000/xauth_*")
        gui.succeed("xauth merge /run/user/1000/xauth_*")
        gui.wait_for_window("^Desktop ")
        gui.wait_for_unit("maestral.service", "${user.name}")
    '';
}
