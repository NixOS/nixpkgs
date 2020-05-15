{ config, pkgs, lib, ... }:
let cfg = config.services.victoriametrics; in
{
  options.services.victoriametrics = with lib; {
    enable = mkEnableOption "victoriametrics";
    package = mkOption {
      type = types.package;
      default = pkgs.victoriametrics;
      defaultText = "pkgs.victoriametrics";
      description = ''
        The VictoriaMetrics distribution to use.
      '';
    };
    listenAddress = mkOption {
      default = ":8428";
      type = types.str;
      description = ''
        The listen address for the http interface.
      '';
    };
    retentionPeriod = mkOption {
      type = types.int;
      default = 1;
      description = ''
        Retention period in months.
      '';
    };
    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        Extra options to pass to VictoriaMetrics. See the README: <link
        xlink:href="https://github.com/VictoriaMetrics/VictoriaMetrics/blob/master/README.md" />
        or <command>victoriametrics -help</command> for more
        information.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.victoriametrics = {
      description = "VictoriaMetrics time series database";
      after = [ "network.target" ];
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 1;
        StartLimitBurst = 5;
        StateDirectory = "victoriametrics";
        DynamicUser = true;
        ExecStart = ''
          ${cfg.package}/bin/victoria-metrics \
              -storageDataPath=/var/lib/victoriametrics \
              -httpListenAddr ${cfg.listenAddress}
              -retentionPeriod ${toString cfg.retentionPeriod}
              ${lib.escapeShellArgs cfg.extraOptions}
        '';
      };
      wantedBy = [ "multi-user.target" ];

      postStart =
        let
          bindAddr = (lib.optionalString (lib.hasPrefix ":" cfg.listenAddress) "127.0.0.1") + cfg.listenAddress;
        in
        lib.mkBefore ''
          until ${lib.getBin pkgs.curl}/bin/curl -s -o /dev/null http://${bindAddr}/ping; do
            sleep 1;
          done
        '';
    };
  };
}
