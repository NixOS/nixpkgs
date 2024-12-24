{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.vnstat;
in
{
  options.services.vnstat = {
    enable = lib.mkEnableOption "update of network usage statistics via vnstatd";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ pkgs.vnstat ];

    users = {
      groups.vnstatd = { };

      users.vnstatd = {
        isSystemUser = true;
        group = "vnstatd";
        description = "vnstat daemon user";
      };
    };

    systemd.services.vnstat = {
      description = "vnStat network traffic monitor";
      path = [ pkgs.coreutils ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      documentation = [
        "man:vnstatd(1)"
        "man:vnstat(1)"
        "man:vnstat.conf(5)"
      ];
      serviceConfig = {
        ExecStart = "${pkgs.vnstat}/bin/vnstatd -n";
        ExecReload = "${pkgs.procps}/bin/kill -HUP $MAINPID";

        # Hardening (from upstream example service)
        ProtectSystem = "strict";
        StateDirectory = "vnstat";
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectKernelModules = true;
        PrivateTmp = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictNamespaces = true;

        User = "vnstatd";
        Group = "vnstatd";
      };
    };
  };

  meta.maintainers = [ lib.maintainers.evils ];
}
