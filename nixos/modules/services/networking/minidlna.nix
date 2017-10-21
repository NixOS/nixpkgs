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
        log_level=warn
        inotify=yes
        ${concatMapStrings (dir: ''
          media_dir=${dir}
        '') cfg.mediaDirs}
      '';

    users.extraUsers.minidlna = {
      description = "MiniDLNA daemon user";
      group = "minidlna";
      uid = config.ids.uids.minidlna;
    };

    users.extraGroups.minidlna.gid = config.ids.gids.minidlna;

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
