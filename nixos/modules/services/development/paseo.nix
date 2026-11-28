{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.paseo;

  settingsFormat = pkgs.formats.json { };
  settingsFile = settingsFormat.generate "paseo-config.json" cfg.settings;

  inherit (lib)
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;
in
{
  options.services.paseo = {
    enable = mkEnableOption "Paseo, a daemon that orchestrates coding agents";

    package = mkPackageOption pkgs "paseo" { };

    user = mkOption {
      type = types.str;
      default = "paseo";
      description = ''
        User account under which Paseo and the agents it spawns run.

        Agents read and write the repositories they work on as this user,
        so set it to your own account to let them work in your home directory.
        The `paseo` user is only created when this option is left at its default.
      '';
    };

    group = mkOption {
      type = types.str;
      default = "paseo";
      description = ''
        Group under which Paseo runs.
        The `paseo` group is only created when this option is left at its default.
      '';
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/paseo";
      description = ''
        Directory for Paseo state ({env}`PASEO_HOME`), holding agent data,
        `config.json` and logs.
      '';
    };

    listenAddress = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "Address the Paseo daemon binds to.";
    };

    port = mkOption {
      type = types.port;
      default = 6767;
      description = "Port the Paseo daemon listens on.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open [](#opt-services.paseo.port) in the firewall.";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = literalExpression "[ pkgs.claude-code pkgs.codex ]";
      description = ''
        Packages added to the service's {env}`PATH`, such as the coding agent
        CLIs Paseo launches and the tools those agents need.
        `bash`, `git` and `procps` are always included.
      '';
    };

    settings = mkOption {
      type = settingsFormat.type;
      default = { };
      example = {
        daemon = {
          hostnames = [ ".example.com" ];
          relay.enabled = false;
        };
      };
      description = ''
        Configuration written to {file}`config.json` in
        [](#opt-services.paseo.dataDir) on every service start.
        See `PersistedConfigSchema` in the
        [Paseo source](https://github.com/getpaseo/paseo/blob/main/packages/server/src/server/persisted-config.ts)
        for the available options.

        When this option is set, changes made at runtime through the CLI or
        the apps are lost on the next restart.
        The listen address is set by [](#opt-services.paseo.listenAddress)
        and [](#opt-services.paseo.port), which take precedence over `daemon.listen`.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/paseo.env";
      description = ''
        Environment file as defined in {manpage}`systemd.exec(5)`.
        Use it for secrets such as {env}`PASEO_PASSWORD`, which would
        otherwise be world-readable in the Nix store.
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users = mkIf (cfg.user == "paseo") {
      paseo = {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.dataDir;
      };
    };

    users.groups = mkIf (cfg.group == "paseo") { paseo = { }; };

    systemd.tmpfiles.settings.paseo.${cfg.dataDir}.d = {
      inherit (cfg) user group;
      mode = "0700";
    };

    systemd.services.paseo = {
      description = "Paseo coding agent daemon";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      path = [
        pkgs.bash
        pkgs.git
        # The terminal worker identifies its own processes with ps.
        pkgs.procps
      ]
      ++ cfg.extraPackages;

      environment = {
        PASEO_HOME = cfg.dataDir;
        PASEO_LISTEN = "${cfg.listenAddress}:${toString cfg.port}";
      };

      preStart = mkIf (cfg.settings != { }) ''
        install -m 0600 ${settingsFile} ${cfg.dataDir}/config.json
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = mkIf (cfg.environmentFile != null) cfg.environmentFile;
        ExecStart = lib.getExe' cfg.package "paseo-server";
        Restart = "on-failure";
        RestartSec = 5;
        # The daemon forces its own exit 10 seconds after SIGTERM.
        TimeoutStopSec = 15;
      };
    };

    environment.systemPackages = [ cfg.package ];

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];
  };

  meta.maintainers = with lib.maintainers; [ chansuke ];
}
