# Module for MiniDLNA, a simple DLNA server.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.minidlna;
  port = 8200;
in

{
  ###### interface
  options = {
    services.minidlna.enable = mkOption {
      type = types.bool;
      default = false;
      description =
        ''
          Whether to enable MiniDLNA, a simple DLNA server.  It serves
          media files such as video and music to DLNA client devices
          such as televisions and media players.
        '';
    };

    services.minidlna.mediaDirs = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "/data/media" "V,/home/alice/video" ];
      description =
        ''
          Directories to be scanned for media files.  The prefixes
          <literal>A,</literal>, <literal>V,</literal> and
          <literal>P,</literal> restrict a directory to audio, video
          or image files.  The directories must be accessible to the
          <literal>minidlna</literal> user account.
        '';
    };

    services.minidlna.friendlyName = mkOption {
      type = types.str;
      default = "${config.networking.hostName} MiniDLNA";
      defaultText = "$HOSTNAME MiniDLNA";
      example = "rpi3";
      description =
        ''
          Name that the DLNA server presents to clients.
        '';
    };

    services.minidlna.rootContainer = mkOption {
      type = types.str;
      default = ".";
      example = "B";
      description =
        ''
          Use a different container as the root of the directory tree presented
          to clients. The possible values are:
          - "." - standard container
          - "B" - "Browse Directory"
          - "M" - "Music"
          - "P" - "Pictures"
          - "V" - "Video"
          - Or, you can specify the ObjectID of your desired root container
            (eg. 1$F for Music/Playlists)
          If you specify "B" and the client device is audio-only then
          "Music/Folders" will be used as root.
         '';
    };

    services.minidlna.loglevel = mkOption {
      type = types.str;
      default = "warn";
      example = "general,artwork,database,inotify,scanner,metadata,http,ssdp,tivo=warn";
      description =
        ''
          Defines the type of messages that should be logged, and down to
          which level of importance they should be considered.

          The possible types are “artwork”, “database”, “general”, “http”,
          “inotify”, “metadata”, “scanner”, “ssdp” and “tivo”.

          The levels are “off”, “fatal”, “error”, “warn”, “info” and
          “debug”, listed here in order of decreasing importance.  “off”
          turns off logging messages entirely, “fatal” logs the most
          critical messages only, and so on down to “debug” that logs every
          single messages.

          The types are comma-separated, followed by an equal sign (‘=’),
          followed by a level that applies to the preceding types. This can
          be repeated, separating each of these constructs with a comma.

          Defaults to “general,artwork,database,inotify,scanner,metadata,
          http,ssdp,tivo=warn” which logs every type of message at the
          “warn” level.
        '';
    };

    services.minidlna.announceInterval = mkOption {
      type = types.int;
      default = 895;
      description =
        ''
          The interval between announces (in seconds).

          By default miniDLNA will announce its presence on the network
          approximately every 15 minutes.

          Many people prefer shorter announce intervals (e.g. 60 seconds)
          on their home networks, especially when DLNA clients are
          started on demand.
        '';
    };

    services.minidlna.config = mkOption {
      type = types.lines;
      description =
      ''
        The contents of MiniDLNA's configuration file.
        When the service is activated, a basic template is generated
        from the current options opened here.
      '';
    };

    services.minidlna.extraConfig = mkOption {
      type = types.lines;
      default = "";
      example = ''
        # Not exhaustive example
        # Support for streaming .jpg and .mp3 files to a TiVo supporting HMO.
        enable_tivo=no
        # SSDP notify interval, in seconds.
        notify_interval=10
        # maximum number of simultaneous connections
        # note: many clients open several simultaneous connections while
        # streaming
        max_connections=50
        # set this to yes to allow symlinks that point outside user-defined
        # media_dirs.
        wide_links=yes
      '';
      description =
      ''
        Extra minidlna options not yet opened for configuration here
        (strict_dlna, model_number, model_name, etc...).  This is appended
        to the current service already provided.
      '';
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    services.minidlna.config =
      ''
        port=${toString port}
        friendly_name=${cfg.friendlyName}
        db_dir=/var/cache/minidlna
        log_level=${cfg.loglevel}
        inotify=yes
        root_container=${cfg.rootContainer}
        ${concatMapStrings (dir: ''
          media_dir=${dir}
        '') cfg.mediaDirs}
        notify_interval=${toString cfg.announceInterval}
        ${cfg.extraConfig}
      '';

    users.users.minidlna = {
      description = "MiniDLNA daemon user";
      group = "minidlna";
      uid = config.ids.uids.minidlna;
    };

    users.groups.minidlna.gid = config.ids.gids.minidlna;

    systemd.services.minidlna =
      { description = "MiniDLNA Server";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig =
          { User = "minidlna";
            Group = "minidlna";
            CacheDirectory = "minidlna";
            RuntimeDirectory = "minidlna";
            PIDFile = "/run/minidlna/pid";
            ExecStart =
              "${pkgs.minidlna}/sbin/minidlnad -S -P /run/minidlna/pid" +
              " -f ${pkgs.writeText "minidlna.conf" cfg.config}";
          };
      };
  };
}
