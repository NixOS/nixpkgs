{ lib, ... }:

let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) attrsOf functionTo package;
in

{
  options.hardware.acceleration.opengl = {
    enable = mkEnableOption ''
      the Open Graphics Layer acceleration API.

      This is commonly used by graphical applications, desktop environments and games.
    '';

    drivers = mkOption {
      # type = attrsOf (submodule {
      #   options = {
      #     "64" =
      #   };
      # });
      # type = attrsOf (functionTo package);
    };
  };
}
