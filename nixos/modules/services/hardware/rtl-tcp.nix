{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.rtl-tcp;
in
{
  options.services.rtl-tcp = {
    enable = lib.mkEnableOption "RTL-SDR TCP Server";

    package = lib.mkPackageOption pkgs "rtl-sdr" { };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "IP address on which rtl_tcp will listen.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 1234;
      description = "TCP port on which rtl_tcp will listen.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the specified port in the firewall.";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "-g"
        "29"
        "-b"
        "16"
      ];
      description = "Additional command-line arguments to pass to rtl_tcp.";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.rtl-sdr.enable = lib.mkDefault true;

    systemd.services.rtl-tcp = {
      description = "RTL-SDR TCP Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/rtl_tcp -a ${cfg.listenAddress} -p ${toString cfg.port} ${utils.escapeSystemdExecArgs cfg.extraArgs}";
        Restart = "on-failure";
        RestartSec = "5s";
        DynamicUser = true;
        SupplementaryGroups = [ "plugdev" ];
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };

  meta.maintainers = with lib.maintainers; [ the-bober ];
}
