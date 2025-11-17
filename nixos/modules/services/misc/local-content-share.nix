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

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "127.0.0.1";
      description = ''
        Address on which the service will be available.

        The service will listen on all interfaces if set to an empty string.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port on which the service will be available";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to automatically open the specified port in the firewall";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.local-content-share = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        User = "local-content-share";
        StateDirectory = "local-content-share";
        StateDirectoryMode = "0700";
        WorkingDirectory = "/var/lib/local-content-share";
        ExecStart = "${lib.getExe' cfg.package "local-content-share"} -listen=${cfg.listenAddress}:${toString cfg.port}";
        Restart = "on-failure";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };

  meta.maintainers = with lib.maintainers; [ e-v-o-l-v-e ];
}
