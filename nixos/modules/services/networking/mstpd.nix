{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.mstpd;
in
{
  options.services.mstpd = {

    enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Whether to enable the multiple spanning tree protocol daemon.
      '';
    };

  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.mstpd ];

    systemd.services.mstpd = {
      description = "Multiple Spanning Tree Protocol Daemon";
      wantedBy = [ "network.target" ];
      unitConfig.ConditionCapability = "CAP_NET_ADMIN";
      serviceConfig = {
        Type = "forking";
        ExecStart = "@${pkgs.mstpd}/bin/mstpd mstpd";
        PIDFile = "/run/mstpd.pid";
      };
    };
  };
}
