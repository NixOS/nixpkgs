{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.onlyoffice;
in
{
  options.programs.onlyoffice = {
    enable = lib.mkEnableOption "ONLYOFFICE Desktop Editors, an open-source office suite";

    package = lib.mkPackageOption pkgs "onlyoffice-desktopeditors" { };

    extraFontPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = config.fonts.packages;
      defaultText = lib.literalExpression "config.fonts.packages";
      example = lib.literalExpression "config.fonts.packages ++ [ pkgs.nanum pkgs.liberation_ttf ]";
      description = "Additional fonts to include with onlyoffice.";
    };
  };

  config =
    let
      package = cfg.package.override {
        inherit (cfg) extraFontPackages;
      };
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = [ package ];
    };

  meta.maintainers = with lib.maintainers; [ graysontinker ];
}
