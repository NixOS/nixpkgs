{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.soapy-remote;
in
{
  options.services.soapy-remote = {
    enable = lib.mkEnableOption "SoapyRemote server for streaming SDR data over the network";
    package = lib.mkPackageOption pkgs "soapyremote" { };
    host = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "IP of the server";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 55132;
      description = "Port of the server";
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open the defined port in the firewall";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.soapy-remote = {
      description = "SoapyRemote server for streaming SDR data over the network";

      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} --bind=${cfg.host}:${toString cfg.port}";
        KillMode = "process";
        Restart = "on-failure";
        LimitRTPRIO = 99;
      };
      wantedBy = [ "multi-user.target" ];
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
      allowedUDPPorts = [ cfg.port ];
    };
  };
  meta.maintainers = with lib.maintainers; [ minionflo ];
}
