{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.cloud-ddns;
in
{
  options.services.cloud-ddns = {
    enable = lib.mkEnableOption "cloud-ddns";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.cloud-ddns;
      description = ''
        This is a Go application that acts as a Dynamic DNS (DDNS) bridge,
        converting DynDNS-formatted HTTP requests into API calls for cloud DNS services.
      '';
    };
    ipAddr = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "bind to ip";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 8080;
      description = "Bind to port";
    };

  };

  config = lib.mkIf cfg.enable {
    systemd.services.cloud-ddns = {
      description = "Cloud DDNS service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/cloud-ddns ${cfg.ipAddr} ${toString cfg.port}";
        Restart = "always";
      };
    };
  };
  meta.maintainers = with lib.maintainers; [
    jason-m
  ];
}
