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
  meta.maintainers = with lib.maintainers; [ thiagokokada ];

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
        The content of {file}`rtorrent.rc`. The [upstream example configuration](https://github.com/rakshasa/rtorrent/blob/master/doc/rtorrent.rc-example)
        adapted to the values specified in this module will be prepended using mkBefore.
        You can use mkForce to overwrite the config completely.
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

    # Based on https://github.com/rakshasa/rtorrent/blob/28574836b07c993615bdbca466935466a8b28e34/doc/rtorrent.rc-example
    services.rtorrent.configText = mkBefore ''
      #############################################################################
      # A minimal rTorrent configuration that provides the basic features
      # you want to have in addition to the built-in defaults.
      #
      # See https://github.com/rakshasa/rtorrent/wiki/CONFIG-Template
      # for an up-to-date version.
      #############################################################################

      ## Instance layout (base paths)
      method.insert = cfg.basedir,  private|const|string, (cat,"${cfg.dataDir}/")
      method.insert = cfg.download, private|const|string, (cat,"${cfg.downloadDir}")
      method.insert = cfg.logs,     private|const|string, (cat,(cfg.basedir),"log/")
      method.insert = cfg.logfile,  private|const|string, (cat,(cfg.logs),(system.time),".log")
      method.insert = cfg.session,  private|const|string, (cat,(cfg.basedir),"session/")
      method.insert = cfg.watch,    private|const|string, (cat,(cfg.basedir),"watch/")
      method.insert = cfg.rpcsock,  private|const|string, (cat,"${cfg.rpcSocket}")

      ## Create instance directories
      execute.throw = sh, -c, (cat,\
          "mkdir -p \"",(cfg.download),"\" ",\
          "\"",(cfg.logs),"\" ",\
          "\"",(cfg.session),"\" ",\
          "\"",(cfg.watch),"/load\" ",\
          "\"",(cfg.watch),"/start\" ")

      ## Listening port for incoming peer traffic (fixed; you can also randomize it)
      network.listen.port.range.set = ${toString cfg.port}-${toString cfg.port}
      network.listen.port.random.set = no

      ## Tracker-less torrent and UDP tracker support
      ## (conservative settings for 'private' trackers, change for 'public')
      dht.mode.set = disable
      protocol.pex.set = no
      trackers.use_udp.set = no

      ## Peer settings
      throttle.max_uploads.set = 100
      throttle.max_uploads.global.set = 250

      throttle.min_peers.normal.set = 20
      throttle.max_peers.normal.set = 60
      throttle.min_peers.seed.set = 30
      throttle.max_peers.seed.set = 80
      trackers.numwant.set = 80

      # Select encryption for handshake and connection:
      #
      # protocol.encryption.set = {deny,allow,prefer,require}
      # protocol.encryption.set = handshake_{deny,allow,prefer,require}, stream_{deny,allow,prefer,require}
      #
      #protocol.encryption.set = deny
      #protocol.encryption.set = require
      #protocol.encryption.set = handshake_prefer, stream_deny
      #protocol.encryption.set = handshake_require, stream_prefer
      protocol.encryption.set = handshake_allow, stream_allow

      ## Limits for file handle resources, this is optimized for
      ## an `ulimit` of 1024 (a common default). You MUST leave
      ## a ceiling of handles reserved for rTorrent's internal needs!

      # Deprecated, see: https://github.com/rakshasa/rtorrent/wiki/Socket-Manager-and-Resource-Allocation

      ## Memory resource usage (increase if you have a large number of items loaded,
      ## and/or the available resources to spend)
      pieces.memory.max.set = 1800M
      network.xmlrpc.size_limit.set = 4M

      ## Basic operational settings (no need to change these)
      session.path.set = (cat, (cfg.session))
      directory.default.set = (cat, (cfg.download))
      log.execute = (cat, (cfg.logs), "execute.log")
      #log.xmlrpc = (cat, (cfg.logs), "xmlrpc.log")
      execute.nothrow = sh, -c, (cat, "echo >", (session.path), "rtorrent.pid", " ", (system.pid))

      ## Other operational settings (check & adapt)
      system.umask.set = 0027
      #session.umask.set = 0027
      system.cwd.set = (cfg.basedir)
      network.http.dns_cache_timeout.set = 25
      schedule = monitor_diskspace, 15, 60, ((close_low_diskspace, 1000M))
      #pieces.hash.on_completion.set = no
      #view.sort_current = seeding, greater=d.ratio=
      #keys.layout.set = qwerty
      #network.http.capath.set = "/etc/ssl/certs"
      #network.http.ssl_verify_peer.set = 0
      #network.http.ssl_verify_host.set = 0
      #network.rpc.use_xmlrpc.set = true
      #network.rpc.use_jsonrpc.set = true

      ## Some additional values and commands
      method.insert = system.startup_time, value|const, (system.time)
      method.insert = d.data_path, simple,\
          "if=(d.is_multi_file),\
              (cat, (d.directory), /),\
              (cat, (d.directory), /, (d.name))"
      method.insert = d.session_file, simple, "cat=(session.path), (d.hash), .torrent"

      ## Watch directories (add more as you like, but use unique schedule names)
      ## Add torrent
      #schedule = watch_load, 11, 10, ((load.verbose, (cat, (cfg.watch), "load/*.torrent")))
      ## Add & download straight away
      #schedule = watch_start, 10, 10, ((load.start_verbose, (cat, (cfg.watch), "start/*.torrent")))

      ## Run the rTorrent process as a daemon in the background
      ## (and control via XMLRPC sockets)
      #system.daemon.set = true
      #network.scgi.open_local = (cat,(session.path),rpc.socket)
      #execute.nothrow = chmod,770,(cat,(session.path),rpc.socket)
      network.scgi.open_local = (cfg.rpcsock)
      schedule = scgi_group,0,0,"execute.nothrow=chown,\":${cfg.group}\",(cfg.rpcsock)"
      schedule = scgi_permission,0,0,"execute.nothrow=chmod,\"g+w,o=\",(cfg.rpcsock)"

      ## Logging:
      ##   Levels = errors events debug_trace
      ##   Groups = connection_* dht_* peer_* rpc_* session_* storage_* torrent_* tracker_*
      print = (cat, "Logging to ", (cfg.logfile))

      log.open_file = "log", (cfg.logfile)

      log.add_output = "errors", "log"
      log.add_output = "events", "log"
      #log.add_output = "tracker_events", "log"
      #log.add_output = "tracker_requests", "log"

      ### END of rtorrent.rc ###
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
              RuntimeDirectoryMode = 750;

              # rtorrent derives socket limits from this value since 0.16.15; see table in
              # https://github.com/rakshasa/rtorrent/wiki/Socket-Manager-and-Resource-Allocation
              LimitNOFILE = lib.mkDefault 16384;

              CapabilityBoundingSet = [ "" ];
              LockPersonality = true;
              NoNewPrivileges = true;
              PrivateDevices = true;
              PrivateTmp = true;
              ProtectClock = true;
              ProtectControlGroups = true;
              # If the default user is changed, there is a good chance that they
              # want to store data in e.g.: $HOME directory
              # Relax hardening in this case
              ProtectHome = lib.mkIf (cfg.user == "rtorrent") true;
              ProtectHostname = true;
              ProtectKernelLogs = true;
              ProtectKernelModules = true;
              ProtectKernelTunables = true;
              ProtectProc = "invisible";
              ProtectSystem = "full";
              RestrictAddressFamilies = [
                "AF_UNIX"
                "AF_INET"
                "AF_INET6"
              ];
              RestrictNamespaces = true;
              RestrictRealtime = true;
              RestrictSUIDSGID = true;
              SystemCallArchitectures = "native";
              SystemCallFilter = [
                "@system-service"
                "~@privileged"
                "@chown"
              ];
            };
          };
      };

      tmpfiles.rules = [ "d '${cfg.dataDir}' ${cfg.dataPermissions} ${cfg.user} ${cfg.group} -" ];
    };
  };
}
