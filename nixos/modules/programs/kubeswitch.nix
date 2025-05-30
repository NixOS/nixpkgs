{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.kubeswitch;
in
{
  options = {
    programs.kubeswitch = {
      enable = lib.mkEnableOption "kubeswitch";

      commandName = lib.mkOption {
        type = lib.types.str;
        default = "kswitch";
        description = "The name of the command to use";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.kubeswitch;
        defaultText = lib.literalExpression "pkgs.kubeswitch";
        description = "The package to install for kubeswitch";
      };
    };
  };

  config =
    let
      shell_files = pkgs.runCommand "kubeswitch-shell-files" { } ''
        mkdir -p $out/share
        for shell in bash zsh; do
          ${cfg.package}/bin/switcher init $shell | sed 's/switch(/${cfg.commandName}(/' > $out/share/${cfg.commandName}_init.$shell
          ${cfg.package}/bin/switcher --cmd ${cfg.commandName} completion $shell > $out/share/${cfg.commandName}_completion.$shell
        done
      '';
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = [ cfg.package ];

      programs.bash.interactiveShellInit = ''
        source ${shell_files}/share/${cfg.commandName}_init.bash
        source ${shell_files}/share/${cfg.commandName}_completion.bash
      '';
      programs.zsh.interactiveShellInit = ''
        source ${shell_files}/share/${cfg.commandName}_init.zsh
        source ${shell_files}/share/${cfg.commandName}_completion.zsh
      '';
    };
}
