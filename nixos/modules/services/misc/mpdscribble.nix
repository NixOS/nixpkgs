{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.mpdscribble;

  mkSection = cfg: optname: secname:
    if cfg."${optname}" then
      ''
        [${secname}]
        url      = ${cfg."${optname}".url}
        username = ${cfg."${optname}".username}
        password = ${cfg."${optname}".password}
        journal  = ${cfg."${optname}".journal}
      '' else "";

  cfgFile = pkgs.writeText "mpdscribble.conf" ''
## mpdscribble - an audioscrobbler for the Music Player Daemon.
## http://mpd.wikia.com/wiki/Client:mpdscribble

# HTTP proxy URL.
${if isNull cfg.proxy then "" else "proxy = ${cfg.proxy}"}

# The location of the pid file.  mpdscribble saves its process id there.
pidfile = ${cfg.pidfile}

# Change to this system user after daemonization.
daemon_user = ${cfg.daemonUser}

# The location of the mpdscribble log file.  The special value
# "syslog" makes mpdscribble use the local syslog daemon.  On most
# systems, log messages will appear in /var/log/daemon.log then.
# "-" means log to stderr (the current terminal).
log = ${cfg.logFile}

# How verbose mpdscribble's logging should be.  Default is 1.
verbose = ${cfg.verbose}

# How often should mpdscribble save the journal file? [seconds]
journal_interval = ${cfg.journalInterval}

# The host running MPD, possibly protected by a password
# ([PASSWORD@]HOSTNAME).  Defaults to $MPD_HOST or localhost.
host = ${cfg.host}

# The port that the MPD listens on and mpdscribble should try to
# connect to.  Defaults to $MPD_PORT or 6600.
port = ${cfg.port}

${mkSection cfg "lastfm" "last.fm"}
${mkSection cfg "librefm" "libre.fm"}
${mkSection cfg "jamendo" "jamendo"}
'';
in

{
  ###### interface

  options = {

    services.mpdscribble = {

      enable = mkOption {
        default = false;
        description = "
          Whether to enable mpdscribble.
        ";
      };

      proxy = mkOption {
        default = null;
        type = types.nullOr types.str;
        description = ''
          HTTP proxy URL.
        '';
      };

      pidfile = mkOption {
        default = "/var/run/mpdscribble.pid";
        type = types.path;
        description = ''
          The location of the pid file. mpdscribble saves its process id there.
        '';
      };

      daemonUser = mkOption {
        default = "mpdscribble";
        description = ''
          Change to this system user after daemonization.
        '';
      };

      logFile = mkOption {
        default = "/dev/null";
        example = "/tmp/mpdscribble.log";
        description = ''
          Location of the logfile.
        '';
      };

      verbose = mkOption {
        default = 1;
        type = types.int;
        description = ''
          Log level for the mpdscribble daemon.
        '';
      };

      journalInterval = mkOption {
        default = 600;
        example = 60;
        type = types.int;
        description = ''
          How often should mpdscribble save the journal file? [seconds]
        '';
      };

      host = mkOption {
        default = "localhost";
        type = types.str;
        description = ''
          Host for the mpdscribble daemon to search for a mpd daemon on.
        '';
      };

      port = mkOption {
        default = "localhost";
        type = types.int;
        description = ''
          Port for the mpdscribble daemon to search for a mpd daemon on.
        '';
      };

      lastfm = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = "Whether to enable the mpdscribble daemon for lastfm.";
        };

        url  = mkOption {
          default = false;
          type = types.str;
          description = "
            Whether to enable the mpdscribble daemon for lastfm.
          ";
        };

        username = mkOption {
          default = "";
          type = types.str;
          description = "
            Lastfm username.
          ";
        };

        password = mkOption {
          default = false;
          type = types.str;
          description = "
            Lastfm Password. Attention: This will be stored in the globally
            readable /nix/store.
          ";
        };

        journal = mkOption {
          default = "/var/lib/mpdscribble/lastfm.journal";
          type = types.path;
          description = ''
            Journal file for the lastfm backend.
            Should be changed from the default.
          '';
        };

      };

      librefm = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = "
            Whether to enable the mpdscribble daemon for librefm.
          ";
        };

        url  = mkOption {
          default = false;
          type = types.str;
          description = "
            Whether to enable the mpdscribble daemon for librefm.
          ";
        };

        username = mkOption {
          default = "";
          type = types.str;
          description = "
            Librefm username.
          ";
        };

        password = mkOption {
          default = false;
          type = types.str;
          description = "
            Librefm Password. Attention: This will be stored in the globally
            readable /nix/store.
          ";
        };

        journal = mkOption {
          default = "/var/lib/mpdscribble/librefm.journal";
          type = types.path;
          description = "
            Journal file for the librefm backend.
            Should be changed from the default.
          ";
        };

      };

      jamendo = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = "
            Whether to enable the mpdscribble daemon for jamendo.
          ";
        };

        url  = mkOption {
          default = false;
          type = types.str;
          description = "
            Whether to enable the mpdscribble daemon for jamendo.
          ";
        };

        username = mkOption {
          default = "";
          type = types.str;
          description = "
            Jamendo username.
          ";
        };

        password = mkOption {
          default = false;
          type = types.str;
          description = "
            Jamendo Password. Attention: This will be stored in the globally
            readable /nix/store.
          ";
        };

        journal = mkOption {
          default = "/var/lib/mpdscribble/jamendo.journal";
          type = types.path;
          description = "
            Journal file for the jamendo backend.
            Should be changed from the default.
          ";
        };

      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {
      systemd.services.mpdscribble = {
        after                   = [ "mpd.service" "network.target" ];
        description             = "mpdscribble mpd scrobble client";
        wantedBy                = "multi-user.target";
        User                    = "mpdscribble";
        serviceConfig.ExecStart = ''
          ${pkgs.mpdscribble}/bin/mpdscribble --conf ${cfg}
        '';
      };
    };

}

