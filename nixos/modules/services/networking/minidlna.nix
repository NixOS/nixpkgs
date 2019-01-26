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

    services.minidlna.config = mkOption {
      type = types.lines;
      description = "The contents of MiniDLNA's configuration file.";
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    services.minidlna.config =
      ''
        port=${toString port}
        friendly_name=${config.networking.hostName} MiniDLNA
        db_dir=/var/cache/minidlna
        log_level=${cfg.loglevel}
        inotify=yes
        ${concatMapStrings (dir: ''
          media_dir=${dir}
        '') cfg.mediaDirs}
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
        after = [ "network.target" "local-fs.target" ];

        preStart =
          ''
            mkdir -p /var/cache/minidlna
            chown -R minidlna:minidlna /var/cache/minidlna
          '';

        serviceConfig =
          { User = "minidlna";
            Group = "minidlna";
            PermissionsStartOnly = true;
            RuntimeDirectory = "minidlna";
            PIDFile = "/run/minidlna/pid";
            ExecStart =
              "${pkgs.minidlna}/sbin/minidlnad -S -P /run/minidlna/pid" +
              " -f ${pkgs.writeText "minidlna.conf" cfg.config}";
          };
      };
  };
}
