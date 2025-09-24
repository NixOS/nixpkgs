{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.fractalart;
in
{
  options.services.fractalart = {
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Enable FractalArt for generating colorful wallpapers on login";
    };

    width = mkOption {
      type = types.nullOr types.int;
      default = null;
      example = 1920;
      description = "Screen width";
    };

    height = mkOption {
      type = types.nullOr types.int;
      default = null;
      example = 1080;
      description = "Screen height";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.haskellPackages.FractalArt ];
    services.xserver.displayManager.sessionCommands =
      "${pkgs.haskellPackages.FractalArt}/bin/FractalArt --no-bg -f .background-image"
      + optionalString (cfg.width != null) " -w ${toString cfg.width}"
      + optionalString (cfg.height != null) " -h ${toString cfg.height}";
  };
}
