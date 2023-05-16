{ config, lib, pkgs, ... }:

let
  cfg = config.services.joycond;
<<<<<<< HEAD
=======
  kernelPackages = config.boot.kernelPackages;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in

with lib;

{
  options.services.joycond = {
    enable = mkEnableOption (lib.mdDoc "support for Nintendo Pro Controllers and Joycons");

    package = mkOption {
      type = types.package;
      default = pkgs.joycond;
      defaultText = lib.literalExpression "pkgs.joycond";
      description = lib.mdDoc ''
        The joycond package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

<<<<<<< HEAD
=======
    boot.extraModulePackages = optional (versionOlder kernelPackages.kernel.version "5.16") kernelPackages.hid-nintendo;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    services.udev.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    # Workaround for https://github.com/NixOS/nixpkgs/issues/81138
    systemd.services.joycond.wantedBy = [ "multi-user.target" ];
  };
}
