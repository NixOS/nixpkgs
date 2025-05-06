{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption mkPackageOption;
  inherit (lib.modules) mkIf;
  inherit (lib.meta) getExe;

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
        eval "$(${getExe cfg.package} init zsh)"
      '';
      bash.interactiveShellInit = mkIf cfg.enableBashIntegration ''
        eval "$(${getExe cfg.package} init bash)"
      '';
      fish.interactiveShellInit = mkIf cfg.enableFishIntegration ''
        ${getExe cfg.package} init fish | source
      '';
    };

  };

  meta.maintainers = with lib.maintainers; [ pbek ];
}
