{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.vuls;
in
{
  meta.maintainers = [ lib.maintainers.kashw2 ];

  options.services.vuls = {
    enable = lib.mkEnableOption "Vuls, am Agent-less vulnerability scanner for Linux, FreeBSD, Container, WordPress, Programming language libraries, Network devices.";

    package = lib.mkPackageOption pkgs "vuls" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open port in the firewall for the Vuls web interface.";
    };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "The listen address the server should serve from.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5515;
      description = "The port the Vuls UI should run on.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.vuls = {
      description = "Vuls, an Agent-less vulnerability scanner";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.vuls}/bin/vuls server \
            -listen=${cfg.listenAddress}:${cfg.port}
        '';
        DynamicUser = true;
        Restart = "on-failure";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
