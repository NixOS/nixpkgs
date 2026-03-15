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
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
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
    machine.succeed("bash -c 'eval \"$(atuin init bash)\"'")
    machine.succeed("zsh -c 'eval \"$(atuin init zsh)\"'")
    machine.succeed("fish -c 'atuin init fish | source'")

    # Verify config file was created
    machine.succeed("test -f /etc/xdg/atuin/config.toml")
    machine.succeed("grep -q 'auto_sync = false' /etc/xdg/atuin/config.toml")
  '';
}
