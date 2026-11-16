{ pkgs, ... }:
{
  name = "atuin";
  meta.maintainers = pkgs.atuin.meta.maintainers;

  nodes.machine = {
    programs = {
      bash.enable = true;
      fish.enable = true;
      zsh.enable = true;

      atuin = {
        enable = true;
        settings = {
          auto_sync = false;
        };
      };
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("default.target")

    # Check atuin is installed
    machine.succeed("atuin --version")

    # Check shell integration - verify the init scripts can be sourced without error
    # bash init only runs in interactive shells; skip bashrc, which already sources it
    machine.succeed("bash --norc -ic 'eval \"$(atuin init bash)\"'")
    machine.succeed("zsh -c 'eval \"$(atuin init zsh)\"'")
    machine.succeed("fish -c 'atuin init fish | source'")

    # Verify config file was created
    machine.succeed("grep -q 'auto_sync = false' /etc/atuin/config.toml")

    # Verify daemon socket unit is enabled
    # needs a running user manager for root
    machine.succeed("loginctl enable-linger root")
    machine.wait_until_succeeds("systemctl --user --machine=root@ is-enabled atuin-daemon.socket")
  '';
}
