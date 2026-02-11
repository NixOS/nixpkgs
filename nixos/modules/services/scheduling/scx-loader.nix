{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.scx-loader;
  settingsFormat = pkgs.formats.toml { };
in
{
  options.services.scx-loader = {
    enable = lib.mkEnableOption "" // {
      description = ''
        Whether to enable SCX Loader service, a daemon to run schedulers from userspace using dbus.

        ::: {.note}
        This service requires a kernel with the Sched-ext feature.
        Generally, kernel version 6.12 and later are supported.
        :::
      '';
    };

    package = lib.mkPackageOption pkgs "scx.loader" { };

    schedsPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ pkgs.scx.rustscheds ];
      defaultText = lib.literalExpression "[ pkgs.scx.rustscheds ]";
      example = lib.literalExpression "[ pkgs.scx.full ]";
      description = ''
        `scx` package to use. `scx.rustscheds`, which includes all schedulers currently supported by `scx_loader`, is the default.

        ::: {.note}
        Overriding this does not change the default scheduler; you should set `services.scx-loader.settings.default_sched` for it.
        :::
      '';
    };

    settings = lib.mkOption {
      inherit (settingsFormat) type;
      default = { };
      description = ''
        Configuration for SCX Loader in the TOML format
        See the [example config](https://github.com/sched-ext/scx-loader/blob/main/configs/scx_loader.toml) for more details.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.12";
        message = "SCX is only supported on kernel version >= 6.12.";
      }
      {
        assertion = !(cfg.enable && config.services.scx.enable);
        message = "services.scx and services.scx_loader cannot be enabled simultaneously. Please enable only one of them.";
      }
    ];

    environment = {
      systemPackages = [ cfg.package ] ++ cfg.schedsPackages;
      etc = lib.mkIf (cfg.settings != { }) {
        "scx_loader.toml".source = settingsFormat.generate "scx_loader.toml" cfg.settings;
      };
    };

    systemd.services.scx-loader = {
      description = "DBUS on-demand loader of sched-ext schedulers";

      unitConfig.ConditionPathIsDirectory = "/sys/kernel/sched_ext";

      serviceConfig = {
        Type = "dbus";
        BusName = "org.scx.Loader";
        ExecStart = lib.getExe cfg.package;
        KillSignal = "SIGINT";
        ProtectSystem = "full";
        PrivateTmp = "disconnected";
        PrivateMounts = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        LockPersonality = true;
        RestrictRealtime = true;
        ProtectClock = true;
        MemoryDenyWriteExecute = true;
        RestrictAddressFamilies = "AF_UNIX";
        CapabilityBoundingSet = "~CAP_BLOCK_SUSPEND CAP_CHOWN CAP_MKNOD CAP_NET_RAW CAP_SYS_BOOT CAP_SYS_CHROOT CAP_SYS_MODULE CAP_SYS_PACCT CAP_SYS_PTRACE CAP_SYS_TIME CAP_SYSLOG CAP_WAKE_ALARM";
        SocketBindDeny = [
          "ipv4:tcp"
          "ipv4:udp"
          "ipv6:tcp"
          "ipv6:udp"
        ];
        SystemCallFilter = [
          "~@aio:EPERM @chown:EPERM @clock:EPERM @cpu-emulation:EPERM @debug:EPERM @keyring:EPERM @module:EPERM @mount:EPERM @obsolete:EPERM @pkey:EPERM @raw-io:EPERM @reboot:EPERM @setuid:EPERM @swap:EPERM @sync:EPERM @timer:EPERM"
          "perf_event_open"
        ];
      };

      path = cfg.schedsPackages;

      wantedBy = [ "multi-user.target" ];
    };
  };

  meta = {
    inherit (pkgs.scx.loader.meta) maintainers;
  };
}
