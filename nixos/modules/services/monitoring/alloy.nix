{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.services.alloy;
in
{
  meta = {
    maintainers = with maintainers; [
      flokli
      hbjydev
    ];
  };

  options.services.alloy = {
    enable = mkEnableOption "Grafana Alloy";

    package = mkPackageOption pkgs "grafana-alloy" { };

    configPath = mkOption {
      type = lib.types.path;
      default = "/etc/alloy";
      description = ''
        Alloy configuration file/directory path.

        We default to `/etc/alloy` here, and expect the user to configure a
        configuration file via `environment.etc."alloy/config.alloy"`.

        This allows config reload, contrary to specifying a store path.
        A `reloadTrigger` for `config.alloy` is configured.

        Other `*.alloy` files in the same directory (ignoring subdirs) are also
        honored, but it's necessary to manually extend
        `systemd.services.alloy.reloadTriggers` to enable config reload
        during nixos-rebuild switch.

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

    extraFlags = mkOption {
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

  config = mkIf cfg.enable {
    systemd.services.alloy = {
      wantedBy = [ "multi-user.target" ];
      reloadTriggers = [ config.environment.etc."alloy/config.alloy".source or null ];
      serviceConfig = {
        Restart = "always";
        DynamicUser = true;
        RestartSec = 2;
        SupplementaryGroups = [
          # allow to read the systemd journal for loki log forwarding
          "systemd-journal"
        ];
        ExecStart = "${lib.getExe cfg.package} run ${cfg.configPath} ${escapeShellArgs cfg.extraFlags}";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGHUP $MAINPID";
        ConfigurationDirectory = "alloy";
        StateDirectory = "alloy";
        WorkingDirectory = "%S/alloy";
        Type = "simple";
      };
    };
  };
}
