{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.logitech;

  logitech-rules = pkgs.stdenv.mkDerivation {
    pname = "logitech-udev-rules";
    inherit (pkgs.solaar) version;

    buildCommand = ''
      install -Dm644 -t $out/etc/udev/rules.d ${pkgs.solaar.src}/rules.d/*.rules
    '';

    meta = with pkgs.stdenv.lib; {
      description = "udev rules for Logitech devices";
      inherit (pkgs.solaar.meta) homepage license platforms;
      maintainers = with maintainers; [ peterhoeg ];
    };
  };

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
    services.udev.packages = [ logitech-rules ];
  };
}
