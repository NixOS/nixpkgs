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
    enable = lib.mkEnableOption ''
      Whether to enable SCX Loader service, a daemon to run schedulers from userspace using dbus.

      ::: {.note}
      This service requires a kernel with the Sched-ext feature.
      Generally, kernel version 6.12 and later are supported.
      :::
    '';

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.scx.loader;
      defaultText = lib.literalExpression "pkgs.scx.loader";
      description = ''
        SCX Loader Package which is a system daemon and DBus-based loader for sched_ext schedulers
        It provides `scxctl` a command-line client for interacting with the loader, allowing users to switch schedulers, modes, and arguments dynamically.
      '';
    };

    schedsPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ pkgs.scx.full ];
      defaultText = lib.literalExpression "[ pkgs.scx.full ]";
      example = lib.literalExpression "[ pkgs.scx.rustscheds ]";
      description = ''
        `scx` package to use. `scx.full`, which includes all schedulers, is the default.
        You may choose a minimal package, such as `pkgs.scx.rustscheds`.

        ::: {.note}
        Overriding this does not change the default scheduler; you should set `services.scx-loader.config.default_scheduler` for it.
        :::
      '';
    };

    config = lib.mkOption {
      inherit (settingsFormat) type;
      description = ''
        Configuration for SCX Loader in the TOML format
        Example Config: https://github.com/sched-ext/scx-loader/blob/main/configs/scx_loader.toml
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ] ++ cfg.schedsPackages;
      etc."scx_loader.toml".source = settingsFormat.generate "scx_loader.toml" cfg.config;
    };

    assertions = [
      {
        assertion = lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.12";
        message = "SCX is only supported on kernel version >= 6.12.";
      }
      {
        assertion = !(cfg.enable && config.services.scx_loader.enable);
        message = "services.scx and services.scx_loader cannot be enabled simultaneously. Please enable only one.";
      }
    ];

    systemd.services.scx-loader = {
      description = "DBUS on-demand loader of sched-ext schedulers";

      unitConfig.ConditionPathIsDirectory = "/sys/kernel/sched_ext";

      serviceConfig = {
        Type = "dbus";
        BusName = "org.scx.Loader";
        ExecStart = lib.getExe cfg.package;
      };

      path = cfg.schedsPackages;

      wantedBy = [ "multi-user.target" ];
    };
  };
}
