{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.services.local-content-share;
in
{
  options.services.local-content-share = {
    enable = mkEnableOption "Local-Content-Share";

    package = mkPackageOption pkgs "local-content-share" { };

    port = mkOption {
      type = types.int;
      default = 8080;
      description = "Port on which the service will be available";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Open chosen port";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.local-content-share = {
      description = "Local-Content-Share";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        StateDirectory = "local-content-share";
        WorkingDirectory = "/var/lib/local-content-share";
        ExecStart = "${getExe' cfg.package "local-content-share"} -listen=:${toString cfg.port}";
        Restart = "on-failure";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };

  meta.maintainers = with maintainers; [ e-v-o-l-v-e ];
}
