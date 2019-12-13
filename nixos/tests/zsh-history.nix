import ./make-test-python.nix ({ pkgs, ...} : {
  name = "zsh-history";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ kampka ];
  };

  nodes.default = { ... }: {
    programs = {
      zsh.enable = true;
      zsh-history.enable = true;
    };
  };

  testScript = ''
    start_all()
    default.wait_for_unit("multi-user.target")
    default.wait_until_succeeds("pgrep -f 'agetty.*tty1'")

    # Login
    default.wait_until_tty_matches(1, "login: ")
    default.send_chars("root\n")
    default.wait_until_tty_matches(1, "login: root")

    # Launch a zsh shell. This should also load the zsh history code
    default.send_chars("zsh\n")
    default.wait_until_tty_matches(1, "root@default>")

    # Generate some history
    default.send_chars("echo foobar\n")
    default.wait_until_tty_matches(1, "foobar")

    # Ensure that command was recorded in history
    default.succeed("/run/current-system/sw/bin/history list | grep -q foobar")
  '';
})
