{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.prometheus.exporters.chrony;
  inherit (lib)
    mkOption
    types
    concatStringsSep
    concatMapStringsSep
    ;
in
{
  port = 9123;
  extraOpts = {
    chronyServerAddress = mkOption {
      type = types.str;
      default = "unix:///run/chrony/chronyd.sock";
      example = [ "192.82.0.1:323" ];
      description = ''
        ChronyServerAddress of the chrony server side command port. (Not enabled by default.)
        Defaults to the local unix socket.
      '';
    };
    user = mkOption {
      type = types.str;
      default = "chrony";
      description = ''
        User name under which the chrony exporter shall be run.
        This allows the exporter to talk to chrony using a unix socket, which is owned by chrony.
        The exporter startup with the default user chrony will fail without local chrony instance.
      '';
    };
    group = mkOption {
      type = types.str;
      default = "chrony";
      description = ''
        Group under which the chrony exporter shall be run.
        This allows the exporter to talk to chrony using a unix socket, which is owned by chrony group.
        The service startup with the default group chrony will fail without local chrony instance.
      '';
    };
    enabledCollectors = mkOption {
      type = types.listOf types.str;
      default = [
        "tracking"
        "sources"
        "sources.with-ntpdata"
        "serverstats"
        "dns-lookups"
      ];
      example = [ "dns-lookups" ];
      description = ''
        Collectors to enable.
        Currently all collectors are enabled by default.
      '';
    };
    disabledCollectors = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "sources.with-ntpdata" ];
      description = ''
        Collectors to disable which are enabled by default.
        Disable sources.with-ntpdata for network scraper. Option requires unix socket.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
      CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      ProtectClock = true;
      ProtectSystem = "strict";
      Restart = "on-failure";
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
        "AF_UNIX"
      ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      ExecStart = ''
        ${lib.getExe pkgs.prometheus-chrony-exporter} \
          ${concatMapStringsSep " " (x: "--collector." + x) cfg.enabledCollectors} \
          ${concatMapStringsSep " " (x: "--no-collector." + x) cfg.disabledCollectors} \
          --chrony.address ${cfg.chronyServerAddress} \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          ${concatStringsSep " " cfg.extraFlags}
      '';
    };
  };
}
