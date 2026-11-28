{
  config,
  lib,
  options,
  pkgs,
  ...
}:

let
  cfg = config.services.prometheus.exporters.dcgm;

  inherit (lib)
    concatStringsSep
    escapeShellArg
    filterAttrs
    hasInfix
    hasPrefix
    mkDefault
    mkIf
    mkOption
    mkPackageOption
    optional
    optionals
    types
    ;

  # dcgm-exporter reads the metrics it collects from a CSV. Upstream ships a
  # curated default with most rows commented out; "all metrics" just uncomments
  # every DCGM_FI_*/DCGM_EXP_* row. Fields the GPU cannot serve are skipped at
  # runtime.
  defaultCounters = "${cfg.package}/share/dcgm-exporter/default-counters.csv";
  allCounters = pkgs.runCommand "dcgm-exporter-all-counters.csv" { } ''
    sed -E 's/^#[[:space:]]*(DCGM_(FI|EXP)_)/\1/' ${defaultCounters} > "$out"
  '';
  collectorsFile =
    if cfg.collectorsFile != null then
      cfg.collectorsFile
    else if cfg.enableAllMetrics then
      allCounters
    else
      defaultCounters;

  # --address takes <HOST>:<PORT>, with IPv6 literals bracketed. Bracket bare
  # IPv6 addresses ("::1"), but leave already-bracketed ones ("[::1]") alone.
  listenHost =
    if hasInfix ":" cfg.listenAddress && !hasPrefix "[" cfg.listenAddress then
      "[${cfg.listenAddress}]"
    else
      cfg.listenAddress;
  listenEndpoint = "${listenHost}:${toString cfg.port}";

  # DevicePolicy=closed denies every device not named here. Profiling (DCP)
  # metrics reach the driver through the capability device nodes under
  # /dev/nvidia-caps/* (the `char-nvidia-caps` class, a distinct device major),
  # so grant that class as well when, and only when, profiling is opted in.
  effectiveDeviceAllow =
    cfg.deviceAllow ++ optional cfg.profilingMetrics.enable "char-nvidia-caps rw";

  rl = cfg.resourceLimits;
  # Derive MemoryHigh (7/8) and GOMEMLIMIT (4/5) from the single memory ceiling
  # so all three scale together, preserving the order
  # GOMEMLIMIT < MemoryHigh < MemoryMax (Go GC, then soft throttle, then OOM).
  # The ~20% gap below the ceiling is headroom for CGO/NVML native allocations
  # the Go runtime does not account for.
  memoryHighMiB = rl.memoryMaxMiB * 7 / 8;
  goMemLimitMiB = rl.memoryMaxMiB * 4 / 5;
  resourceServiceConfig = lib.optionalAttrs rl.enable (
    filterAttrs (_: v: v != null) {
      MemoryHigh = "${toString memoryHighMiB}M";
      MemoryMax = "${toString rl.memoryMaxMiB}M";
      # Keep a latency-sensitive scrape target resident: no swap by default, so
      # under memory pressure it GCs (GOMEMLIMIT) rather than paging out.
      MemorySwapMax = if rl.allowSwap then null else "0";
      CPUQuota = rl.cpuQuota;
    }
  );
  resourceEnv = optionals rl.enable (
    [ "GOMEMLIMIT=${toString goMemLimitMiB}MiB" ]
    ++ optional (rl.goMaxProcs != null) "GOMAXPROCS=${toString rl.goMaxProcs}"
  );
in
{
  port = 9400;

  extraOpts = {
    package = mkPackageOption pkgs "prometheus-dcgm-exporter" { };

    user = mkOption {
      type = types.str;
      default = "root";
      description = ''
        User under which the exporter runs. dcgm-exporter runs its DCGM
        hostengine embedded in-process, which needs root to create the DCGM
        shared-memory segment, so the default is `root` (heavily sandboxed by
        the systemd settings this module applies). Non-root operation is
        possible for setups that do not collect profiling (DCP) metrics.

        Note that running as `root` does not by itself grant the privileges
        profiling metrics need: the framework empties `CapabilityBoundingSet`,
        so capabilities are dropped regardless of user. Use
        {option}`profilingMetrics.enable` to grant the required capability.
      '';
    };

    group = mkOption {
      type = types.str;
      default = "root";
      description = "Group under which the exporter runs.";
    };

    collectorsFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Counter-definition CSV passed to `--collectors`. When null, the
        exporter's bundled `default-counters.csv` is used, or the full metric
        set when {option}`enableAllMetrics` is true.
      '';
    };

    enableAllMetrics = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Collect every `DCGM_FI_*`/`DCGM_EXP_*` field instead of upstream's
        curated subset. Fields the GPU does not support are skipped at runtime.
        The profiling (`DCGM_FI_PROF_*`/DCP) fields additionally require the
        capability granted by {option}`profilingMetrics.enable`; without it they
        are requested but skipped. Ignored when {option}`collectorsFile` is set.
      '';
    };

    devices = mkOption {
      type = types.str;
      default = "f";
      example = "g:0,1";
      description = ''
        Value for the exporter's `--devices` flag selecting which GPUs / GPU
        instances to monitor. `f` (flex) monitors all GPUs, or all GPU
        instances when MIG is enabled.
      '';
    };

    collectInterval = mkOption {
      type = types.ints.positive;
      default = 30000;
      example = 15000;
      description = ''
        Interval, in milliseconds, at which metrics are collected from DCGM
        (`--collect-interval`). Set this at or below your Prometheus scrape
        interval so each scrape returns fresh samples.
      '';
    };

    enableExporterMetrics = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Expose Go runtime, process, and HTTP handler metrics about
        dcgm-exporter itself (`--enable-exporter-metrics`).
      '';
    };

    webConfigFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to an exporter-toolkit web-configuration file enabling TLS and/or
        basic authentication (`--web-config-file`). See
        <https://github.com/prometheus/exporter-toolkit/blob/master/docs/web-configuration.md>.
      '';
    };

    deviceAllow = mkOption {
      type = types.listOf types.str;
      default = [
        "char-nvidia rw"
        "char-nvidia-uvm rw"
      ];
      description = ''
        systemd `DeviceAllow` entries granting access to the NVIDIA device
        nodes. The defaults name the character-device classes `char-nvidia`
        (the GPU control/render nodes) and `char-nvidia-uvm` (unified memory);
        systemd resolves each name to its device major via `/proc/devices`, so a
        single entry covers every GPU of that class and they work on multi-GPU
        hosts without enumerating individual nodes. Add
        `char-nvidia-nvswitch`/`char-nvidia-nvlink` for NVSwitch/NVLink systems.
        Enabling {option}`profilingMetrics.enable` additionally grants
        `char-nvidia-caps` (the `/dev/nvidia-caps/*` nodes DCP metrics use), so
        it need not be listed here.
      '';
    };

    profilingMetrics.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Grant what DCGM profiling (`DCGM_FI_PROF_*`/DCP) metrics require: adds
        `CAP_SYS_ADMIN` to the service's capability bounding and ambient sets,
        and adds the `char-nvidia-caps` device class (the `/dev/nvidia-caps/*`
        nodes) to `DeviceAllow`, which `DevicePolicy=closed` would otherwise
        block. Off by default because it meaningfully widens the sandbox:
        `CAP_SYS_ADMIN` is broad, and consumer GPUs cannot serve these metrics
        anyway (only data-center GPUs with the DCGM profiling module can). Enable
        it only on supported hardware where you need profiling fields, together
        with {option}`enableAllMetrics` or a {option}`collectorsFile` that lists
        them.
      '';
    };

    resourceLimits = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Apply systemd resource guardrails (a memory ceiling plus matching Go
          runtime limits, and a CPU quota). The defaults are sized from a soak
          test of a single-GPU exporter under roughly 10,000x normal scrape
          load, so they are generous guard-rails rather than tuning. Multi-GPU/
          MIG hosts collect more metrics and should raise
          {option}`resourceLimits.memoryMaxMiB`.
        '';
      };

      memoryMaxMiB = mkOption {
        type = types.ints.positive;
        default = 256;
        example = 384;
        description = ''
          Hard memory ceiling in MiB, applied as systemd `MemoryMax` (the cgroup
          is OOM-killed above it). This is the single memory knob: `MemoryHigh`
          (the soft throttle, 7/8 of this) and `GOMEMLIMIT` (the Go heap target,
          4/5 of this) are derived from it so they scale together.

          The default leaves headroom for a single GPU with all counters enabled
          (a long-running exporter was observed to peak near 170 MiB). Raise it
          for multi-GPU/MIG hosts, Kubernetes enrichment, or debug dumps, and
          re-check against `systemctl status` peak memory (per-GPU overhead has
          not been measured here).
        '';
      };

      allowSwap = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether the service may use swap. Default false sets systemd
          `MemorySwapMax=0`, keeping this latency-sensitive scrape target
          resident in RAM so its pages are never paged out under `MemoryHigh`
          reclaim pressure. With swap disabled the effective guard-rail order is
          `GOMEMLIMIT` (Go GC) then `MemoryMax` (OOM), which is what bounds this
          Go workload anyway. Set true to permit swap (e.g. very memory-tight
          hosts that prefer paging to an OOM-kill). Only applies when
          {option}`resourceLimits.enable` is true.
        '';
      };

      cpuQuota = mkOption {
        type = types.nullOr types.str;
        default = "300%";
        example = "200%";
        description = "systemd `CPUQuota`. Null to leave unset.";
      };

      goMaxProcs = mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 4;
        description = "`GOMAXPROCS` for the Go runtime. Null to leave unset (use all CPUs).";
      };
    };
  };

  serviceOpts = {
    serviceConfig = {
      # Embedded hostengine needs root for its shared-memory segment; the
      # sandbox below pares the resulting privileges back down.
      DynamicUser = false;

      ExecStart = concatStringsSep " " (
        [
          "${cfg.package}/bin/dcgm-exporter"
          "--address=${listenEndpoint}"
          "--collectors=${collectorsFile}"
          "--devices=${escapeShellArg cfg.devices}"
          "--collect-interval=${toString cfg.collectInterval}"
          # NixOS keeps no ld.so.cache, so the exporter's ldconfig-based library
          # probe finds nothing and aborts; skip it (the binary links libdcgm
          # directly at build time).
          "--disable-startup-validate"
        ]
        ++ optional cfg.enableExporterMetrics "--enable-exporter-metrics"
        ++ optionals (cfg.webConfigFile != null) [ "--web-config-file=${cfg.webConfigFile}" ]
        ++ cfg.extraFlags
      );

      Environment = resourceEnv;

      # GPU access. NVML reads /proc/driver/nvidia/* so ProcSubset must stay
      # "all", and the NVIDIA userspace libraries may map W+X pages so
      # MemoryDenyWriteExecute is turned off.
      DevicePolicy = "closed";
      DeviceAllow = lib.mkOverride 50 effectiveDeviceAllow;
      PrivateDevices = lib.mkForce false;
      ProtectProc = "invisible";
      ProcSubset = "all";
      MemoryDenyWriteExecute = lib.mkForce false;

      # DCGM profiling (DCP) metrics need CAP_SYS_ADMIN. The framework empties
      # CapabilityBoundingSet via mkDefault, so running as root is not enough;
      # add the capability explicitly (bounding + ambient, so it also works for a
      # non-root user) only when the operator opts in.
      CapabilityBoundingSet = mkIf cfg.profilingMetrics.enable [ "CAP_SYS_ADMIN" ];
      AmbientCapabilities = mkIf cfg.profilingMetrics.enable [ "CAP_SYS_ADMIN" ];

      # The exporter talks to the kubelet/hostengine over AF_UNIX in addition to
      # the TCP metrics listener.
      RestrictAddressFamilies = [ "AF_UNIX" ];
      SystemCallFilter = [ "@system-service" ];
      SystemCallErrorNumber = "EPERM";
    }
    // resourceServiceConfig;

    # Restart when the effective collectors CSV or the web config changes.
    restartTriggers = [ collectorsFile ] ++ optional (cfg.webConfigFile != null) cfg.webConfigFile;
  };

  imports = [
    # Re-expose the global warnings/assertions options inside the exporter
    # submodule so this module can emit them (the framework's mkExporterConf
    # reads them back from the exporter's own config).
    (
      { config, ... }:
      {
        options.warnings = options.warnings;
        options.assertions = options.assertions;
        # Bind loopback by default rather than the framework's 0.0.0.0: GPU
        # metrics are sensitive and openFirewall=false is not the only thing
        # standing between them and the network (the host firewall may be off,
        # already permit the port, or local containers may reach it). Remote
        # scraping should select a management address explicitly.
        config.listenAddress = mkDefault "127.0.0.1";
        config.warnings = optional (config.openFirewall && config.webConfigFile == null) ''
          services.prometheus.exporters.dcgm has `openFirewall` enabled without
          `webConfigFile`, so GPU metrics are served unauthenticated over
          cleartext HTTP to every host allowed by the firewall. Set
          `webConfigFile` to enable TLS and/or basic auth, or reach the exporter
          over a trusted network only.
        '';
      }
    )
  ];
}
