{ lib, ... }:

{
  name = "startx";
  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.getty.autologinUser = "root";

      environment.systemPackages = with pkgs; [
        xdotool
        catclock
      ];

      programs.bash.promptInit = "PS1='# '";

      # startx+bspwm setup
      services.xserver = {
        enable = true;
        windowManager.bspwm = {
          enable = true;
          configFile = pkgs.writeShellScript "bspwrc" ''
            bspc config border_width 2
            bspc config window_gap 12
            bspc rule -a xclock state=floating sticky=on
          '';
          sxhkd.configFile = pkgs.writeText "sxhkdrc" ''
            # open a terminal
            super + Return
              urxvtc
            # quit bspwm
            super + alt + Escape
              bspc quit
          '';
        };
        displayManager.startx = {
          enable = true;
          generateScript = true;
          extraCommands = ''
            xrdb -load ~/.Xresources
            xsetroot -solid '#343d46'
            xsetroot -cursor_name trek
            xclock &
          '';
        };
      };

      # enable some user services
      security.polkit.enable = true;
      services.urxvtd.enable = true;
      programs.xss-lock.enable = true;
    };

  testScript = ''
    import textwrap

    sysu = "env XDG_RUNTIME_DIR=/run/user/0 systemctl --user";
    prompt = "# "

    with subtest("Wait for the autologin"):
        machine.wait_until_tty_matches("1", prompt)

    with subtest("Setup dotfiles"):
        machine.execute(textwrap.dedent("""
          cat <<EOF > ~/.Xresources
            urxvt*foreground: #9b9081
            urxvt*background: #181b20
            urxvt*scrollBar:  false
            urxvt*title:      myterm
            urxvt*geometry:   80x240+0+0
            xclock*geometry:  164x164+24+440
          EOF
        """))

    with subtest("Can start the X server"):
        machine.send_chars("startx\n")
        machine.wait_for_x()
        machine.wait_for_window("xclock")

    with subtest("Graphical services are running"):
        machine.succeed(f"{sysu} is-active graphical-session.target")
        machine.succeed(f"{sysu} is-active urxvtd")
        machine.succeed(f"{sysu} is-active xss-lock")

    with subtest("Can interact with the WM"):
        machine.wait_until_succeeds("pgrep sxhkd")
        machine.wait_until_succeeds("pgrep bspwm")
        # spawn some terminals
        machine.send_key("meta_l-ret", delay=0.5)
        machine.send_key("meta_l-ret", delay=0.5)
        machine.send_key("meta_l-ret", delay=0.5)
        # Note: this tests that resources have beeen loaded
        machine.wait_for_window("myterm")
        machine.screenshot("screenshot.png")

    with subtest("Can stop the X server"):
        # kill the WM
        machine.send_key("meta_l-alt-esc")
        machine.wait_until_tty_matches("1", prompt)

    with subtest("Graphical session has stopped"):
        machine.fail(f"{sysu} is-active graphical-session.target")
        machine.fail(f"{sysu} is-active urxvtd")
        machine.fail(f"{sysu} is-active xss-lock")
  '';
}
