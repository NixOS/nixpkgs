{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.duckdns;
in

{

  ###### interface

  options = {

    services.duckdns = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable the DuckDNS dynamic DNS service.
        '';
      };

      subdomain = mkOption {
        type = types.str;
        example = "exampledomain";
        description = lib.mdDoc ''
          The DuckDNS subdomain to update.
        '';
      };

      token = mkOption {
        type = types.str;
        example = "a7c4d0ad-114e-40ef-ba1d-d217904a50f2";
        description = lib.mdDoc ''
          DuckDNS token.
        '';
      };

      timer = mkOption {
        type = types.str;
        default = "*:0/5";
        description = lib.mdDoc ''
          How often to run the DuckDNS update.
          Formatted calendar event expressions (systemd.time(7)).
          The default is 5m.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.curl ];

    systemd.services.duckdns = {
      description = "DuckDNS dynamic DNS updater.";
      serviceConfig.Type = "oneshot";
      script = "echo url=\"https://www.duckdns.org/update?domains=${cfg.subdomain}&token=${cfg.token}&ip=\" | ${pkgs.curl}/bin/curl -k -K -";
    };

    systemd.timers.duckdns = {
      wantedBy = [ "timers.target" ];
      partOf = [ "duckdns.service" ];
      timerConfig.OnCalendar = [ cfg.timer ];
    };
  };
}
