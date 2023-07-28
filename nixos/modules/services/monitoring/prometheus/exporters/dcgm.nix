{
  config,
  lib,
  options,
  pkgs,
}:
with lib; let
  cfg = config.services.prometheus.exporters.dcgm;
in {
  port = 9400;
  extraOpts = {
    collectors = mkOption {
      type = types.path;
      default = "${pkgs.prometheus-dcgm-exporter}/share/etc/dcgm-exporter/default-counters.csv";
      defaultText = literalExpression ''
        ''${pkgs.prometheus-dcgm-exporter}/share/etc/dcgm-exporter/default-counters.csv
      '';
      example = literalExpression ''
        ''${pkgs.prometheus-dcgm-exporter}/share/etc/dcgm-exporter/1.x-compatability-metrics.csv
      '';
      description = lib.mdDoc ''
        Path to file containing DCGM fields to collect.
      '';
    };
    address = mkOption {
      type = types.str;
      default = "localhost";
      description = lib.mdDoc ''
        Address of listening http server.
      '';
    };
    collectInterval = mkOption {
      type = types.ints.unsigned;
      default = 30000;
      description = lib.mdDoc ''
        Interval of time at which point metrics are collected. Unit is milliseconds.
      '';
    };
    kubernetes = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Enable kubernetes mapping metrics to kubernetes pods.
      '';
    };
    useOldNamespace = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Use old 1.x namespace.
      '';
    };
    configmapData = mkOption {
      type = types.str;
      default = "none";
      description = lib.mdDoc ''
        ConfigMap namespace and name containing DCGM fields to collect.
      '';
    };
    remoteHostengineInfo = mkOption {
      type = types.str;
      default = "${config.services.dcgm.bindInterface}:${toString config.services.dcgm.port}";
      defaultText = literalExpression ''
        ''${config.services.dcgm.bindInterface}:''${toString config.services.dcgm.port}
      '';
      description = lib.mdDoc ''
        Connect to remote hostengine at `Host:Port`.
      '';
    };
    kubernetesGpuIdType = mkOption {
      type = types.enum ["uid" "device-name"];
      default = "uid";
      description = lib.mdDoc ''
        Choose Type of GPU ID to use to map kubernetes resources to pod.
      '';
    };
    devices = mkOption {
      type = types.str;
      default = "f";
      description = lib.mdDoc ''
        Specify which devices dcgm-exporter monitors.

        Possible values:

        - `f` or
        - `g[:id1[,-id2...]` or
        - `i[:id1[,-id2...]`.

        If an `id` list is used, then devices with match IDs must exist on the system. For example:

        - `g` = Monitor all GPUs
        - `i` = Monitor all GPU instances
        - `f` = Monitor all GPUs if MIG is disabled, or all GPU instances if MIG is enabled.

        Note: this rule will be applied to each GPU. If it has GPU instances, those will be monitored. If it doesn't, then the GPU will be monitored.

        This is our recommended option for single or mixed MIG Strategies.

        - `g:0,1` = monitor GPUs 0 and 1
        - `i:0,2-4` = monitor GPU instances 0, 2, 3, and 4.

        NOTE 1: `-i` cannot be specified unless MIG mode is enabled.

        NOTE 2: Any time indices are specified, those indices must exist on the system.

        NOTE 3: In MIG mode, only `-f` or `-i` with a range can be specified. GPUs are not assigned to pods and therefore reporting must occur at the GPU instance level.
      '';
    };
    noHostname = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Omit the hostname information from the output, matching older versions.
      '';
    };
    switchDevices = mkOption {
      type = types.str;
      default = "f";
      description = lib.mdDoc ''
        Specify which devices dcgm-exporter monitors.

        Possible values:

        - `f` or
        - `g[:id1[,-id2...]` or
        - `i[:id1[,-id2...]`.

        If an `id` list is used, then devices with match IDs must exist on the system. For example:

        - `g` = Monitor all GPUs
        - `i` = Monitor all GPU instances
        - `f` = Monitor all GPUs if MIG is disabled, or all GPU instances if MIG is enabled.

        Note: this rule will be applied to each GPU. If it has GPU instances, those will be monitored. If it doesn't, then the GPU will be monitored.

        This is our recommended option for single or mixed MIG Strategies.

        - `g:0,1` = monitor GPUs 0 and 1
        - `i:0,2-4` = monitor GPU instances 0, 2, 3, and 4.

        NOTE 1: `-i` cannot be specified unless MIG mode is enabled.

        NOTE 2: Any time indices are specified, those indices must exist on the system.

        NOTE 3: In MIG mode, only `-f` or `-i` with a range can be specified. GPUs are not assigned to pods and therefore reporting must occur at the GPU instance level.
      '';
    };
    fakeGpus = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Accept GPUs that are fake, for testing purposes only.
      '';
    };
  };
  serviceOpts.serviceConfig = {
    AmbientCapabilities = ["CAP_SYS_ADMIN"];
    CapabilityBoundingSet = ["CAP_SYS_ADMIN"];
    ExecStart = ''
      ${lib.getExe pkgs.prometheus-dcgm-exporter} \
        --collectors ${cfg.collectors} \
        --address ${cfg.address}:${toString cfg.port} \
        --collect-interval ${toString cfg.collectInterval} \
        --kubernetes ${lib.boolToString cfg.kubernetes} \
        --use-old-namespace ${lib.boolToString cfg.useOldNamespace} \
        --configmap-data ${cfg.configmapData} \
        --remote-hostengine-info ${cfg.remoteHostengineInfo} \
        --kubernetes-gpu-id-type ${cfg.kubernetesGpuIdType} \
        --devices ${cfg.devices} \
        --no-hostname ${lib.boolToString cfg.noHostname} \
        --switch-devices ${cfg.switchDevices} \
        --fake-gpus ${lib.boolToString cfg.fakeGpus}
    '';
  };
}
