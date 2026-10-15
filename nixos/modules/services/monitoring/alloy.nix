{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.alloy;
in
{
  meta = {
    maintainers = with lib.maintainers; [
      flokli
      hbjydev
    ];
  };

  options.services.alloy = {
    enable = lib.mkEnableOption "Grafana Alloy";

    package = lib.mkPackageOption pkgs "grafana-alloy" { };

    configPath = lib.mkOption {
      type = lib.types.path;
      default = "/etc/alloy";
      description = ''
        Alloy configuration file/directory path.

        We default to `/etc/alloy` here, and expect the user to configure a
        configuration file via `environment.etc."alloy/config.alloy"`.

        This allows config reload, contrary to specifying a store path.

        All `.alloy` files in the same directory (ignoring subdirs) are also
        honored and are added to `systemd.services.alloy.reloadTriggers` to
        enable config reload during nixos-rebuild switch.

        This can also point to another directory containing `*.alloy` files, or
        a single Alloy file in the Nix store (at the cost of reload).

        Component names must be unique across all Alloy configuration files, and
        configuration blocks must not be repeated.

        Alloy will continue to run if subsequent reloads of the configuration
        file fail, potentially marking components as unhealthy depending on
        the nature of the failure. When this happens, Alloy will continue
        functioning in the last valid state.
      '';
    };

    environmentFile = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      example = "/run/secrets/alloy.env";
      description = ''
        EnvironmentFile as defined in {manpage}`systemd.exec(5)`.
      '';
    };

    extraFlags = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      example = [
        "--server.http.listen-addr=127.0.0.1:12346"
        "--disable-reporting"
      ];
      description = ''
        Extra command-line flags passed to {command}`alloy run`.

        See <https://grafana.com/docs/alloy/latest/reference/cli/run/>
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.alloy = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      reloadTriggers = lib.mapAttrsToList (_: v: v.source or null) (
        lib.filterAttrs (n: _: lib.hasPrefix "alloy/" n && lib.hasSuffix ".alloy" n) config.environment.etc
      );
      serviceConfig = {
        Restart = "always";
        DynamicUser = true;
        RestartSec = 2;
        SupplementaryGroups = [
          # allow to read the systemd journal for loki log forwarding
          "systemd-journal"
        ];
        ExecStart = "${lib.getExe cfg.package} run ${cfg.configPath} ${lib.escapeShellArgs cfg.extraFlags}";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGHUP $MAINPID";
        ConfigurationDirectory = "alloy";
        StateDirectory = "alloy";
        WorkingDirectory = "%S/alloy";
        Type = "simple";
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
      };
    };
  };
}
