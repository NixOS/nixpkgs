{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.nextdns;
in
{
  options = {
    services.nextdns = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable the NextDNS DNS/53 to DoH Proxy service.";
      };
      arguments = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [
          "-config"
          "10.0.3.0/24=abcdef"
        ];
        description = "Additional arguments to be passed to nextdns run.";
      };
    };
  };

  # https://github.com/nextdns/nextdns/blob/628ea509eaaccd27adb66337db03e5b56f6f38a8/host/service/systemd/service.go
  config = lib.mkIf cfg.enable {
    systemd.services.nextdns = {
      description = "NextDNS DNS/53 to DoH Proxy";
      environment = {
        SERVICE_RUN_MODE = "1";
      };
      startLimitIntervalSec = 5;
      startLimitBurst = 10;
      serviceConfig = {
        ExecStart = "${pkgs.nextdns}/bin/nextdns run ${lib.escapeShellArgs config.services.nextdns.arguments}";
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
