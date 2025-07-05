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
    enable = lib.mkEnableOption "cloud-ddns, a simple DDNS server for Cloud API DNS updates";

    package = lib.mkPackageOption pkgs "cloud-ddns" { };

    ipAddr = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "IP address to bind to.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port to bind to.";
    };

  };

  config = lib.mkIf cfg.enable {
    systemd.services.cloud-ddns = {
      description = "Cloud DDNS service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} ${cfg.ipAddr} ${toString cfg.port}";
        Restart = "always";
      };
    };
  };
  meta.maintainers = with lib.maintainers; [
    jason-m
  ];
}
