{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.obs-studio;
in
{
  options.programs.obs-studio = {
    enable = mkEnableOption (lib.mdDoc "obs-studio");

    package = mkOption {
      type = types.package;
      default = pkgs.obs-studio;
      defaultText = literalExpression "pkgs.obs-studio";
      description = lib.mdDoc ''
        Which package to use for `obs-studio`.
      '';
    };

    finalPackage = mkOption {
      type = types.package;
      visible = false;
      readOnly = true;
      description = "Resulting customized OBS Studio package.";
    };

    plugins = mkOption {
      default = [ ];
      example = literalExpression "[ pkgs.obs-studio-plugins.wlrobs ]";
      description = "Optional OBS plugins.";
      type = types.listOf types.package;
    };
  };

  config = mkIf cfg.enable {
    programs.obs-studio.finalPackage = pkgs.wrapOBS.override { obs-studio = cfg.package; } {
      plugins = cfg.plugins;
    };

    environment.systemPackages = [
      cfg.finalPackage
    ];
  };

  meta.maintainers = with maintainers; [ GaetanLepage ];
}
