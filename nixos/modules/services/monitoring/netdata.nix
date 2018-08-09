{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.netdata;

  wrappedPlugins = pkgs.runCommand "wrapped-plugins" {} ''
    mkdir -p $out/libexec/netdata/plugins.d
    ln -s /run/wrappers/bin/apps.plugin $out/libexec/netdata/plugins.d/apps.plugin
  '';

  localConfig = {
    global = {
      "plugins directory" = "${wrappedPlugins}/libexec/netdata/plugins.d ${pkgs.netdata}/libexec/netdata/plugins.d";
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
    systemd.services.netdata = {
      path = with pkgs; [ gawk curl ];
      description = "Real time performance monitoring";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = concatStringsSep "\n" (map (dir: ''
        mkdir -vp ${dir}
        chmod 750 ${dir}
        chown -R ${cfg.user}:${cfg.group} ${dir}
        '') [ "/var/cache/netdata"
              "/var/log/netdata"
              "/var/lib/netdata" ]);
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        PermissionsStartOnly = true;
        ExecStart = "${pkgs.netdata}/bin/netdata -D -c ${configFile}";
        TimeoutStopSec = 60;
      };
    };

    security.wrappers."apps.plugin" = {
      source = "${pkgs.netdata}/libexec/netdata/plugins.d/apps.plugin";
      capabilities = "cap_dac_read_search,cap_sys_ptrace+ep";
      owner = cfg.user;
      group = cfg.group;
      permissions = "u+rx,g+rx,o-rwx";
    };


    users.users = optional (cfg.user == defaultUser) {
      name = defaultUser;
    };

    users.groups = optional (cfg.group == defaultUser) {
      name = defaultUser;
    };

  };
}
