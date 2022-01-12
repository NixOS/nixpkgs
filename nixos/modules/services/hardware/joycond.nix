{ config, lib, pkgs, ... }:

let
  cfg = config.services.joycond;
  kernelPackages = config.boot.kernelPackages;
in

with lib;

{
  options.services.joycond = {
    enable = mkEnableOption "support for Nintendo Pro Controllers and Joycons";

    package = mkOption {
      type = types.package;
      default = pkgs.joycond;
      defaultText = "pkgs.joycond";
      description = ''
        The joycond package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      kernelPackages.hid-nintendo
      cfg.package
    ];

    boot.extraModulePackages = [ kernelPackages.hid-nintendo ];
    boot.kernelModules = [ "hid_nintendo" ];

    services.udev.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    # Workaround for https://github.com/NixOS/nixpkgs/issues/81138
    systemd.services.joycond.wantedBy = [ "multi-user.target" ];
  };
}
