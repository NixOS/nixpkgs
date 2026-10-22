{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.scx-loader;
  settingsFormat = pkgs.formats.toml { };
  configFile = settingsFormat.generate "scx_loader.toml" (
    lib.filterAttrsRecursive (_: v: v != null) cfg.config
  );

  schedulers = builtins.concatMap (
    x: x.passthru.schedulers or (throw "Scheduler not found in package ${x.name}")
  ) cfg.schedsPackages;
in
{
  options.services.scx-loader = {
    enable = lib.mkEnableOption "SCX Loader service, a daemon to run schedulers from userspace using dbus. This requires kernel version 6.12 and later.";

    package = lib.mkPackageOption pkgs "scx-loader" { };

    schedsPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ pkgs.scx.rustscheds ];
      defaultText = lib.literalExpression "[ pkgs.scx.rustscheds ]";
      example = lib.literalExpression "[ pkgs.scx.full ]";
      description = ''
        `scx` package to use. Defaults to `scx.rustscheds`, which includes all currently by `scx_loader` supported schedulers.
      '';
    };

    config = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        options = {
          default_sched = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "scx_bpfland";
            description = ''
              Default scheduler that will be started automatically when `scx_loader` starts.
              If not set or set to an empty string, `scx_loader` will not start any scheduler by default.
            '';
          };
        };
      };
      default = { };
      description = ''
        Configuration for `scx_loader`.

        See <https://github.com/sched-ext/scx-loader/blob/main/crates/scx_loader/configuration.md> for the full list of options.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.12";
        message = "SCX is only supported on kernel version 6.12 and above.";
      }
      {
        assertion = !config.services.scx.enable;
        message = "services.scx and services.scx_loader cannot be enabled simultaneously. Please enable only one of them.";
      }
      {
        assertion =
          cfg.config.default_sched == null || lib.elem cfg.config.default_sched ([ "" ] ++ schedulers);
        message = ''
          Invalid default scheduler: ${cfg.config.default_sched}. It must be one of: ${lib.concatStringsSep ", " schedulers}.
        '';
      }
    ];

    environment = {
      systemPackages = [ cfg.package ] ++ cfg.schedsPackages;
      etc."scx_loader.toml".source = configFile;
    };

    systemd.packages = [ cfg.package ];
    services.dbus.packages = [ cfg.package ];

    security.polkit.enable = true;

    systemd.services.scx_loader = {
      path = cfg.schedsPackages;
      wantedBy = [ "multi-user.target" ];
    };
  };

  meta.maintainers = with lib.maintainers; [ ccicnce113424 ];
}
