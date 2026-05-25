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

    package = lib.mkPackageOption pkgs "onlyoffice-desktopeditors" {
      example = [ "onlyoffice-desktopeditors" ];
    };
  };

  config =
    let
      package = cfg.package.override {
        extraFontPackages = config.fonts.packages;
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
