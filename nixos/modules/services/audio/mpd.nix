{ config, lib, pkgs, ... }:

with lib;

let

  name = "mpd";

  uid = config.ids.uids.mpd;
  gid = config.ids.gids.mpd;
  cfg = config.services.mpd;

  playlistDir = "${cfg.dataDir}/playlists";

  mpdConf = pkgs.writeText "mpd.conf" ''
    music_directory     "${cfg.musicDirectory}"
    playlist_directory  "${playlistDir}"
    db_file             "${cfg.dbFile}"
    state_file          "${cfg.dataDir}/state"
    sticker_file        "${cfg.dataDir}/sticker.sql"
    log_file            "syslog"
    user                "${cfg.user}"
    group               "${cfg.group}"

    ${optionalString (cfg.network.listenAddress != "any") ''bind_to_address "${cfg.network.listenAddress}"''}
    ${optionalString (cfg.network.port != 6600)  ''port "${toString cfg.network.port}"''}

    ${cfg.extraConfig}
  '';

in {

  ###### interface

  options = {

    services.mpd = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable MPD, the music player daemon.
        '';
      };

      startWhenNeeded = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If set, <command>mpd</command> is socket-activated; that
          is, instead of having it permanently running as a daemon,
          systemd will start it on the first incoming connection.
        '';
      };

      musicDirectory = mkOption {
        type = types.path;
        default = "${cfg.dataDir}/music";
        description = ''
          The directory where mpd reads music from.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra directives added to to the end of MPD's configuration file,
          mpd.conf. Basic configuration like file location and uid/gid
          is added automatically to the beginning of the file. For available
          options see <literal>man 5 mpd.conf</literal>'.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/${name}";
        description = ''
          The directory where MPD stores its state, tag cache,
          playlists etc.
        '';
      };

      user = mkOption {
        type = types.str;
        default = name;
        description = "User account under which MPD runs.";
      };

      group = mkOption {
        type = types.str;
        default = name;
        description = "Group account under which MPD runs.";
      };

      network = {

        listenAddress = mkOption {
          type = types.str;
          default = "127.0.0.1";
          example = "any";
          description = ''
            The address for the daemon to listen on.
            Use <literal>any</literal> to listen on all addresses.
          '';
        };

        port = mkOption {
          type = types.int;
          default = 6600;
          description = ''
            This setting is the TCP port that is desired for the daemon to get assigned
            to.
          '';
        };

      };

      dbFile = mkOption {
        type = types.str;
        default = "${cfg.dataDir}/tag_cache";
        description = ''
          The path to MPD's database.
        '';
      };
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    systemd.sockets.mpd = mkIf cfg.startWhenNeeded {
      description = "Music Player Daemon Socket";
      wantedBy = [ "sockets.target" ];
      listenStreams = [
        "${optionalString (cfg.network.listenAddress != "any") "${cfg.network.listenAddress}:"}${toString cfg.network.port}"
      ];
      socketConfig = {
        Backlog = 5;
        KeepAlive = true;
        PassCredentials = true;
      };
    };

    systemd.services.mpd = {
      after = [ "network.target" "sound.target" ];
      description = "Music Player Daemon";
      wantedBy = optional (!cfg.startWhenNeeded) "multi-user.target";

      preStart = ''
        mkdir -p "${cfg.dataDir}" && chown -R ${cfg.user}:${cfg.group} "${cfg.dataDir}"
        mkdir -p "${playlistDir}" && chown -R ${cfg.user}:${cfg.group} "${playlistDir}"
      '';
      serviceConfig = {
        User = "${cfg.user}";
        PermissionsStartOnly = true;
        ExecStart = "${pkgs.mpd}/bin/mpd --no-daemon ${mpdConf}";
        Type = "notify";
        LimitRTPRIO = 50;
        LimitRTTIME = "infinity";
        ProtectSystem = true;
        NoNewPrivileges = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX AF_NETLINK";
        RestrictNamespaces = true;
      };
    };

    users.extraUsers = optionalAttrs (cfg.user == name) (singleton {
      inherit uid;
      inherit name;
      group = cfg.group;
      extraGroups = [ "audio" ];
      description = "Music Player Daemon user";
      home = "${cfg.dataDir}";
    });

    users.extraGroups = optionalAttrs (cfg.group == name) (singleton {
      inherit name;
      gid = gid;
    });
  };

}
