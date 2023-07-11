{ config, lib, ... }:

let
  cfg = config.services.userdbd;
in
{
  options.services.userdbd.enable = lib.mkEnableOption (lib.mdDoc ''
    Enables the systemd JSON user/group record lookup service
  '');
  config = lib.mkIf cfg.enable {
    systemd.additionalUpstreamSystemUnits = [
      "systemd-userdbd.socket"
      "systemd-userdbd.service"
    ];

    systemd.sockets.systemd-userdbd.wantedBy = [ "sockets.target" ];
  };
}
