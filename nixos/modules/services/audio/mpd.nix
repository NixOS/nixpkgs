{ config, lib, pkgs, ... }:

with lib;

let

  name = "mpd";

  uid = config.ids.uids.mpd;
  gid = config.ids.gids.mpd;
  cfg = config.services.mpd;

  mpdConf = pkgs.writeText "mpd.conf" ''
    music_directory     "${cfg.musicDirectory}"
    playlist_directory  "${cfg.playlistDirectory}"
    ${lib.optionalString (cfg.dbFile != null) ''
      db_file             "${cfg.dbFile}"
    ''}
    state_file          "${cfg.dataDir}/state"
    sticker_file        "${cfg.dataDir}/sticker.sql"
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
        type = with types; either path (strMatching "(http|https|nfs|smb)://.+");
        default = "${cfg.dataDir}/music";
        defaultText = ''''${dataDir}/music'';
        description = ''
          The directory or NFS/SMB network share where mpd reads music from.
        '';
      };

      playlistDirectory = mkOption {
        type = types.path;
        default = "${cfg.dataDir}/playlists";
        defaultText = ''''${dataDir}/playlists'';
        description = ''
          The directory where mpd stores playlists.
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
        type = types.nullOr types.str;
        default = "${cfg.dataDir}/tag_cache";
        defaultText = ''''${dataDir}/tag_cache'';
        description = ''
          The path to MPD's database. If set to <literal>null</literal> the
          parameter is omitted from the configuration.
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

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' - ${cfg.user} ${cfg.group} - -"
      "d '${cfg.playlistDirectory}' - ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.mpd = {
      after = [ "network.target" "sound.target" ];
      description = "Music Player Daemon";
      wantedBy = optional (!cfg.startWhenNeeded) "multi-user.target";

      serviceConfig = {
        User = "${cfg.user}";
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
        Restart = "always";
      };
    };

    users.users = optionalAttrs (cfg.user == name) {
      ${name} = {
        inherit uid;
        group = cfg.group;
        extraGroups = [ "audio" ];
        description = "Music Player Daemon user";
        home = "${cfg.dataDir}";
      };
    };

    users.groups = optionalAttrs (cfg.group == name) {
      ${name}.gid = gid;
    };
  };

}
