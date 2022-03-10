{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.k40-whisperer;
  pkg = cfg.package.override {
    udevGroup = cfg.group;
  };
in
{
  options.programs.k40-whisperer = {
    enable = mkEnableOption "K40-Whisperer";

    group = mkOption {
      type = types.str;
      description = ''
        Group assigned to the device when connected.
      '';
      default = "k40";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.k40-whisperer;
      defaultText = literalExpression "pkgs.k40-whisperer";
      example = literalExpression "pkgs.k40-whisperer";
      description = ''
        K40 Whisperer package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    users.groups.${cfg.group} = {};

    environment.systemPackages = [ pkg ];
    services.udev.packages = [ pkg ];
  };
}
