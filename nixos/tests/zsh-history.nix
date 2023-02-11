import ./make-test-python.nix ({ pkgs, ...} : {
  name = "zsh-history";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ];
  };

  nodes.default = { ... }: {
    programs = {
      zsh.enable = true;
    };
    environment.systemPackages = [ pkgs.zsh-history ];
    programs.zsh.interactiveShellInit = ''
      source ${pkgs.zsh-history.out}/share/zsh/init.zsh
    '';
    users.users.root.shell = "${pkgs.zsh}/bin/zsh";
  };

  testScript = ''
    start_all()
    default.wait_for_unit("multi-user.target")
    default.wait_until_succeeds("pgrep -f 'agetty.*tty1'")

    # Login
    default.wait_until_tty_matches("1", "login: ")
    default.send_chars("root\n")
    default.wait_until_tty_matches("1", r"\nroot@default\b")

    # Generate some history
    default.send_chars("echo foobar\n")
    default.wait_until_tty_matches("1", "foobar")

    # Ensure that command was recorded in history
    default.succeed("/run/current-system/sw/bin/history list | grep -q foobar")
  '';
})
