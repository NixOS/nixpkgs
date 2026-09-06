{
  lib,
  pkgs,
  config,
  ...
}:

with lib;

let
  cfg = config.services.slimevr-server;
in
{
  options.services.slimevr-server = {
    enable = mkEnableOption "the SlimeVR server";
    package = mkPackageOption pkgs "slimevr-server" { };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open UDP port 6969 in the firewall for SlimeVR";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = lib.mkIf cfg.openFirewall { allowedUDPPorts = [ 6969 ]; };
    systemd.services.slimevr-server = {
      description = "SlimeVR Server";

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/slimevr-server run";
        DynamicUser = true;
        Restart = "on-failure";
        RuntimeDirectory = "slimevr-server";
      };
    };
  };
}
