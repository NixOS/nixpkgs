{ config, lib, pkgs, ... }:

# TODO: support munin-async

with lib;

let
  nodeCfg = config.services.munin-node-ng;
  muninCfg = config.services.munin;
  httpdCfg = config.services.munin.httpd;
  cfgPackage = pkgs.muninUnstable.override { plugins = nodeCfg.plugins; };
in

{

  options = {

    services.munin-node-ng = {

      enable = mkEnableOption "munin-node agent";
      
      config = mkOption {
        type = types.lines;
        default = "";
        description = ''
          <filename>munin-node.conf</filename> extra configuration. See
          <link xlink:href='http://guide.munin-monitoring.org/en/latest/reference/munin-node.conf.html' />
        '';
      };

      pluginConfig = mkOption {
        default = "";
        type = types.lines;
        example = ''
          [postgres_]
          env.PGUSER root
        '';
        description = ''
          <filename>plugin-conf.d</filename> extra configuration. See
          <link xlink:href='https://munin.readthedocs.io/en/latest/plugin/use.html#configuring' />
        '';
      };
      
      plugins = mkOption {
        type = types.listOf types.package;
        default = [];
        description = ''
          List of extra plugin providers. Plugins should be located in share/plugins subdirectory.
        '';
      };

    };
    
    services.munin = {
    
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable munin-cron resource stats collector. Enables also services.munin-node for self-monitoring
          and starts web interface on 4948 port (which can be disabled with services.munin.httpd.enable = false).
        '';
      };
      
      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/munin";
        description = ''
          Data directory for Munin.
        '';
      };
      
      config = mkOption {
        type = types.lines;
        default = "";
        description = ''
          <filename>munin.conf</filename> extra configuration.
          See <link xlink:href='http://guide.munin-monitoring.org/en/latest/reference/munin.conf.html' />.
          Useful to setup notifications, see
          <link xlink:href='http://guide.munin-monitoring.org/en/latest/tutorial/alert.html' />
        '';
      };
      
      configNodes = mkOption {
        type = types.lines;
        default = "";
        example = ''
          [local]
          address localhost
          port 4949
       '';
        description = ''
          Definitions of nodes and node groups to collect data from. Needs at least one
          host for munin-cron to succeed. See
          <link xlink:href='http://guide.munin-monitoring.org/en/latest/reference/munin.conf.html#node-definitions' />
        '';
      };
      
      httpd = {
        enable = mkOption {
          default = false;
          description = ''
            Whether to enable munin-httpd web interface
            You may want to set caching proxy in front of munin-httpd. You can do this with nginx:
            
          '';
        };
      };
    };
  };

  config = mkMerge [
  
     (mkIf (nodeCfg.enable || muninCfg.enable || httpdCfg.enable)  {

    environment.systemPackages = [ cfgPackage ];

  }) (mkIf (muninCfg.enable || httpdCfg.enable) {
  
    users.extraUsers = [{
      name = "munin";
      description = "Munin monitoring user";
      group = "munin";
      uid = config.ids.uids.munin;
    }];

    users.extraGroups = [{
      name = "munin";
      gid = config.ids.gids.munin;
    }];

  }) (mkIf nodeCfg.enable {
  
    services.munin-node-ng.plugins = mkBefore [ pkgs.muninUnstable ];
    
    services.munin-node-ng.pluginConfig = mkBefore ''
      [postgres_]
      env.PGUSER root
    '';
    
    services.munin.configNodes = mkIf muninCfg.enable ''
      [${config.networking.hostName}]
      address munin://localhost
    '';
  
    services.munin-node-ng.config = mkBefore ''
      log_level 3
      log_file Sys::Syslog
      port 4949
      background 0
      host_name ${config.networking.hostName}
      setsid 0
      cidr_allow 127.0.0.1/32
    '';

    systemd.services.munin-node = 
      let pluginsConf = pkgs.writeTextDir "plugin-conf.d" nodeCfg.pluginConfig;
          nodeConf = pkgs.writeText "munin-node.conf" nodeCfg.config;
    in {
      description = "Munin Node";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [ munin gawk procps ntp nettools ];
      preStart = ''
        echo "updating munin plugins..."
        mkdir -p /etc/munin/plugins
        rm -rf /etc/munin/plugins/*
        mkdir -p /var/lib/munin-node/plugin-state
        
        for pluginDir in ${concatMapStringsSep " "  builtins.toString nodeCfg.plugins}; do
          PATH="/var/setuid-wrappers:/run/current-system/sw/bin:$PATH" \
            munin-node-configure --shell --families=contrib,auto,manual \
              --config=${nodeConf} \
              --sconfdir=${pluginsConf} \
              --libdir $pluginDir/share/plugins \
              --servicedir=/etc/munin/plugins \
              2>/dev/null | ${pkgs.bash}/bin/bash
        done
      '';
      serviceConfig = {
        ExecStart = ''${cfgPackage}/bin/munin-node \
          --config ${nodeConf} \
          --sconfdir=${pluginsConf} \
          --servicedir /etc/munin/plugins'';
      };
    };

  }) (mkIf muninCfg.enable {
  
    services.munin-node-ng.enable = mkDefault true;
    services.munin.httpd.enable = mkDefault true;
  
    services.munin.config = mkBefore ''
      dbdir     ${muninCfg.dataDir}
      logdir    ${muninCfg.dataDir}/logs
      rundir    /run/munin
      tmpldir   ${cfgPackage}/share/templates
    '';

    systemd.services.munin-cron = {
      path = [ cfgPackage ];
      after = [ "network.target" ] ++ (optional nodeCfg.enable "munin-node.service");
      wants = optional nodeCfg.enable "munin-node.service";
      preStart = ''
        mkdir -p ${muninCfg.dataDir} /run/munin
        chown -R munin:munin ${muninCfg.dataDir} /run/munin
      '';
      script = ''
        munin-cron --config ${pkgs.writeText "munin.conf" (muninCfg.config + muninCfg.configNodes)}
      '';
      serviceConfig.Type = "oneshot";
      serviceConfig.User = "munin";
      serviceConfig.Group = "munin";
      serviceConfig.PermissionsStartOnly = true;
    };
    
    systemd.timers.munin-cron = {
      wantedBy = [ "multi-user.target" ];
      timerConfig = {
        Unit = "munin-cron.service";
        OnCalendar = "*:0/5";
        Persistent = "true";
      };
    };
    
  }) (mkIf httpdCfg.enable {
  
    systemd.services.munin-httpd = {
      path = with pkgs; [ rrdtool ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.User = "munin";
      serviceConfig.Group = "munin";
      script = "${cfgPackage}/bin/munin-httpd --config ${pkgs.writeText "munin.conf" (muninCfg.config + muninCfg.configNodes)}";
    } // optionalAttrs muninCfg.enable { after = [ "munin-cron.service" ]; };

  })];
}
