{ config, lib, pkgs, ... }:

let
  cfg = config.services.joycond;
  kernelPackages = config.boot.kernelPackages;
in

with lib;

{
  options.services.joycond = {
    enable = mkEnableOption (lib.mdDoc "support for Nintendo Pro Controllers and Joycons");

    package = mkOption {
      type = types.package;
      default = pkgs.joycond;
      defaultText = "pkgs.joycond";
      description = lib.mdDoc ''
        The joycond package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    boot.extraModulePackages = optional (versionOlder kernelPackages.kernel.version "5.16") kernelPackages.hid-nintendo;

    services.udev.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    # Workaround for https://github.com/NixOS/nixpkgs/issues/81138
    systemd.services.joycond.wantedBy = [ "multi-user.target" ];
  };
}
