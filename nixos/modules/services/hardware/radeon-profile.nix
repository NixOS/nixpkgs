{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.hardware.radeon-profile;
in
{
  options.services.hardware.radeon-profile = {
    enable = mkEnableOption {
      type = types.bool;
      default = false;
      description = ''
        radeon-profile daemon
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.radeon-profile ];

    systemd.services.radeon-profile = {
      description = "radeon-profile daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.radeon-profile-daemon}/bin/radeon-profile-daemon";
        PrivateTmp = "yes";
        PrivateDevices = "yes";
      };
    };
  };
}
