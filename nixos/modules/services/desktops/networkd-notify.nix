{ config, lib, pkgs, ... }:

with lib;

{
  ###### interface

  options = {

    services.networkd-notify = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the networkd-notify script.
          Make sure to enable a desktop-notification service like dunst as well.
        '';
      };

    };

  };

  ###### implementation

  config = mkIf config.services.networkd-notify.enable {

    environment.systemPackages = [ pkgs.networkd-notify ];

    systemd.services.networkd-notify = {
      description = "networkd desktop notification";
      wantedBy    = [ "multi-user.target" ];
    };

  };

  meta = {
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };

}

