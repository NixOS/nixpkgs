{ config, lib, pkgs, ... }:

with lib;

let
  gid = config.ids.gids.mpdscribble;
  cfg = config.services.mpdscribble;

  mpdscribbleBaseConf = ''
    [mpdscribble]
    host = "${cfg.mpdHost}" # optional, defaults to $MPD_HOST or localhost
    port = "${cfg.mpdPort}" # optional, defaults to $MPD_PORT or 6600
    log = "${cfg.logFile}"
    verbose = ${cfg.verbosity}
    proxy = "${cfg.proxy}" # optional, e. g. http://your.proxy:8080, defaults to none
  '';

  mkCfgSection = name: cfgset:
    if cfgset.enable then
      ''
        [${name}]
        url = "${cfgset.url}"
        username = "${cfgset.username}"
        password = "${cfgset.password}"
        journal = "${cfgset.journal}"
      '' else "";

  mpdscribbleLastfmConf = mkCfgSection "last.fm" cfg.lastfm;
  mpdscribbleLibrefmConf = mkCfgSection "libre.fm" cfg.librefm;

  mpdscribbleConf = pkgs.writeText "mpdscribble.conf"
    (concatStrings
      mpdscribbleBaseConf
      mpdscribbleLastfmConf
      mpdscribbleLibrefmConf);
in
{
  options = {
    services.mpdscribble = {

      enable = mkEnableOption "mpdscribble, a scrobble client for mpd";

      user = mkOption {
        default = "mpdscribble";
        description = "User account under which mpdscribble runs.";
      };

      group = mkOption {
        default = "mpdscribble";
        description = "Group account under which mpdscribble runs.";
      };

      mpdHost = mkOption {
        default = "localhost";
        example = ''
          192.168.1.2
        '';
        type = types.string;
        description = ''
          MPD host
        '';
      };

      mpdPort = mkOption {
        default = 6600;
        type = types.int;
        description = ''
          MPD Port
        '';
      };

      logFile = mkOption {
        default = /dev/null;
        example = /home/user/.mpdscribble.log;
        type = types.path;
        description = ''
          Path of logfile
        '';
      };

      verbosity = mkOption {
        default = 2;
        example = 3;
        type = types.int;
        description = ''
          Verbosity of logging.
          "0" means log only critical errors (e.g. "out of memory");
          "1"  also logs non-critical  errors (e.g. "server unreachable");
          "2" logs informational messages (e.g.  "new song");
          "3" prints  a lot  of debugging messages.
        '';
      };

      proxy = mkOption {
        default = "";
        example = ''http://your.proxy:8080'';
        type = types.string;
        description = ''
          HTTP Proxy URL.
        '';
      };

      lastfm = {

        enable = mkOption {
          default = false;
          description = ''
            Enable Lastfm scrobbling.
          '';
        };

        url = mkOption {
          default = ''http://post.audioscrobbler.com/'';
          example = ''http://post.audioscrobbler.com/'';
          type = types.string;
          description = ''
            The handshake URL of the scrobbler.
          '';
        };

        username = mkOption {
          default = "";
          example = "";
          type = types.string;
          description = ''
            Last.fm User
          '';
        };

        password = mkOption {
          default = "";
          example = "";
          type = types.str;
          description = ''
            Last.fm Password

            You should really not specify your plain-text password here, but
            pass the MD5 hash of it, as mpdscribble suggests.

            For further information look here: http://dev.man-online.org/man1/mpdscribble/
            or in your local copy of the manpage.
          '';
        };

        journal = mkOption {
          default = "";
          example = /home/user/.mpdscribble.lastfm.cache;
          type = types.path;
          description = ''
            (Optional) file path for caching scrobbles when no internet connection
            is available.
          '';
        };

      };

      librefm = {

        enable = mkOption {
          default = false;
          description = ''
            Enable Librefm scrobbling.
          '';
        };

        url = mkOption {
          default = ''http://turtle.libre.fm/'';
          example = ''http://turtle.libre.fm/'';
          type = types.string;
          description = ''
            The handshake URL of the scrobbler.
          '';
        };

        username = mkOption {
          default = "";
          example = "";
          type = types.string;
          description = ''
            Librefm user.
          '';
        };

        password = mkOption {
          default = "";
          example = "";
          type = types.string;
          description = ''
            Librefm Password

            You should really not specify your plain-text password here, but
            pass the MD5 hash of it, as mpdscribble suggests.

            For further information look here: http://dev.man-online.org/man1/mpdscribble/
            or in your local copy of the manpage.
          '';
        };

        journal = mkOption {
          default = "";
          example = /home/user/.mpdscribble.librefm.cache;
          type = types.path;
          description = ''
            (Optional) file path for caching scrobbles when no internet connection
            is available.
          '';
        };

      };

    };

  };

  config = mkIf cfg.enable {
    systemd.services.mpdscribble = {
      after         = [ "mpd.service" ];
      description   = "MPD scrobble client for lastfm/librefm";
      wants         = [ "mpd.service" ];
      preStart      = ''
        mkdir -p ${dirOf cfg.lastfm.journal}
        mkdir -p ${dirOf cfg.librefm.journal}
        mkdir -p ${dirOf cfg.logFile}
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${pkgs.mpdscribble}/bin/mpdscribble --no-daemon --host localhost --conf ${mpdscribbleConf}";
        PermissionsStartOnly = true;
      };

    };

    environment.systemPackages = [ mpdscribble ];
  };

}
