{ config, lib, pkgs, ... }:

# TODO: support munin-async
# TODO: LWP/Pg perl libs aren't recognized

# TODO: support fastcgi
# http://guide.munin-monitoring.org/en/latest/example/webserver/apache-cgi.html
# spawn-fcgi -s /run/munin/fastcgi-graph.sock -U www-data   -u munin -g munin /usr/lib/munin/cgi/munin-cgi-graph
# spawn-fcgi -s /run/munin/fastcgi-html.sock  -U www-data   -u munin -g munin /usr/lib/munin/cgi/munin-cgi-html
# https://paste.sh/vofcctHP#-KbDSXVeWoifYncZmLfZzgum
# nginx http://munin.readthedocs.org/en/latest/example/webserver/nginx.html


with lib;

let
  nodeCfg = config.services.munin-node;
  cronCfg = config.services.munin-cron;

  muninConf = pkgs.writeText "munin.conf"
    ''
      dbdir     /var/lib/munin
      htmldir   /var/www/munin
      logdir    /var/log/munin
      rundir    /run/munin

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

  pluginConf = pkgs.writeText "munin-plugin-conf"
    ''
      [hddtemp_smartctl]
      user root
      group root

      [meminfo]
      user root
      group root

      [ipmi*]
      user root
      group root

      ${nodeCfg.extraPluginConfig}
    '';

  pluginConfDir = pkgs.stdenv.mkDerivation {
    name = "munin-plugin-conf.d";
    buildCommand = ''
      mkdir $out
      ln -s ${pluginConf} $out/nixos-config
    '';
  };
in

{

  options = {

    services.munin-node = {

      enable = mkOption {
        default = false;
        description = ''
          Enable Munin Node agent. Munin node listens on 0.0.0.0 and
          by default accepts connections only from 127.0.0.1 for security reasons.

          See <link xlink:href='http://guide.munin-monitoring.org/en/latest/architecture/index.html' />.
        '';
      };

      extraConfig = mkOption {
        default = "";
        type = types.lines;
        description = ''
          <filename>munin-node.conf</filename> extra configuration. See
          <link xlink:href='http://guide.munin-monitoring.org/en/latest/reference/munin-node.conf.html' />
        '';
      };

      # TODO: add option to add additional plugins
      extraPluginConfig = mkOption {
        default = "";
        type = types.lines;
        description = ''
          <filename>plugin-conf.d</filename> extra plugin configuration. See
          <link xlink:href='http://guide.munin-monitoring.org/en/latest/plugin/use.html' />
        '';
        example = ''
          [fail2ban_*]
          user root
        '';
      };

      disabledPlugins = mkOption {
        default = [];
        type = with types; listOf string;
        description = ''
          Munin plugins to disable, even if
          <literal>munin-node-configure --suggest</literal> tries to enable
          them. To disable a wildcard plugin, use an actual wildcard, as in
          the example.
        '';
        example = [ "diskstats" "zfs_usage_*" ];
      };
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
          See <link xlink:href='http://guide.munin-monitoring.org/en/latest/reference/munin.conf.html' />.
          Useful to setup notifications, see
          <link xlink:href='http://guide.munin-monitoring.org/en/latest/tutorial/alert.html' />
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
          host for cron to succeed. See
          <link xlink:href='http://guide.munin-monitoring.org/en/latest/reference/munin.conf.html' />
        '';
      };

    };

  };

  config = mkMerge [ (mkIf (nodeCfg.enable || cronCfg.enable)  {

    environment.systemPackages = [ pkgs.munin ];

    users.users = [{
      name = "munin";
      description = "Munin monitoring user";
      group = "munin";
      uid = config.ids.uids.munin;
    }];

    users.groups = [{
      name = "munin";
      gid = config.ids.gids.munin;
    }];

  }) (mkIf nodeCfg.enable {

    systemd.services.munin-node = {
      description = "Munin Node";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [ munin smartmontools "/run/current-system/sw" "/run/wrappers" ];
      environment.MUNIN_LIBDIR = "${pkgs.munin}/lib";
      environment.MUNIN_PLUGSTATE = "/run/munin";
      environment.MUNIN_LOGDIR = "/var/log/munin";
      preStart = ''
        echo "Updating munin plugins..."

        mkdir -p /etc/munin/plugins
        rm -rf /etc/munin/plugins/*

        # Autoconfigure builtin plugins
        ${pkgs.munin}/bin/munin-node-configure --suggest --shell --families contrib,auto,manual --config ${nodeConf} --libdir=${pkgs.munin}/lib/plugins --servicedir=/etc/munin/plugins --sconfdir=${pluginConfDir} 2>/dev/null | ${pkgs.bash}/bin/bash


        ${lib.optionalString (nodeCfg.disabledPlugins != []) ''
            # Disable plugins
            cd /etc/munin/plugins
            rm -f ${toString nodeCfg.disabledPlugins}
          ''}
      '';
      serviceConfig = {
        ExecStart = "${pkgs.munin}/sbin/munin-node --config ${nodeConf} --servicedir /etc/munin/plugins/ --sconfdir=${pluginConfDir}";
      };
    };

    # munin_stats plugin breaks as of 2.0.33 when this doesn't exist
    systemd.tmpfiles.rules = [ "d /run/munin 0755 munin munin -" ];

  }) (mkIf cronCfg.enable {

    # Munin is hardcoded to use DejaVu Mono and the graphs come out wrong if
    # it's not available.
    fonts.fonts = [ pkgs.dejavu_fonts ];

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

    systemd.tmpfiles.rules = [
      "d /run/munin 0755 munin munin -"
      "d /var/log/munin 0755 munin munin -"
      "d /var/www/munin 0755 munin munin -"
      "d /var/lib/munin 0755 munin munin -"
    ];
  })];
}
