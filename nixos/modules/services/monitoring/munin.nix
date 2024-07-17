{
  config,
  lib,
  pkgs,
  ...
}:

# TODO: support munin-async
# TODO: LWP/Pg perl libs aren't recognized

# TODO: support fastcgi
# https://guide.munin-monitoring.org/en/latest/example/webserver/apache-cgi.html
# spawn-fcgi -s /run/munin/fastcgi-graph.sock -U www-data   -u munin -g munin /usr/lib/munin/cgi/munin-cgi-graph
# spawn-fcgi -s /run/munin/fastcgi-html.sock  -U www-data   -u munin -g munin /usr/lib/munin/cgi/munin-cgi-html
# https://paste.sh/vofcctHP#-KbDSXVeWoifYncZmLfZzgum
# nginx https://munin.readthedocs.org/en/latest/example/webserver/nginx.html

with lib;

let
  nodeCfg = config.services.munin-node;
  cronCfg = config.services.munin-cron;

  muninConf = pkgs.writeText "munin.conf" ''
    dbdir     /var/lib/munin
    htmldir   /var/www/munin
    logdir    /var/log/munin
    rundir    /run/munin

    ${lib.optionalString (cronCfg.extraCSS != "") "staticdir ${customStaticDir}"}

    ${cronCfg.extraGlobalConfig}

    ${cronCfg.hosts}
  '';

  nodeConf = pkgs.writeText "munin-node.conf" ''
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

  pluginConf = pkgs.writeText "munin-plugin-conf" ''
    [hddtemp_smartctl]
    user root
    group root

    [meminfo]
    user root
    group root

    [ipmi*]
    user root
    group root

    [munin*]
    env.UPDATE_STATSFILE /var/lib/munin/munin-update.stats

    ${nodeCfg.extraPluginConfig}
  '';

  pluginConfDir = pkgs.stdenv.mkDerivation {
    name = "munin-plugin-conf.d";
    buildCommand = ''
      mkdir $out
      ln -s ${pluginConf} $out/nixos-config
    '';
  };

  # Copy one Munin plugin into the Nix store with a specific name.
  # This is suitable for use with plugins going directly into /etc/munin/plugins,
  # i.e. munin.extraPlugins.
  internOnePlugin = { name, path }: "cp -a '${path}' '${name}'";

  # Copy an entire tree of Munin plugins into a single directory in the Nix
  # store, with no renaming. The output is suitable for use with
  # munin-node-configure --suggest, i.e. munin.extraAutoPlugins.
  # Note that this flattens the input; this is intentional, as
  # munin-node-configure won't recurse into subdirectories.
  internManyPlugins = path: "find '${path}' -type f -perm /a+x -exec cp -a -t . '{}' '+'";

  # Use the appropriate intern-fn to copy the plugins into the store and patch
  # them afterwards in an attempt to get them to run on NixOS.
  # This is a bit hairy because we can't just fix shebangs; lots of munin plugins
  # hardcode paths like /sbin/mount rather than trusting $PATH, so we have to
  # look for and update those throughout the script. At the same time, if the
  # plugin comes from a package that is already nixified, we don't want to
  # rewrite paths like /nix/store/foo/sbin/mount.
  # For now we make the simplifying assumption that no file will contain lines
  # which mix store paths and FHS paths, and thus run our substitution only on
  # lines which do not contain store paths.
  internAndFixPlugins =
    name: intern-fn: paths:
    pkgs.runCommand name { } ''
      mkdir -p "$out"
      cd "$out"
      ${lib.concatStringsSep "\n" (map intern-fn paths)}
      chmod -R u+w .
      ${pkgs.findutils}/bin/find . -type f -exec ${pkgs.gnused}/bin/sed -E -i "
        \%''${NIX_STORE}/%! s,(/usr)?/s?bin/,/run/current-system/sw/bin/,g
      " '{}' '+'
    '';

  # TODO: write a derivation for munin-contrib, so that for contrib plugins
  # you can just refer to them by name rather than needing to include a copy
  # of munin-contrib in your nixos configuration.
  extraPluginDir = internAndFixPlugins "munin-extra-plugins.d" internOnePlugin (
    lib.attrsets.mapAttrsToList (k: v: {
      name = k;
      path = v;
    }) nodeCfg.extraPlugins
  );

  extraAutoPluginDir =
    internAndFixPlugins "munin-extra-auto-plugins.d" internManyPlugins
      nodeCfg.extraAutoPlugins;

  customStaticDir = pkgs.runCommand "munin-custom-static-data" { } ''
    cp -a "${pkgs.munin}/etc/opt/munin/static" "$out"
    cd "$out"
    chmod -R u+w .
    echo "${cronCfg.extraCSS}" >> style.css
    echo "${cronCfg.extraCSS}" >> style-new.css
  '';
in

{

  options = {

    services.munin-node = {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable Munin Node agent. Munin node listens on 0.0.0.0 and
          by default accepts connections only from 127.0.0.1 for security reasons.

          See <https://guide.munin-monitoring.org/en/latest/architecture/index.html>.
        '';
      };

      extraConfig = mkOption {
        default = "";
        type = types.lines;
        description = ''
          {file}`munin-node.conf` extra configuration. See
          <https://guide.munin-monitoring.org/en/latest/reference/munin-node.conf.html>
        '';
      };

      extraPluginConfig = mkOption {
        default = "";
        type = types.lines;
        description = ''
          {file}`plugin-conf.d` extra plugin configuration. See
          <https://guide.munin-monitoring.org/en/latest/plugin/use.html>
        '';
        example = ''
          [fail2ban_*]
          user root
        '';
      };

      extraPlugins = mkOption {
        default = { };
        type = with types; attrsOf path;
        description = ''
          Additional Munin plugins to activate. Keys are the name of the plugin
          symlink, values are the path to the underlying plugin script. You
          can use the same plugin script multiple times (e.g. for wildcard
          plugins).

          Note that these plugins do not participate in autoconfiguration. If
          you want to autoconfigure additional plugins, use
          {option}`services.munin-node.extraAutoPlugins`.

          Plugins enabled in this manner take precedence over autoconfigured
          plugins.

          Plugins will be copied into the Nix store, and it will attempt to
          modify them to run properly by fixing hardcoded references to
          `/bin`, `/usr/bin`,
          `/sbin`, and `/usr/sbin`.
        '';
        example = literalExpression ''
          {
            zfs_usage_bigpool = /src/munin-contrib/plugins/zfs/zfs_usage_;
            zfs_usage_smallpool = /src/munin-contrib/plugins/zfs/zfs_usage_;
            zfs_list = /src/munin-contrib/plugins/zfs/zfs_list;
          };
        '';
      };

      extraAutoPlugins = mkOption {
        default = [ ];
        type = with types; listOf path;
        description = ''
          Additional Munin plugins to autoconfigure, using
          `munin-node-configure --suggest`. These should be
          the actual paths to the plugin files (or directories containing them),
          not just their names.

          If you want to manually enable individual plugins instead, use
          {option}`services.munin-node.extraPlugins`.

          Note that only plugins that have the 'autoconfig' capability will do
          anything if listed here, since plugins that cannot autoconfigure
          won't be automatically enabled by
          `munin-node-configure`.

          Plugins will be copied into the Nix store, and it will attempt to
          modify them to run properly by fixing hardcoded references to
          `/bin`, `/usr/bin`,
          `/sbin`, and `/usr/sbin`.
        '';
        example = literalExpression ''
          [
            /src/munin-contrib/plugins/zfs
            /src/munin-contrib/plugins/ssh
          ];
        '';
      };

      disabledPlugins = mkOption {
        # TODO: figure out why Munin isn't writing the log file and fix it.
        # In the meantime this at least suppresses a useless graph full of
        # NaNs in the output.
        default = [ "munin_stats" ];
        type = with types; listOf str;
        description = ''
          Munin plugins to disable, even if
          `munin-node-configure --suggest` tries to enable
          them. To disable a wildcard plugin, use an actual wildcard, as in
          the example.

          munin_stats is disabled by default as it tries to read
          `/var/log/munin/munin-update.log` for timing
          information, and the NixOS build of Munin does not write this file.
        '';
        example = [
          "diskstats"
          "zfs_usage_*"
        ];
      };
    };

    services.munin-cron = {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable munin-cron. Takes care of all heavy lifting to collect data from
          nodes and draws graphs to html. Runs munin-update, munin-limits,
          munin-graphs and munin-html in that order.

          HTML output is in {file}`/var/www/munin/`, configure your
          favourite webserver to serve static files.
        '';
      };

      extraGlobalConfig = mkOption {
        default = "";
        type = types.lines;
        description = ''
          {file}`munin.conf` extra global configuration.
          See <https://guide.munin-monitoring.org/en/latest/reference/munin.conf.html>.
          Useful to setup notifications, see
          <https://guide.munin-monitoring.org/en/latest/tutorial/alert.html>
        '';
        example = ''
          contact.email.command mail -s "Munin notification for ''${var:host}" someone@example.com
        '';
      };

      hosts = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Definitions of hosts of nodes to collect data from. Needs at least one
          host for cron to succeed. See
          <https://guide.munin-monitoring.org/en/latest/reference/munin.conf.html>
        '';
        example = literalExpression ''
          '''
            [''${config.networking.hostName}]
            address localhost
          '''
        '';
      };

      extraCSS = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Custom styling for the HTML that munin-cron generates. This will be
          appended to the CSS files used by munin-cron and will thus take
          precedence over the builtin styles.
        '';
        example = ''
          /* A simple dark theme. */
          html, body { background: #222222; }
          #header, #footer { background: #333333; }
          img.i, img.iwarn, img.icrit, img.iunkn {
            filter: invert(100%) hue-rotate(-30deg);
          }
        '';
      };

    };

  };

  config = mkMerge [
    (mkIf (nodeCfg.enable || cronCfg.enable) {

      environment.systemPackages = [ pkgs.munin ];

      users.users.munin = {
        description = "Munin monitoring user";
        group = "munin";
        uid = config.ids.uids.munin;
        home = "/var/lib/munin";
      };

      users.groups.munin = {
        gid = config.ids.gids.munin;
      };

    })
    (mkIf nodeCfg.enable {

      systemd.services.munin-node = {
        description = "Munin Node";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        path = with pkgs; [
          munin
          smartmontools
          "/run/current-system/sw"
          "/run/wrappers"
        ];
        environment.MUNIN_LIBDIR = "${pkgs.munin}/lib";
        environment.MUNIN_PLUGSTATE = "/run/munin";
        environment.MUNIN_LOGDIR = "/var/log/munin";
        preStart = ''
          echo "Updating munin plugins..."

          mkdir -p /etc/munin/plugins
          rm -rf /etc/munin/plugins/*

          # Autoconfigure builtin plugins
          ${pkgs.munin}/bin/munin-node-configure --suggest --shell --families contrib,auto,manual --config ${nodeConf} --libdir=${pkgs.munin}/lib/plugins --servicedir=/etc/munin/plugins --sconfdir=${pluginConfDir} 2>/dev/null | ${pkgs.bash}/bin/bash

          # Autoconfigure extra plugins
          ${pkgs.munin}/bin/munin-node-configure --suggest --shell --families contrib,auto,manual --config ${nodeConf} --libdir=${extraAutoPluginDir} --servicedir=/etc/munin/plugins --sconfdir=${pluginConfDir} 2>/dev/null | ${pkgs.bash}/bin/bash

          ${lib.optionalString (nodeCfg.extraPlugins != { }) ''
            # Link in manually enabled plugins
            ln -f -s -t /etc/munin/plugins ${extraPluginDir}/*
          ''}

          ${lib.optionalString (nodeCfg.disabledPlugins != [ ]) ''
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
      systemd.tmpfiles.settings."10-munin"."/run/munin".d = {
        mode = "0755";
        user = "munin";
        group = "munin";
      };

    })
    (mkIf cronCfg.enable {

      # Munin is hardcoded to use DejaVu Mono and the graphs come out wrong if
      # it's not available.
      fonts.packages = [ pkgs.dejavu_fonts ];

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

      systemd.tmpfiles.settings."20-munin" =
        let
          defaultConfig = {
            mode = "0755";
            user = "munin";
            group = "munin";
          };
        in
        {
          "/run/munin".d = defaultConfig;
          "/var/log/munin".d = defaultConfig;
          "/var/www/munin".d = defaultConfig;
          "/var/lib/munin".d = defaultConfig;
        };
    })
  ];
}
