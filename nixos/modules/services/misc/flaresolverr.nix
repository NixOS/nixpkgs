{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.flaresolverr;
in
{
  options = {
    services.flaresolverr = {
      enable = lib.mkEnableOption "FlareSolverr, a proxy server to bypass Cloudflare protection";

      package = lib.mkPackageOption pkgs "flaresolverr" { };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open the port in the firewall for FlareSolverr.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8191;
        description = "The port on which FlareSolverr will listen for incoming HTTP traffic.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.flaresolverr = {
      description = "FlareSolverr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        HOME = "/run/flaresolverr";
        PORT = toString cfg.port;
      };

      serviceConfig = {
        SyslogIdentifier = "flaresolverr";
        Restart = "always";
        RestartSec = 5;
        Type = "simple";
        DynamicUser = true;
        RuntimeDirectory = "flaresolverr";
        WorkingDirectory = "/run/flaresolverr";
        ExecStart = lib.getExe cfg.package;
        TimeoutStopSec = 30;
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };
}
