{ lib, config, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf attrValues filterAttrs;
  inherit (lib.types) attrsOf nullOr packageSelector;

  this = config.hardware.acceleration.api.opengl;
in

{
  options.hardware.acceleration.api.opengl = {
    enable = mkEnableOption ''
      the Open Graphics Layer acceleration API.

      This is commonly used by graphical applications, desktop environments and games.
    '';

    drivers = mkOption {
      default = { };
      type = attrsOf (nullOr (packageSelector));
    };
  };

  config = mkIf this.enable {
    hardware.acceleration.packages = attrValues (filterAttrs (n: v: v != null) this.drivers);
  };
}
