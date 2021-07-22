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
      defaultText = literalExpression ''"''${config.networking.hostName} MiniDLNA"'';
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
      default = 90000;
      example = 895;
      description =
        ''
          The interval between announces (in seconds).

          By default miniDLNA will announce its presence on the network
          approximately every 15 minutes.

          Many people prefer shorter announce intervals (e.g. 60 seconds)
          on their home networks, especially when DLNA clients are
          started on demand.

          Instead of waiting on announces, one can open the port UDP 1900
          to use SSDP discovery. Setting openFirewall option does this
          automatically. Furthermore announce interval has been set to
          90000 to prevent disconnects with certain clients. The default
          value of 895 can be used if one does not want to utilize SSDP.

          Some relevant information can be found here:
          https://sourceforge.net/p/minidlna/discussion/879957/thread/1389d197/
        '';
    };

    services.minidlna.openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to open both HTTP (TCP) and SSDP (UDP) ports in the firewall.
        '';
      };

    services.minidlna.inotify = mkOption {
      type = types.enum [ "yes" "no" ];
      default = "no";
      example = "yes";
      description =
        ''
          Whether to enable inotify monitoring to automatically discover new files.
        '';
    };

    services.minidlna.databaseDir = mkOption {
      type = types.str;
      default = "/var/cache/minidlna";
      example = "/tmp/minidlna";
      description =
        ''
          Specify the directory where you want MiniDLNA to store its database and album art cache.
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
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ port ];
    networking.firewall.allowedUDPPorts = mkIf cfg.openFirewall [ 1900 ];

    services.minidlna.config =
      ''
        port=${toString port}
        friendly_name=${cfg.friendlyName}
        db_dir=${cfg.databaseDir}
        log_level=${cfg.loglevel}
        inotify=${cfg.inotify}
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
