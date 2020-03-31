{ config, pkgs, lib, ... }:

let
  cfg = config.services.hardware.xow;
in {
  options.services.hardware.xow = {
    enable = lib.mkEnableOption "xow as a systemd service";
  };

  config = lib.mkIf cfg.enable {
    hardware.uinput.enable = true;

    systemd.packages = [ pkgs.xow ];

    services.udev.packages = [ pkgs.xow ];
  };
}
