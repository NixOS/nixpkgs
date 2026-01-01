{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption mkPackageOption;
  inherit (lib.modules) mkIf;
<<<<<<< HEAD
=======
  inherit (lib.meta) getExe;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  cfg = config.programs.television;
in
{
  options.programs.television = {
    enable = mkEnableOption "Blazingly fast general purpose fuzzy finder TUI";
    package = mkPackageOption pkgs "television" { };

    enableBashIntegration = mkEnableOption "Bash integration";
    enableZshIntegration = mkEnableOption "Zsh integration";
    enableFishIntegration = mkEnableOption "Fish integration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    programs = {
      zsh.interactiveShellInit = mkIf cfg.enableZshIntegration ''
<<<<<<< HEAD
        source ${cfg.package}/share/television/completion.zsh
      '';
      bash.interactiveShellInit = mkIf cfg.enableBashIntegration ''
        source ${cfg.package}/share/television/completion.bash
      '';
      fish.interactiveShellInit = mkIf cfg.enableFishIntegration ''
        source ${cfg.package}/share/television/completion.fish
=======
        eval "$(${getExe cfg.package} init zsh)"
      '';
      bash.interactiveShellInit = mkIf cfg.enableBashIntegration ''
        eval "$(${getExe cfg.package} init bash)"
      '';
      fish.interactiveShellInit = mkIf cfg.enableFishIntegration ''
        ${getExe cfg.package} init fish | source
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      '';
    };

  };

  meta.maintainers = with lib.maintainers; [ pbek ];
}
