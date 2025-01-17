import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "oh-my-zsh";

    nodes.machine =
      { pkgs, ... }:

      {
        programs.zsh = {
          enable = true;
          ohMyZsh.enable = true;
        };
      };

    testScript = ''
      start_all()
      machine.succeed("touch ~/.zshrc")
      machine.succeed("zsh -c 'source /etc/zshrc && echo $ZSH | grep oh-my-zsh-${pkgs.oh-my-zsh.version}'")
    '';
  }
)
