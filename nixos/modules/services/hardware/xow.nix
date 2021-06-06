{ config, pkgs, lib, ... }:

let
  cfg = config.services.hardware.xow;
in {
  options.services.hardware.xow = {
    enable = lib.mkEnableOption "xow as a systemd service";
  };

  config = lib.mkIf cfg.enable {
    hardware.uinput.enable = true;

    boot.extraModprobeConfig = lib.readFile "${pkgs.xow}/lib/modprobe.d/xow-blacklist.conf";

    systemd.packages = [ pkgs.xow ];
    systemd.services.xow.wantedBy = [ "multi-user.target" ];

    services.udev.packages = [ pkgs.xow ];
  };
}
