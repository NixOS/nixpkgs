{ config, lib, pkgs, utils, ... }:
with lib;
let
  cfg = config.systemd.userdbd;
  systemd = config.systemd.package;
in
{
  options = {
    systemd.userdbd.enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to enable the systemd-userdbd user/group DB lookup service
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.additionalUpstreamSystemUnits = [
      "systemd-userdbd.socket"
      "systemd-userdbd.service"
    ];

    systemd.sockets.systemd-userdbd.wantedBy =  [ "sockets.target" ];
  };
}
