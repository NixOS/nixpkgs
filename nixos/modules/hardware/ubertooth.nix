{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.ubertooth;

  ubertoothPkg = pkgs.ubertooth.override {
    udevGroup = cfg.group;
  };
in {
  options.hardware.ubertooth = {
    enable = mkEnableOption "Ubertooth software and its udev rules";

    group = mkOption {
      type = types.str;
      default = "ubertooth";
      example = "wheel";
      description = "Group for Ubertooth's udev rules.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ ubertoothPkg ];

    services.udev.packages = [ ubertoothPkg ];
    users.groups.${cfg.group} = {};
  };
}
