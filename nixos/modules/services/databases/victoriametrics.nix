{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.victoriametrics;
in
{
  options.services.victoriametrics = with lib; {
    enable = mkEnableOption "VictoriaMetrics, a time series database, long-term remote storage for Prometheus";
    package = mkPackageOption pkgs "victoriametrics" { };
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
      default = [ ];
      description = ''
        Extra options to pass to VictoriaMetrics. See the README:
        <https://github.com/VictoriaMetrics/VictoriaMetrics/blob/master/README.md>
        or {command}`victoriametrics -help` for more
        information.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.victoriametrics = {
      description = "VictoriaMetrics time series database";
      after = [ "network.target" ];
      startLimitBurst = 5;
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 1;
        StateDirectory = "victoriametrics";
        DynamicUser = true;
        ExecStart = ''
          ${cfg.package}/bin/victoria-metrics \
              -storageDataPath=/var/lib/victoriametrics \
              -httpListenAddr ${cfg.listenAddress} \
              -retentionPeriod ${toString cfg.retentionPeriod} \
              ${lib.escapeShellArgs cfg.extraOptions}
        '';
        # victoriametrics 1.59 with ~7GB of data seems to eventually panic when merging files and then
        # begins restart-looping forever. Set LimitNOFILE= to a large number to work around this issue.
        #
        # panic: FATAL: unrecoverable error when merging small parts in the partition "/var/lib/victoriametrics/data/small/2021_08":
        # cannot open source part for merging: cannot open values file in stream mode:
        # cannot open file "/var/lib/victoriametrics/data/small/2021_08/[...]/values.bin":
        # open /var/lib/victoriametrics/data/small/2021_08/[...]/values.bin: too many open files
        LimitNOFILE = 1048576;
      };
      wantedBy = [ "multi-user.target" ];

      postStart =
        let
          bindAddr =
            (lib.optionalString (lib.hasPrefix ":" cfg.listenAddress) "127.0.0.1") + cfg.listenAddress;
        in
        lib.mkBefore ''
          until ${lib.getBin pkgs.curl}/bin/curl -s -o /dev/null http://${bindAddr}/ping; do
            sleep 1;
          done
        '';
    };
  };
}
