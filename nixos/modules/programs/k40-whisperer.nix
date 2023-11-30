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
    enable = mkEnableOption (lib.mdDoc "K40-Whisperer");

    group = mkOption {
      type = types.str;
      description = lib.mdDoc ''
        Group assigned to the device when connected.
      '';
      default = "k40";
    };

    package = mkPackageOption pkgs "k40-whisperer" { };
  };

  config = mkIf cfg.enable {
    users.groups.${cfg.group} = {};

    environment.systemPackages = [ pkg ];
    services.udev.packages = [ pkg ];
  };
}
