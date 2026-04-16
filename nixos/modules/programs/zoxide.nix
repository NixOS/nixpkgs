{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption mkPackageOption mkOption;
  inherit (lib.modules) mkIf;
  inherit (lib.types) listOf str;
  inherit (lib.strings) concatStringsSep;

  cfg = config.programs.zoxide;

  cfgFlags = concatStringsSep " " cfg.flags;

in
{
  options.programs.zoxide = {
    enable = mkEnableOption "zoxide, a smarter cd command that learns your habits";
    package = mkPackageOption pkgs "zoxide" { };

    enableBashIntegration = mkEnableOption "Bash integration" // {
      default = true;
    };
    enableZshIntegration = mkEnableOption "Zsh integration" // {
      default = true;
    };
    enableFishIntegration = mkEnableOption "Fish integration" // {
      default = true;
    };
    enableXonshIntegration = mkEnableOption "Xonsh integration" // {
      default = true;
    };

    flags = mkOption {
      type = listOf str;
      default = [ ];
      example = [
        "--no-cmd"
        "--cmd j"
      ];
      description = ''
        List of flags for zoxide init
      '';
    };

  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    programs = {
      zsh.interactiveShellInit = mkIf cfg.enableZshIntegration ''
        eval "$(${cfg.package.exe} init zsh ${cfgFlags} )"
      '';
      bash.interactiveShellInit = mkIf cfg.enableBashIntegration ''
        eval "$(${cfg.package.exe} init bash ${cfgFlags} )"
      '';
      fish.interactiveShellInit = mkIf cfg.enableFishIntegration ''
        ${cfg.package.exe} init fish ${cfgFlags} | source
      '';
      xonsh.config = ''
        execx($(${cfg.package.exe} init xonsh ${cfgFlags}), 'exec', __xonsh__.ctx, filename='zoxide')
      '';
    };

  };

  meta.maintainers = with lib.maintainers; [ heisfer ];
}
