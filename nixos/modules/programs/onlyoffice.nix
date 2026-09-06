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
      default = [ ];
      example = lib.literalExpression "[ pkgs.nanum pkgs.liberation_ttf ]";
      description = "Additional fonts to include with onlyoffice. Defaults to fonts.packages.";
    };
  };

  config =
    let
      package = cfg.package.override {
        extraFontPackages =
          if cfg.extraFontPackages == [ ] then config.fonts.packages else cfg.extraFontPackages;
      };
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = [ package ];
    };

  meta = {
    maintainers = [ lib.maintainers.emmanuelrosa ];
    doc = ./onlyoffice.md;
  };
}
