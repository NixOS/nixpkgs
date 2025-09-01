{
  lib,
  pkgs,
  config,
  utils,
  ...
}:
let
  cfg = config.services.scx;
in
{
  options.services.scx = {
    enable = lib.mkEnableOption null // {
      description = ''
        Whether to enable SCX service, a daemon to run schedulers from userspace.

        ::: {.note}
        This service requires a kernel with the Sched-ext feature.
        Generally, kernel version 6.12 and later are supported.
        :::
      '';
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.scx.full;
      defaultText = lib.literalExpression "pkgs.scx.full";
      example = lib.literalExpression "pkgs.scx.rustscheds";
      description = ''
        `scx` package to use. `scx.full`, which includes all schedulers, is the default.
        You may choose a minimal package, such as `pkgs.scx.rustscheds`.

        ::: {.note}
        Overriding this does not change the default scheduler; you should set `services.scx.scheduler` for it.
        :::
      '';
    };

    scheduler = lib.mkOption {
      type = lib.types.enum [
        "scx_bpfland"
        "scx_chaos"
        "scx_cosmos"
        "scx_central"
        "scx_flash"
        "scx_flatcg"
        "scx_lavd"
        "scx_layered"
        "scx_mitosis"
        "scx_nest"
        "scx_p2dq"
        "scx_pair"
        "scx_prev"
        "scx_qmap"
        "scx_rlfifo"
        "scx_rustland"
        "scx_rusty"
        "scx_sdt"
        "scx_simple"
        "scx_tickless"
        "scx_userland"
        "scx_wd40"
      ];
      default = "scx_rustland";
      example = "scx_bpfland";
      description = ''
        Which scheduler to use. See [SCX documentation](https://github.com/sched-ext/scx/tree/main/scheds)
        for details on each scheduler and guidance on selecting the most suitable one.
      '';
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.singleLineStr;
      default = [ ];
      example = [
        "--slice-us 5000"
        "--verbose"
      ];
      description = ''
        Parameters passed to the chosen scheduler at runtime.

        ::: {.note}
        Run `chosen-scx-scheduler --help` to see the available options. Generally,
        each scheduler has its own set of options, and they are incompatible with each other.
        :::
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.scx = {
      description = "SCX scheduler daemon";

      # SCX service should be started only if the kernel supports sched-ext
      unitConfig.ConditionPathIsDirectory = "/sys/kernel/sched_ext";

      startLimitIntervalSec = 30;
      startLimitBurst = 2;

      serviceConfig = {
        Type = "simple";
        ExecStart = utils.escapeSystemdExecArgs (
          [
            (lib.getExe' cfg.package cfg.scheduler)
          ]
          ++ cfg.extraArgs
        );
        Restart = "on-failure";
      };

      wantedBy = [ "multi-user.target" ];
    };

    assertions = [
      {
        assertion = lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.12";
        message = "SCX is only supported on kernel version >= 6.12.";
      }
    ];
  };

  meta = {
    inherit (pkgs.scx.full.meta) maintainers;
  };
}
