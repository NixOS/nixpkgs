{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.programs.vivid;
in
{
  options = {
    programs.vivid = {
      enable = lib.mkOption {
        default = false;
        description = "Whether to configure LS_COLORS with vivid.";
        type = lib.types.bool;
      };

      package = lib.mkPackageOption pkgs "vivid" { example = "vivid"; };

      theme = lib.mkOption {
        default = "gruvbox-dark-soft";
        description = "Theme to be used (see `vivid themes`)";
        example = "solarized-dark";
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    programs =
      let
        interactiveShellInit = lib.mkAfter ''
          export LS_COLORS="$(${lib.getExe cfg.package} generate ${cfg.theme})"
        '';
        enableLsColors = lib.mkOverride 999 false;
      in
      {
        bash = {
          inherit interactiveShellInit enableLsColors;
        };
        zsh = {
          inherit interactiveShellInit enableLsColors;
        };
      };

    assertions = [
      {
        assertion = !config.programs.bash.enableLsColors;
        message = "`programs.vivid.enable` is incompatible with `programs.bash.enableLsColors`.";
      }
      {
        assertion = !config.programs.zsh.enableLsColors;
        message = "`programs.vivid.enable` is incompatible with `programs.zsh.enableLsColors`.";
      }
    ];
  };

  meta.maintainers = with lib.maintainers; [ gdifolco ];
}
