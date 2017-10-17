{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.netdata;
  localConfig = {
    global = {
      "plugins directory" =  "${netdataWrapped}/libexec/netdata/plugins.d";
    };
  };

  mkConfig = generators.toINI {} (recursiveUpdate localConfig cfg.config);
  configFile = pkgs.writeText "netdata.conf" (if cfg.configText != null then cfg.configText else mkConfig);

  defaultUser = "netdata";
  netdataWrapped = pkgs.stdenv.mkDerivation {
    name = "netdataWrapped";
    buildInputs = [ pkgs.netdata ];
    builder = pkgs.writeText "builder.sh" ''
      source $stdenv/setup
      mkdir -p $out/libexec/netdata/plugins.d
      echo '#!${pkgs.bash}/bin/bash
      exec /run/wrappers/bin/apps.plugin $@
      ' >$out/libexec/netdata/plugins.d/apps.plugin
      chmod 755 $out/libexec/netdata/plugins.d/apps.plugin
      cp -rpn ${pkgs.netdata}/* $out/
    '';
  };

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
        type = types.nullOr types.str;
        description = "Verbatim netdata.conf, cannot be combined with config";
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
        ExecStart = "${netdataWrapped}/bin/netdata -D -c ${configFile}";
        TimeoutStopSec = 60;
      };
    };

    security.wrappers."apps.plugin" = {
      source = "${pkgs.netdata}/libexec/netdata/plugins.d/apps.plugin";
      capabilities = "cap_dac_read_search,cap_sys_ptrace+ep";
      owner = "netdata";
      group = "netdata";
      permissions = "u+rx,g+rx,o-rwx";
    };


    users.extraUsers = optional (cfg.user == defaultUser) {
      name = defaultUser;
    };

    users.extraGroups = optional (cfg.group == defaultUser) {
      name = defaultUser;
    };

  };
}
