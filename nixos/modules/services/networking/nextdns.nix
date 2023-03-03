{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nextdns;
in {
  options = {
    services.nextdns = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether to enable the NextDNS DNS/53 to DoH Proxy service.";
      };
      arguments = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "-config" "10.0.3.0/24=abcdef" ];
        description = lib.mdDoc "Additional arguments to be passed to nextdns run.";
      };
    };
  };

  # https://github.com/nextdns/nextdns/blob/628ea509eaaccd27adb66337db03e5b56f6f38a8/host/service/systemd/service.go
  config = mkIf cfg.enable {
    systemd.services.nextdns = {
      description = "NextDNS DNS/53 to DoH Proxy";
      environment = {
        SERVICE_RUN_MODE = "1";
      };
      startLimitIntervalSec = 5;
      startLimitBurst = 10;
      serviceConfig = {
        ExecStart = "${pkgs.nextdns}/bin/nextdns run ${escapeShellArgs config.services.nextdns.arguments}";
        RestartSec = 120;
        LimitMEMLOCK = "infinity";
      };
      after = [ "network.target" ];
      before = [ "nss-lookup.target" ];
      wants = [ "nss-lookup.target" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
