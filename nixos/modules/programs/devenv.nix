{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.devenv;

  hook = shell: "${lib.getExe cfg.package} hook ${shell}";
in
{
  options.programs.devenv = {
    enable = lib.mkEnableOption "devenv, fast, declarative, reproducible and composable developer environments";

    package = lib.mkPackageOption pkgs "devenv" { };

    enableBashIntegration = lib.mkEnableOption "auto-activation of devenv environments in Bash" // {
      default = true;
    };

    enableFishIntegration = lib.mkEnableOption "auto-activation of devenv environments in Fish" // {
      default = true;
    };

    enableNushellIntegration =
      lib.mkEnableOption "auto-activation of devenv environments in Nushell"
      // {
        default = true;
      };

    enableZshIntegration = lib.mkEnableOption "auto-activation of devenv environments in Zsh" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    programs.bash.interactiveShellInit = lib.mkIf cfg.enableBashIntegration ''
      eval "$(${hook "bash"})"
    '';

    programs.fish.interactiveShellInit = lib.mkIf cfg.enableFishIntegration ''
      ${hook "fish"} | source
    '';

    programs.nushell.interactiveShellInit = lib.mkIf cfg.enableNushellIntegration ''
      source ${
        pkgs.runCommand "devenv-nushell-config.nu" { } ''
          ${hook "nu"} > "$out"
        ''
      }
    '';

    programs.zsh.interactiveShellInit = lib.mkIf cfg.enableZshIntegration ''
      eval "$(${hook "zsh"})"
    '';
  };

  meta.maintainers = pkgs.devenv.meta.maintainers;
}
