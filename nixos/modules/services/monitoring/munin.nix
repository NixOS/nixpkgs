{ config, lib, pkgs, ... }:

# TODO: support munin-async
# TODO: LWP/Pg perl libs aren't recognized

# TODO: support fastcgi
# http://munin-monitoring.org/wiki/CgiHowto2
# spawn-fcgi -s /var/run/munin/fastcgi-graph.sock -U www-data   -u munin -g munin /usr/lib/munin/cgi/munin-cgi-graph
# spawn-fcgi -s /var/run/munin/fastcgi-html.sock  -U www-data   -u munin -g munin /usr/lib/munin/cgi/munin-cgi-html
# https://paste.sh/vofcctHP#-KbDSXVeWoifYncZmLfZzgum
# nginx http://munin.readthedocs.org/en/latest/example/webserver/nginx.html


with lib;

let
  nodeCfg = config.services.munin-node;
  cronCfg = config.services.munin-cron;

  muninPlugins = pkgs.stdenv.mkDerivation {
    name = "munin-available-plugins";
    buildCommand = ''
      mkdir -p $out

      cp --preserve=mode ${pkgs.munin}/lib/plugins/* $out/

      for file in $out/*; do
        case "$file" in
            plugin.sh) continue;;
        esac

        # read magic makers from the file
        family=$(sed -nr 's/.*#%#\s+family\s*=\s*(\S+)\s*/\1/p' $file)
        cap=$(sed -nr 's/.*#%#\s+capabilities\s*=\s*(.+)/\1/p' $file)

        wrapProgram $file \
          --set PATH "/run/wrappers/bin:/run/current-system/sw/bin" \
          --set MUNIN_LIBDIR "${pkgs.munin}/lib" \
          --set MUNIN_PLUGSTATE "/var/run/munin"

        # munin uses markers to tell munin-node-configure what a plugin can do
        echo "#%# family=$family" >> $file
        echo "#%# capabilities=$cap" >> $file
      done

      # NOTE: we disable disktstats because plugin seems to fail and it hangs html generation (100% CPU + memory leak)
      rm -f $out/diskstats
    '';
    buildInputs = [ pkgs.makeWrapper ];
  };

  muninConf = pkgs.writeText "munin.conf"
    ''
      dbdir     /var/lib/munin
      htmldir   /var/www/munin
      logdir    /var/log/munin
      rundir    /var/run/munin

      ${cronCfg.extraGlobalConfig}

      ${cronCfg.hosts}
    '';

  nodeConf = pkgs.writeText "munin-node.conf"
    ''
      log_level 3
      log_file Sys::Syslog
      port 4949
      host *
      background 0
      user root
      group root
      host_name ${config.networking.hostName}
      setsid 0

      # wrapped plugins by makeWrapper being with dots
      ignore_file ^\.

      allow ^::1$
      allow ^127\.0\.0\.1$

      ${nodeCfg.extraConfig}
    '';
in

{

  options = {

    services.munin-node = {

      enable = mkOption {
        default = false;
        description = ''
          Enable Munin Node agent. Munin node listens on 0.0.0.0 and
          by default accepts connections only from 127.0.0.1 for security reasons.

          See <link xlink:href='http://munin-monitoring.org/wiki/munin-node.conf' />.
        '';
      };

      extraConfig = mkOption {
        default = "";
        type = types.lines;
        description = ''
          <filename>munin-node.conf</filename> extra configuration. See
          <link xlink:href='http://munin-monitoring.org/wiki/munin-node.conf' />
        '';
      };

      # TODO: add option to add additional plugins

    };

    services.munin-cron = {

      enable = mkOption {
        default = false;
        description = ''
          Enable munin-cron. Takes care of all heavy lifting to collect data from
          nodes and draws graphs to html. Runs munin-update, munin-limits,
          munin-graphs and munin-html in that order.

          HTML output is in <filename>/var/www/munin/</filename>, configure your
          favourite webserver to serve static files.
        '';
      };

      extraGlobalConfig = mkOption {
        default = "";
        description = ''
          <filename>munin.conf</filename> extra global configuration.
          See <link xlink:href='http://munin-monitoring.org/wiki/munin.conf' />.
          Useful to setup notifications, see
          <link xlink:href='http://munin-monitoring.org/wiki/HowToContact' />
        '';
        example = ''
          contact.email.command mail -s "Munin notification for ''${var:host}" someone@example.com
        '';
      };

      hosts = mkOption {
        example = ''
          [''${config.networking.hostName}]
          address localhost
        '';
        description = ''
          Definitions of hosts of nodes to collect data from. Needs at least one
          hosts for cron to succeed. See
          <link xlink:href='http://munin-monitoring.org/wiki/munin.conf' />
        '';
      };

    };

  };

  config = mkMerge [ (mkIf (nodeCfg.enable || cronCfg.enable)  {

    environment.systemPackages = [ pkgs.munin ];

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

    systemd.services.munin-node = {
      description = "Munin Node";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.munin ];
      environment.MUNIN_PLUGSTATE = "/var/run/munin";
      preStart = ''
        echo "updating munin plugins..."

        mkdir -p /etc/munin/plugins
        rm -rf /etc/munin/plugins/*
        PATH="/run/wrappers/bin:/run/current-system/sw/bin" ${pkgs.munin}/sbin/munin-node-configure --shell --families contrib,auto,manual --config ${nodeConf} --libdir=${muninPlugins} --servicedir=/etc/munin/plugins 2>/dev/null | ${pkgs.bash}/bin/bash
      '';
      serviceConfig = {
        ExecStart = "${pkgs.munin}/sbin/munin-node --config ${nodeConf} --servicedir /etc/munin/plugins/";
      };
    };

  }) (mkIf cronCfg.enable {

    systemd.timers.munin-cron = {
      description = "batch Munin master programs";
      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = "*:0/5";
    };

    systemd.services.munin-cron = {
      description = "batch Munin master programs";
      unitConfig.Documentation = "man:munin-cron(8)";

      serviceConfig = {
        Type = "oneshot";
        User = "munin";
        ExecStart = "${pkgs.munin}/bin/munin-cron --config ${muninConf}";
      };
    };

    system.activationScripts.munin-cron = stringAfter [ "users" "groups" ] ''
      mkdir -p /var/{run,log,www,lib}/munin
      chown -R munin:munin /var/{run,log,www,lib}/munin
    '';
  })];
}
