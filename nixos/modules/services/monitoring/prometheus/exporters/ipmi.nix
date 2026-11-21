{
  config,
  lib,
  pkgs,
  options,
  utils,
  ...
}:

let
  logPrefix = "services.prometheus.exporter.ipmi";
  cfg = config.services.prometheus.exporters.ipmi;
  enableInBand = cfg.inBandDevices != [ ];
  deviceUnits = map (device: "${utils.escapeSystemdPath device}.device") cfg.inBandDevices;
  inherit (lib)
    mkOption
    types
    concatStringsSep
    optionals
    escapeShellArg
    ;
in
{
  port = 9290;

  extraOpts = {
    inBandDevices = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "/dev/ipmi0" ];
      description = ''
        Paths to local IPMI devices the exporter may access. The service
        waits for every listed device to become ready before starting.
        Configure which devices to query separately in {option}`configFile`.
      '';
    };

    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to configuration file.
      '';
    };

    webConfigFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to configuration file that can enable TLS or authentication.
      '';
    };
  };

  # Device units become ready after udev has applied their access permissions.
  serviceOpts.after = deviceUnits ++ optionals enableInBand [ "modprobe@ipmi_devintf.service" ];
  serviceOpts.requires = deviceUnits;
  serviceOpts.wants = optionals enableInBand [ "modprobe@ipmi_devintf.service" ];

  serviceOpts.serviceConfig = {
    ExecStart =
      with cfg;
      concatStringsSep " " (
        [
          "${pkgs.prometheus-ipmi-exporter}/bin/ipmi_exporter"
          "--web.listen-address ${listenAddress}:${toString port}"
        ]
        ++ optionals (cfg.webConfigFile != null) [
          "--web.config.file ${escapeShellArg cfg.webConfigFile}"
        ]
        ++ optionals (cfg.configFile != null) [
          "--config.file ${escapeShellArg cfg.configFile}"
        ]
        ++ extraFlags
      );

    ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
    DeviceAllow = lib.mkIf enableInBand (map (device: "${device} rw") cfg.inBandDevices);
    PrivateDevices = lib.mkIf enableInBand false;
    RestrictAddressFamilies = [
      "AF_INET"
      "AF_INET6"
      "AF_UNIX"
    ];
    SupplementaryGroups = lib.mkIf enableInBand [ "ipmi-exporter-access" ];
  };
}
