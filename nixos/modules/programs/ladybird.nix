{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.ladybird;
in
{
  options.programs.ladybird = {
    enable = lib.mkEnableOption "the Ladybird web browser";
    package = lib.mkPackageOption pkgs "ladybird" { };
    gui = lib.mkOption {
      type = lib.types.str;
      default = null;
      description = ''
        Which gui framework to use, one of "Qt", "Gtk", "Appkit" (Darwin only)
      '';
      example = "Gtk";
    };
  };

  config =
    let
      package = cfg.package.override (
        lib.optionalAttrs (cfg.gui != null) {
          withGui = cfg.gui;
        }
      );
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = [ cfg.package ];
      fonts.fontDir.enable = true;
    };

}
