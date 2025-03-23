{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.collectd;

  baseDirLine = ''BaseDir "${cfg.dataDir}"'';
  unvalidated_conf = pkgs.writeText "collectd-unvalidated.conf" cfg.extraConfig;

  conf =
    if cfg.validateConfig then
      pkgs.runCommand "collectd.conf" { } ''
        echo testing ${unvalidated_conf}
        cp ${unvalidated_conf} collectd.conf
        # collectd -t fails if BaseDir does not exist.
        substituteInPlace collectd.conf --replace ${lib.escapeShellArgs [ baseDirLine ]} 'BaseDir "."'
        ${package}/bin/collectd -t -C collectd.conf
        cp ${unvalidated_conf} $out
      ''
    else
      unvalidated_conf;

  package = if cfg.buildMinimalPackage then minimalPackage else cfg.package;

  minimalPackage = cfg.package.override {
    enabledPlugins = [ "syslog" ] ++ builtins.attrNames cfg.plugins;
  };

in
{
  options.services.collectd = with lib.types; {
    enable = lib.mkEnableOption "collectd agent";

    validateConfig = lib.mkOption {
      default = true;
      description = ''
        Validate the syntax of collectd configuration file at build time.
        Disable this if you use the Include directive on files unavailable in
        the build sandbox, or when cross-compiling.
      '';
      type = types.bool;
    };

    package = lib.mkPackageOption pkgs "collectd" { };

    buildMinimalPackage = lib.mkOption {
      default = false;
      description = ''
        Build a minimal collectd package with only the configured `services.collectd.plugins`
      '';
      type = bool;
    };

    user = lib.mkOption {
      default = "collectd";
      description = ''
        User under which to run collectd.
      '';
      type = nullOr str;
    };

    dataDir = lib.mkOption {
      default = "/var/lib/collectd";
      description = ''
        Data directory for collectd agent.
      '';
      type = path;
    };

    autoLoadPlugin = lib.mkOption {
      default = false;
      description = ''
        Enable plugin autoloading.
      '';
      type = bool;
    };

    include = lib.mkOption {
      default = [ ];
      description = ''
        Additional paths to load config from.
      '';
      type = listOf str;
    };

    plugins = lib.mkOption {
      default = { };
      example = {
        cpu = "";
        memory = "";
        network = "Server 192.168.1.1 25826";
      };
      description = ''
        Attribute set of plugin names to plugin config segments
      '';
      type = attrsOf lines;
    };

    extraConfig = lib.mkOption {
      default = "";
      description = ''
        Extra configuration for collectd. Use mkBefore to add lines before the
        default config, and mkAfter to add them below.
      '';
      type = lines;
    };

  };

  config = lib.mkIf cfg.enable {
    # 1200 is after the default (1000) but before mkAfter (1500).
    services.collectd.extraConfig = lib.mkOrder 1200 ''
      ${baseDirLine}
      AutoLoadPlugin ${lib.boolToString cfg.autoLoadPlugin}
      Hostname "${config.networking.hostName}"

      LoadPlugin syslog
      <Plugin "syslog">
        LogLevel "info"
        NotifyLevel "OKAY"
      </Plugin>

      ${lib.concatStrings (
        lib.mapAttrsToList (plugin: pluginConfig: ''
          LoadPlugin ${plugin}
          <Plugin "${plugin}">
          ${pluginConfig}
          </Plugin>
        '') cfg.plugins
      )}

      ${lib.concatMapStrings (f: ''
        Include "${f}"
      '') cfg.include}
    '';

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' - ${cfg.user} - - -"
    ];

    systemd.services.collectd = {
      description = "Collectd Monitoring Agent";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${package}/sbin/collectd -C ${conf} -f";
        User = cfg.user;
        Restart = "on-failure";
        RestartSec = 3;
      };
    };

    users.users = lib.optionalAttrs (cfg.user == "collectd") {
      collectd = {
        isSystemUser = true;
        group = "collectd";
      };
    };

    users.groups = lib.optionalAttrs (cfg.user == "collectd") {
      collectd = { };
    };
  };
}
