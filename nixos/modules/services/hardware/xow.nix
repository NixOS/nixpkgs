{ config, pkgs, lib, ... }:

let
  cfg = config.services.hardware.xow;
in {
  options.services.hardware.xow = {
    enable = lib.mkEnableOption "Whether to enable xow or not.";
  };

  config = lib.mkIf cfg.enable {
    hardware.uinput.enable = true;

    users.users.xow = {
      group = "uinput";
      isSystemUser = true;
    };

    systemd.services.xow = {
      wantedBy = [ "multi-user.target" ];
      description = "Xbox One Wireless Dongle Driver";
      after = [ "systemd-udev-settle.service" ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.xow}/bin/xow
        '';
        User = "xow";
      };
    };
  };
}
