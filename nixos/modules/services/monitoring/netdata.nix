{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.netdata;

  wrappedPlugins = pkgs.runCommand "wrapped-plugins" { preferLocalBuild = true; } ''
    mkdir -p $out/libexec/netdata/plugins.d
    ln -s /run/wrappers/bin/apps.plugin $out/libexec/netdata/plugins.d/apps.plugin
    ln -s /run/wrappers/bin/freeipmi.plugin $out/libexec/netdata/plugins.d/freeipmi.plugin
  '';

  plugins = [
    "${pkgs.netdata}/libexec/netdata/plugins.d"
    "${wrappedPlugins}/libexec/netdata/plugins.d"
  ] ++ cfg.extraPluginPaths;

  localConfig = {
    global = {
      "plugins directory" = concatStringsSep " " plugins;
    };
    web = {
      "web files owner" = "root";
      "web files group" = "root";
    };
  };
  mkConfig = generators.toINI {} (recursiveUpdate localConfig cfg.config);
  configFile = pkgs.writeText "netdata.conf" (if cfg.configText != null then cfg.configText else mkConfig);

  defaultUser = "netdata";

in {
  options = {
    services.netdata = {
      enable = mkEnableOption "netdata";

      user = mkOption {
        type = types.str;
        default = "netdata";
        description = "User account under which netdata runs.";
      };

      group = mkOption {
        type = types.str;
        default = "netdata";
        description = "Group under which netdata runs.";
      };

      configText = mkOption {
        type = types.nullOr types.lines;
        description = "Verbatim netdata.conf, cannot be combined with config.";
        default = null;
        example = ''
          [global]
          debug log = syslog
          access log = syslog
          error log = syslog
        '';
      };

      python = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether to enable python-based plugins
          '';
        };
        extraPackages = mkOption {
          default = ps: [];
          defaultText = "ps: []";
          example = literalExample ''
            ps: [
              ps.psycopg2
              ps.docker
              ps.dnspython
            ]
          '';
          description = ''
            Extra python packages available at runtime
            to enable additional python plugins.
          '';
        };
      };

      extraPluginPaths = mkOption {
        type = types.listOf types.path;
        default = [ ];
        example = literalExample ''
          [ "/path/to/plugins.d" ]
        '';
        description = ''
          Extra paths to add to the netdata global "plugins directory"
          option.  Useful for when you want to include your own
          collection scripts.
          </para><para>
          Details about writing a custom netdata plugin are available at:
          <link xlink:href="https://docs.netdata.cloud/collectors/plugins.d/"/>
          </para><para>
          Cannot be combined with configText.
        '';
      };

      config = mkOption {
        type = types.attrsOf types.attrs;
        default = {};
        description = "netdata.conf configuration as nix attributes. cannot be combined with configText.";
        example = literalExample ''
          global = {
            "debug log" = "syslog";
            "access log" = "syslog";
            "error log" = "syslog";
          };
        '';
        };
      };
    };

  config = mkIf cfg.enable {
    assertions =
      [ { assertion = cfg.config != {} -> cfg.configText == null ;
          message = "Cannot specify both config and configText";
        }
      ];

    systemd.tmpfiles.rules = [
      "d /var/cache/netdata 0755 ${cfg.user} ${cfg.group} -"
      "Z /var/cache/netdata - ${cfg.user} ${cfg.group} -"
      "d /var/log/netdata 0755 ${cfg.user} ${cfg.group} -"
      "Z /var/log/netdata - ${cfg.user} ${cfg.group} -"
      "d /var/lib/netdata 0755 ${cfg.user} ${cfg.group} -"
      "Z /var/lib/netdata - ${cfg.user} ${cfg.group} -"
      "d /etc/netdata 0755 ${cfg.user} ${cfg.group} -"
      "Z /etc/netdata - ${cfg.user} ${cfg.group} -"
    ];
    systemd.services.netdata = {
      description = "Real time performance monitoring";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = (with pkgs; [ curl gawk which ]) ++ lib.optional cfg.python.enable
        (pkgs.python3.withPackages cfg.python.extraPackages);
      serviceConfig = {
        Environment="PYTHONPATH=${pkgs.netdata}/libexec/netdata/python.d/python_modules";
        ExecStart = "${pkgs.netdata}/bin/netdata -P /run/netdata/netdata.pid -D -c ${configFile}";
        ExecReload = "${pkgs.utillinux}/bin/kill -s HUP -s USR1 -s USR2 $MAINPID";
        TimeoutStopSec = 60;
        # User and group
        User = cfg.user;
        Group = cfg.group;
        # Runtime directory and mode
        RuntimeDirectory = "netdata";
        RuntimeDirectoryMode = "0755";
        # Performance
        LimitNOFILE = "30000";
      };
    };

    systemd.enableCgroupAccounting = true;

    security.wrappers."apps.plugin" = {
      source = "${pkgs.netdata}/libexec/netdata/plugins.d/apps.plugin.org";
      capabilities = "cap_dac_read_search,cap_sys_ptrace+ep";
      owner = cfg.user;
      group = cfg.group;
      permissions = "u+rx,g+rx,o-rwx";
    };

    security.wrappers."freeipmi.plugin" = {
      source = "${pkgs.netdata}/libexec/netdata/plugins.d/freeipmi.plugin.org";
      capabilities = "cap_dac_override,cap_fowner+ep";
      owner = cfg.user;
      group = cfg.group;
      permissions = "u+rx,g+rx,o-rwx";
    };

    security.pam.loginLimits = [
      { domain = "netdata"; type = "soft"; item = "nofile"; value = "10000"; }
      { domain = "netdata"; type = "hard"; item = "nofile"; value = "30000"; }
    ];

    users.users = optionalAttrs (cfg.user == defaultUser) {
      ${defaultUser} = {
        isSystemUser = true;
      };
    };

    users.groups = optionalAttrs (cfg.group == defaultUser) {
      ${defaultUser} = { };
    };

  };
}
