{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.fractalart;
in
{
  options.services.fractalart = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = "Enable FractalArt for generating colorful wallpapers on login";
    };

    width = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      example = 1920;
      description = "Screen width";
    };

    height = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      example = 1080;
      description = "Screen height";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.haskellPackages.FractalArt ];
    services.xserver.displayManager.sessionCommands =
      "${pkgs.haskellPackages.FractalArt}/bin/FractalArt --no-bg -f .background-image"
      + lib.optionalString (cfg.width != null) " -w ${toString cfg.width}"
      + lib.optionalString (cfg.height != null) " -h ${toString cfg.height}";
  };
}
