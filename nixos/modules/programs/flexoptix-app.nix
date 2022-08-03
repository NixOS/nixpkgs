{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.flexoptix-app;
in {
  options = {
    programs.flexoptix-app = {
      enable = mkEnableOption "FLEXOPTIX app + udev rules";

      package = mkOption {
        description = lib.mdDoc "FLEXOPTIX app package to use";
        type = types.package;
        default = pkgs.flexoptix-app;
        defaultText = literalExpression "pkgs.flexoptix-app";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];
  };
}
