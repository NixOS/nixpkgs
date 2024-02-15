{ config, pkgs, lib, ... }:

let
  cfg = config.services.v2raya;
  inherit (lib.options) mkOption mkEnableOption mkPackageOption;
  inherit (lib) types maintainers mkIf optionals getExe literalExpression;
in
{
  options = {
    services.v2raya = {
      enable = mkEnableOption "the v2rayA service";

      package = mkPackageOption pkgs "v2raya" { };

      listenAddress = mkOption {
        type = types.str;
        default = "0.0.0.0";
        example = "127.0.0.1";
        description = ''
          The listening address of v2rayA.
        '';
      };

      listenPort = mkOption {
        type = types.port;
        default = 2017;
        description = ''
          The listening port of v2rayA.
        '';
      };

      configPath = mkOption {
        type = types.path;
        default = "/etc/v2raya";
        description = ''
          The directory containing the configuration file of
          v2rayA.
        '';
      };

      v2rayPath = mkOption {
        type = with types; nullOr path;
        default = null;
        example = literalExpression ''"''${pkgs.xray}/bin/xray"'';
        description = ''
          v2ray executable file path. If set to `null`, will
          use v2ray provided in v2rayA wrapper. It can be
          modified to the file path of other v2ray branches
          such as xray.
        '';
      };

      logFile = mkOption {
        type = types.path;
        default = "/var/log/v2raya/v2raya.log";
        description = ''
          The path of v2rayA log file.
        '';
      };

      environment = mkOption {
        type = types.attrsOf lib.types.str;
        default = { };
        example = literalExpression ''
          {
            V2RAYA_PLUGINLISTENPORT = "32346";
            V2RAYA_PASSCHECKROOT = "1";
            V2RAYA_FORCE_IPV6_ON = "1";
          }
        '';
        description = ''
          Environment variables added to v2raya systemd service.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.v2raya = {
      unitConfig = {
        Description = "v2rayA service";
        Documentation = "https://github.com/v2rayA/v2rayA/wiki";
        After = [
          "network.target"
          "network-online.target"
          "nss-lookup.target"
          "iptables.service"
          "ip6tables.service"
          "nftables.service"
        ];
        Wants = [ "network.target" ];
      };

      serviceConfig = {
        User = "root";
        ExecStart = "${getExe cfg.package} --log-disable-timestamp";
        LimitNPROC = 500;
        LimitNOFILE = 1000000;
        Restart = "on-failure";
        Type = "simple";
      };

      environment = {
        V2RAYA_ADDRESS = "${cfg.listenAddress}:${toString cfg.listenPort}";
        V2RAYA_CONFIG = cfg.configPath;
        V2RAYA_V2RAY_BIN = cfg.v2rayPath;
        V2RAYA_LOG_FILE = cfg.logFile;
      } // cfg.environment;

      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [ iptables bash iproute2 ]; # required by v2rayA TProxy functionality
    };
  };

  meta.maintainers = with maintainers; [ elliot ];
}
