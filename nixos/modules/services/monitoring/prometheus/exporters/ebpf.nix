{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.ebpf;
  inherit (lib)
    mkOption
    types
    concatStringsSep
    ;
in
{
  port = 9435;
  extraOpts = {
    names = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "timers" ];
      description = ''
        List of eBPF programs to load
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      AmbientCapabilities = [
        "CAP_BPF"
        "CAP_DAC_READ_SEARCH"
        "CAP_PERFMON"
      ];
      CapabilityBoundingSet = [
        "CAP_BPF"
        "CAP_DAC_READ_SEARCH"
        "CAP_PERFMON"
      ];
      ExecStart = ''
        ${pkgs.prometheus-ebpf-exporter}/bin/ebpf_exporter \
        --config.dir=${pkgs.prometheus-ebpf-exporter}/examples \
        --config.names=${concatStringsSep "," cfg.names} \
        --web.listen-address ${cfg.listenAddress}:${toString cfg.port}
      '';
    };
  };
}
