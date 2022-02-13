{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.collectd;

  unvalidated_conf = pkgs.writeText "collectd-unvalidated.conf" ''
    BaseDir "${cfg.dataDir}"
    AutoLoadPlugin ${boolToString cfg.autoLoadPlugin}
    Hostname "${config.networking.hostName}"

    LoadPlugin syslog
    <Plugin "syslog">
      LogLevel "info"
      NotifyLevel "OKAY"
    </Plugin>

    ${concatStrings (mapAttrsToList (plugin: pluginConfig: ''
      LoadPlugin ${plugin}
      <Plugin "${plugin}">
      ${pluginConfig}
      </Plugin>
    '') cfg.plugins)}

    ${concatMapStrings (f: ''
      Include "${f}"
    '') cfg.include}

    ${cfg.extraConfig}
  '';

  conf = if cfg.validateConfig then
    pkgs.runCommand "collectd.conf" {} ''
      echo testing ${unvalidated_conf}
      # collectd -t fails if BaseDir does not exist.
      sed '1s/^BaseDir.*$/BaseDir "."/' ${unvalidated_conf} > collectd.conf
      ${package}/bin/collectd -t -C collectd.conf
      cp ${unvalidated_conf} $out
    '' else unvalidated_conf;

  package =
    if cfg.buildMinimalPackage
    then minimalPackage
    else cfg.package;

  minimalPackage = cfg.package.override {
    enabledPlugins = [ "syslog" ] ++ builtins.attrNames cfg.plugins;
  };

in {
  options.services.collectd = with types; {
    enable = mkEnableOption "collectd agent";

    validateConfig = mkOption {
      default = true;
      description = ''
        Validate the syntax of collectd configuration file at build time.
        Disable this if you use the Include directive on files unavailable in
        the build sandbox, or when cross-compiling.
      '';
      type = types.bool;
    };

    package = mkOption {
      default = pkgs.collectd;
      defaultText = literalExpression "pkgs.collectd";
      description = ''
        Which collectd package to use.
      '';
      type = types.package;
    };

    buildMinimalPackage = mkOption {
      default = false;
      description = ''
        Build a minimal collectd package with only the configured `services.collectd.plugins`
      '';
      type = bool;
    };

    user = mkOption {
      default = "collectd";
      description = ''
        User under which to run collectd.
      '';
      type = nullOr str;
    };

    dataDir = mkOption {
      default = "/var/lib/collectd";
      description = ''
        Data directory for collectd agent.
      '';
      type = path;
    };

    autoLoadPlugin = mkOption {
      default = false;
      description = ''
        Enable plugin autoloading.
      '';
      type = bool;
    };

    include = mkOption {
      default = [];
      description = ''
        Additional paths to load config from.
      '';
      type = listOf str;
    };

    plugins = mkOption {
      default = {};
      example = { cpu = ""; memory = ""; network = "Server 192.168.1.1 25826"; };
      description = ''
        Attribute set of plugin names to plugin config segments
      '';
      type = attrsOf lines;
    };

    extraConfig = mkOption {
      default = "";
      description = ''
        Extra configuration for collectd.
      '';
      type = lines;
    };

  };

  config = mkIf cfg.enable {
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

    users.users = optionalAttrs (cfg.user == "collectd") {
      collectd = {
        isSystemUser = true;
        group = "collectd";
      };
    };

    users.groups = optionalAttrs (cfg.user == "collectd") {
      collectd = {};
    };
  };
}
