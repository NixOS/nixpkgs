{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.logitech;

in {
  options.hardware.logitech = {
    enable = mkEnableOption "Logitech Devices";

    enableGraphical = mkOption {
      type = types.bool;
      default = false;
      description = "Enable graphical support applications.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.ltunify
    ] ++ lib.optional cfg.enableGraphical pkgs.solaar;

    # ltunifi and solaar both provide udev rules but the most up-to-date have been split
    # out into a dedicated derivation
    services.udev.packages = with pkgs; [ logitech-udev-rules ];
  };
}
