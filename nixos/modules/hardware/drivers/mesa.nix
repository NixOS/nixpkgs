{ config, lib, pkgs, ... }:

let
  this = config.hardware.drivers.mesa;
  inherit (lib) mkIf genAttrs;
  inherit (lib.options) mkPackageOption' mkEnableOption mkOption;
  inherit (lib.types) attrsOf submodule;
in

{
  options.hardware.drivers.mesa = {
    enable = mkEnableOption ''
      the Mesa 3D Graphics Library.

      This provides many open graphics APIs for common hardware accelerators such as GPUs and TPUs.
    '';

    package = mkPackageOption' "mesa" {
      # defaultPackage = "mesa";
      # defaultText = "pkgs: pkgs.mesa";
    };
  };

  config = mkIf this.enable {
    hardware.acceleration = genAttrs (this.package pkgs).passthru.apis (name: if true then { } else {
      drivers.mesa = this.package;
    });
  };
}
