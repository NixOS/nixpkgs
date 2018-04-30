{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dnsdist;
  configFile = pkgs.writeText "dnsdist.conf" "${cfg.config}";
in {
  options = {
    services.dnsdist = {
      enable = mkEnableOption "dnsdist DNS loadbalancer";

      config = mkOption {
        default = "";
        example = ''
          newServer({address="2001:4860:4860::8888", qps=1})
          newServer({address="2001:4860:4860::8844", qps=1})
          newServer({address="2620:0:ccc::2", qps=10})
          newServer({address="2620:0:ccd::2", name="dns1", qps=10})
          newServer("192.168.1.2")
          setServerPolicy(firstAvailable) -- first server within its QPS limit
        '';
        type = types.lines;
        description = "Verbatim dnsdist configuration to use";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [{
      assertion = cfg.config != "";
      message = "You must provide services.dnsdist.config.";
    }];

    systemd.services.dnsdist = {
      description = "DNS Loadbalancer";
      unitConfig.Documentation = "man:dnsdist(1) http://dnsdist.org";
      wantedBy = [ "multi-user.target" ];
      after = ["network.target" ];

      serviceConfig = {
        Type = "notify";
        Restart = "on-failure";
        RestartSec = 2;
        TimeoutStopSec = 5;
        StartLimitInterval = 0;
        PrivateTmp = true;
        PrivateDevices = true;
        CapabilityBoundingSet = "CAP_NET_BIND_SERVICE CAP_SETGID CAP_SETUID";
        NoNewPrivileges = true;
        ExecStartPre = "${pkgs.dnsdist}/bin/dnsdist --uid=${toString config.ids.uids.nobody} --gid=${toString config.ids.gids.nogroup} --config=${configFile} --check-config";
        # Note: when editing the ExecStart command, keep --supervised and --disable-syslog
        ExecStart = "${pkgs.dnsdist}/bin/dnsdist --supervised --disable-syslog --uid=${toString config.ids.uids.nobody} --gid=${toString config.ids.gids.nogroup} --config=${configFile}";
        ProtectSystem = "full";
        ProtectHome = true;
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
        LimitNOFILE = 16384;
        TasksMax = 8192;
      };
    };
  };
}
