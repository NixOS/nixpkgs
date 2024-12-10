{
  config,
  options,
  pkgs,
  lib,
  ...
}:

with lib;

let

  cfg = config.services.rtorrent;
  opt = options.services.rtorrent;

in
{
  options.services.rtorrent = {
    enable = mkEnableOption "rtorrent";

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/rtorrent";
      description = ''
        The directory where rtorrent stores its data files.
      '';
    };

    dataPermissions = mkOption {
      type = types.str;
      default = "0750";
      example = "0755";
      description = ''
        Unix Permissions in octal on the rtorrent directory.
      '';
    };

    downloadDir = mkOption {
      type = types.str;
      default = "${cfg.dataDir}/download";
      defaultText = literalExpression ''"''${config.${opt.dataDir}}/download"'';
      description = ''
        Where to put downloaded files.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "rtorrent";
      description = ''
        User account under which rtorrent runs.
      '';
    };

    group = mkOption {
      type = types.str;
      default = "rtorrent";
      description = ''
        Group under which rtorrent runs.
      '';
    };

    package = mkPackageOption pkgs "rtorrent" { };

    port = mkOption {
      type = types.port;
      default = 50000;
      description = ''
        The rtorrent port.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to open the firewall for the port in {option}`services.rtorrent.port`.
      '';
    };

    rpcSocket = mkOption {
      type = types.str;
      readOnly = true;
      default = "/run/rtorrent/rpc.sock";
      description = ''
        RPC socket path.
      '';
    };

    configText = mkOption {
      type = types.lines;
      default = "";
      description = ''
        The content of {file}`rtorrent.rc`. The [modernized configuration template](https://rtorrent-docs.readthedocs.io/en/latest/cookbook.html#modernized-configuration-template) with the values specified in this module will be prepended using mkBefore. You can use mkForce to overwrite the config completely.
      '';
    };
  };

  config = mkIf cfg.enable {

    users.groups = mkIf (cfg.group == "rtorrent") {
      rtorrent = { };
    };

    users.users = mkIf (cfg.user == "rtorrent") {
      rtorrent = {
        group = cfg.group;
        shell = pkgs.bashInteractive;
        home = cfg.dataDir;
        description = "rtorrent Daemon user";
        isSystemUser = true;
      };
    };

    networking.firewall.allowedTCPPorts = mkIf (cfg.openFirewall) [ cfg.port ];

    services.rtorrent.configText = mkBefore ''
      # Instance layout (base paths)
      method.insert = cfg.basedir, private|const|string, (cat,"${cfg.dataDir}/")
      method.insert = cfg.watch,   private|const|string, (cat,(cfg.basedir),"watch/")
      method.insert = cfg.logs,    private|const|string, (cat,(cfg.basedir),"log/")
      method.insert = cfg.logfile, private|const|string, (cat,(cfg.logs),(system.time),".log")
      method.insert = cfg.rpcsock, private|const|string, (cat,"${cfg.rpcSocket}")

      # Create instance directories
      execute.throw = sh, -c, (cat, "mkdir -p ", (cfg.basedir), "/session ", (cfg.watch), " ", (cfg.logs))

      # Listening port for incoming peer traffic (fixed; you can also randomize it)
      network.port_range.set = ${toString cfg.port}-${toString cfg.port}
      network.port_random.set = no

      # Tracker-less torrent and UDP tracker support
      # (conservative settings for 'private' trackers, change for 'public')
      dht.mode.set = disable
      protocol.pex.set = no
      trackers.use_udp.set = no

      # Peer settings
      throttle.max_uploads.set = 100
      throttle.max_uploads.global.set = 250

      throttle.min_peers.normal.set = 20
      throttle.max_peers.normal.set = 60
      throttle.min_peers.seed.set = 30
      throttle.max_peers.seed.set = 80
      trackers.numwant.set = 80

      protocol.encryption.set = allow_incoming,try_outgoing,enable_retry

      # Limits for file handle resources, this is optimized for
      # an `ulimit` of 1024 (a common default). You MUST leave
      # a ceiling of handles reserved for rTorrent's internal needs!
      network.http.max_open.set = 50
      network.max_open_files.set = 600
      network.max_open_sockets.set = 3000

      # Memory resource usage (increase if you have a large number of items loaded,
      # and/or the available resources to spend)
      pieces.memory.max.set = 1800M
      network.xmlrpc.size_limit.set = 4M

      # Basic operational settings (no need to change these)
      session.path.set = (cat, (cfg.basedir), "session/")
      directory.default.set = "${cfg.downloadDir}"
      log.execute = (cat, (cfg.logs), "execute.log")
      ##log.xmlrpc = (cat, (cfg.logs), "xmlrpc.log")
      execute.nothrow = sh, -c, (cat, "echo >", (session.path), "rtorrent.pid", " ", (system.pid))

      # Other operational settings (check & adapt)
      encoding.add = utf8
      system.umask.set = 0027
      system.cwd.set = (cfg.basedir)
      network.http.dns_cache_timeout.set = 25
      schedule2 = monitor_diskspace, 15, 60, ((close_low_diskspace, 1000M))

      # Watch directories (add more as you like, but use unique schedule names)
      #schedule2 = watch_start, 10, 10, ((load.start, (cat, (cfg.watch), "start/*.torrent")))
      #schedule2 = watch_load, 11, 10, ((load.normal, (cat, (cfg.watch), "load/*.torrent")))

      # Logging:
      #   Levels = critical error warn notice info debug
      #   Groups = connection_* dht_* peer_* rpc_* storage_* thread_* tracker_* torrent_*
      print = (cat, "Logging to ", (cfg.logfile))
      log.open_file = "log", (cfg.logfile)
      log.add_output = "info", "log"
      ##log.add_output = "tracker_debug", "log"

      # XMLRPC
      scgi_local = (cfg.rpcsock)
      schedule = scgi_group,0,0,"execute.nothrow=chown,\":rtorrent\",(cfg.rpcsock)"
      schedule = scgi_permission,0,0,"execute.nothrow=chmod,\"g+w,o=\",(cfg.rpcsock)"
    '';

    systemd = {
      services = {
        rtorrent =
          let
            rtorrentConfigFile = pkgs.writeText "rtorrent.rc" cfg.configText;
          in
          {
            description = "rTorrent system service";
            after = [ "network.target" ];
            path = [
              cfg.package
              pkgs.bash
            ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              User = cfg.user;
              Group = cfg.group;
              Type = "simple";
              Restart = "on-failure";
              WorkingDirectory = cfg.dataDir;
              ExecStartPre = ''${pkgs.bash}/bin/bash -c "if test -e ${cfg.dataDir}/session/rtorrent.lock && test -z $(${pkgs.procps}/bin/pidof rtorrent); then rm -f ${cfg.dataDir}/session/rtorrent.lock; fi"'';
              ExecStart = "${cfg.package}/bin/rtorrent -n -o system.daemon.set=true -o import=${rtorrentConfigFile}";
              RuntimeDirectory = "rtorrent";
              RuntimeDirectoryMode = 755;
            };
          };
      };

      tmpfiles.rules = [ "d '${cfg.dataDir}' ${cfg.dataPermissions} ${cfg.user} ${cfg.group} -" ];
    };
  };
}
