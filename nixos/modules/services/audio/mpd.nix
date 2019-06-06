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

      startSystemWide = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to run mpd as a system user (appliance mode).
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

      addBinariesToGlobalEnvironment = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to add the client and server binaries to the global environment.
        '';
      };
    };

  };


  ###### implementation

  config = mkIf cfg.enable (let
    description = "Music Player Daemon Socket";
    listenStreams = [
      "" # we need an empty string to reset the list instead of just adding
      "%t/mpd/socket"
      "${optionalString (cfg.network.listenAddress != "any") "${cfg.network.listenAddress}:"}${toString cfg.network.port}"
    ];
    wantedBy = [ "sockets.target" ];
  in {
    environment.systemPackages = lib.mkIf cfg.addBinariesToGlobalEnvironment (with pkgs; [ mpc_cli mpd ]);

    systemd.packages = with pkgs; [ mpd ];

    systemd.sockets.mpd = mkIf cfg.startSystemWide {
      inherit description listenStreams wantedBy;
    };

    systemd.user.sockets.mpd = mkIf (!cfg.startSystemWide) {
      inherit description listenStreams wantedBy;
    };

    systemd.tmpfiles.rules = lib.mkIf cfg.startSystemWide [
      "d '${cfg.dataDir}' - ${cfg.user} ${cfg.group} - -"
      "d '${cfg.playlistDirectory}' - ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.mpd = lib.mkIf cfg.startSystemWide {
      wantedBy = optional (!cfg.startWhenNeeded) "multi-user.target";

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = [
          ""
          "${pkgs.mpd}/bin/mpd --no-daemon ${mpdConf}"
        ];
      };
    };

    users.users = lib.mkIf cfg.startSystemWide (optionalAttrs (cfg.user == name) (singleton {
      inherit uid;
      inherit name;
      group = cfg.group;
      extraGroups = [ "audio" ];
      description = "Music Player Daemon user";
      home = "${cfg.dataDir}";
    }));

    users.groups = lib.mkIf cfg.startSystemWide (optionalAttrs (cfg.group == name) (singleton {
      inherit name;
      gid = gid;
    }));
  });

}
