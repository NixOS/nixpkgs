{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.services.local-content-share;
in
{
  options.services.local-content-share = {
    enable = lib.mkEnableOption "Local-Content-Share";

    package = lib.mkPackageOption pkgs "local-content-share" { };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port on which the service will be available";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open chosen port";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.local-content-share = {
      description = "Local-Content-Share";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        StateDirectory = "local-content-share";
        WorkingDirectory = "/var/lib/local-content-share";
        ExecStart = "${lib.getExe' cfg.package "local-content-share"} -listen=:${toString cfg.port}";
        Restart = "on-failure";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };

  meta.maintainers = with lib.maintainers; [ e-v-o-l-v-e ];
}
