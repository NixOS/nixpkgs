{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.collectd;

  conf = pkgs.writeText "collectd.conf" ''
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

    package = mkOption {
      default = pkgs.collectd;
      defaultText = "pkgs.collectd";
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
      type = types.bool;
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
      type = types.attrsOf types.str;
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
      };
    };
  };
}
