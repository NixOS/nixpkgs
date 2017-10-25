{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.rtorrent;
in
{
  options = {
    services.rtorrent = {
      enable = mkEnableOption "rtorrent system daemon (via tmux)";

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/rtorrent";
        description = "The directory where rtorrent stores its data files.";
      };

      configFile = mkOption {
        type = types.str;
        default = "/var/lib/rtorrent/rtorrent.rc";
        description = "The location of rtorrent's config file.";
      };

      user = mkOption {
        type = types.str;
        default = "rtorrent";
        description = "User account under which rtorrent runs.";
      };

      group = mkOption {
        type = types.str;
        default = "rtorrent";
        description = "Group under which rtorrent runs.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.rtorrent;
        defaultText = "pkgs.rtorrent";
        description = "The rtorrent package to use.";
      };
    };
  };

  config = mkIf cfg.enable {
    users.groups = mkIf (cfg.group == "rtorrent") {
      rtorrent = { gid = 276; };
    };
    users.extraUsers = mkIf (cfg.user == "rtorrent") {
      rtorrent = {
        uid = 276; group = cfg.group;
        shell = pkgs.bashInteractive;
        home = cfg.dataDir;
        createHome = true;
      };
    };

    systemd.services.rtorrent = {
    enable = true;
      description = "rTorrent system daemon (via tmux)";
      documentation = [
        "https://wiki.archlinux.org/index.php/RTorrent#systemd_service_file_with_tmux_or_screen"
      ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      # N.B. our default rtorrent.rc uses bash, which needs to be on the $PATH
      path = [ cfg.package pkgs.tmux pkgs.bash pkgs.procps ];
      serviceConfig = {
        Type = "forking";
        KillMode = "none";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${pkgs.tmux}/bin/tmux new-session -c ${cfg.dataDir} -s rtorrent -n rtorrent -d rtorrent -n -o import=${cfg.configFile}";
        ExecStop = "${pkgs.bash}/bin/bash -c \"tmux send-keys -t rtorrent C-q && while pidof rtorrent > /dev/null; do sleep 0.5; done\"";
        WorkingDirectory = "${cfg.dataDir}";
        Restart = "on-failure";
      };

      preStart = ''
test -f "${cfg.configFile}" || {
  echo "creating default rtorrent config file at \"${cfg.configFile}\"."
  cat > "${cfg.configFile}" << EOF
# See https://github.com/rakshasa/rtorrent/wiki/CONFIG-Template

# Instance layout (base paths)
method.insert = cfg.basedir, private|const|string, (cat,"${cfg.dataDir}")
method.insert = cfg.watch,   private|const|string, (cat,(cfg.basedir),"watch/")
method.insert = cfg.logs,    private|const|string, (cat,(cfg.basedir),"log/")
method.insert = cfg.logfile, private|const|string, (cat,(cfg.logs),"rtorrent-",(system.time),".log")

# Create instance directories
execute.throw = bash, -c, (cat,\
    "builtin cd \"", (cfg.basedir), "\" ",\
    "&& mkdir -p .session download log watch/{load,start}")

# Listening port for incoming peer traffic (fixed; you can also randomize it)
network.port_range.set = 50000-50000
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
network.max_open_sockets.set = 300

# Memory resource usage (increase if you have a large number of items loaded,
# and/or the available resources to spend)
pieces.memory.max.set = 1800M
network.xmlrpc.size_limit.set = 4M

# Basic operational settings (no need to change these)
session.path.set = (cat, (cfg.basedir), ".session/")
directory.default.set = (cat, (cfg.basedir), "download/")
log.execute = (cat, (cfg.logs), "execute.log")
##log.xmlrpc = (cat, (cfg.logs), "xmlrpc.log")
execute.nothrow = bash, -c, (cat, "echo >",\
    (session.path), "rtorrent.pid", " ", (system.pid))

# Other operational settings (check & adapt)
encoding.add = utf8
system.umask.set = 0027
system.cwd.set = (directory.default)
network.http.dns_cache_timeout.set = 25
##network.http.capath.set = "/etc/ssl/certs"
##network.http.ssl_verify_peer.set = 0
##network.http.ssl_verify_host.set = 0
##pieces.hash.on_completion.set = no
##keys.layout.set = qwerty

##view.sort_current = seeding, greater=d.ratio=
schedule2 = monitor_diskspace, 15, 60, ((close_low_diskspace, 1000M))

# Some additional values and commands
method.insert = system.startup_time, value|const, (system.time)
method.insert = d.data_path, simple,\
    "if=(d.is_multi_file),\
        (cat, (d.directory), /),\
        (cat, (d.directory), /, (d.name))"
method.insert = d.session_file, simple, "cat=(session.path), (d.hash), .torrent"

# Watch directories (add more as you like, but use unique schedule names)
schedule2 = watch_start, 10, 10, ((load.start, (cat, (cfg.watch), "start/*.torrent")))
schedule2 = watch_load, 11, 10, ((load.normal, (cat, (cfg.watch), "load/*.torrent")))

# Logging:
#   Levels = critical error warn notice info debug
#   Groups = connection_* dht_* peer_* rpc_* storage_* thread_* tracker_* torrent_*
print = (cat, "Logging to ", (cfg.logfile))
log.open_file = "log", (cfg.logfile)
log.add_output = "info", "log"
##log.add_output = "tracker_debug", "log"
EOF
}
     '';
    };
  };
}
