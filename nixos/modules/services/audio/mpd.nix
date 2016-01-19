{ config, lib, pkgs, ... }:

with lib;

let

  uid = config.ids.uids.mpd;
  gid = config.ids.gids.mpd;
  cfg = config.services.mpd;

  mpdConf = pkgs.writeText "mpd.conf" ''
    music_directory     "${cfg.musicDirectory}"
    playlist_directory  "${cfg.dataDir}/playlists"
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
        default = false;
        description = ''
          Whether to enable MPD, the music player daemon.
        '';
      };

      musicDirectory = mkOption {
        default = "${cfg.dataDir}/music";
        description = ''
          The directory where mpd reads music from.
        '';
      };

      extraConfig = mkOption {
        default = "";
        description = ''
          Extra directives added to to the end of MPD's configuration file,
          mpd.conf. Basic configuration like file location and uid/gid
          is added automatically to the beginning of the file.
        '';
      };

      dataDir = mkOption {
        default = "/var/lib/mpd";
        description = ''
          The directory where MPD stores its state, tag cache,
          playlists etc.
        '';
      };

      user = mkOption {
        default = "mpd";
        description = "User account under which MPD runs.";
      };

      group = mkOption {
        default = "mpd";
        description = "Group account under which MPD runs.";
      };

      network = {

        listenAddress = mkOption {
          default = "any";
          description = ''
            This setting sets the address for the daemon to listen on. Careful attention
            should be paid if this is assigned to anything other then the default, any.
            This setting can deny access to control of the daemon.
          '';
        };

        port = mkOption {
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

    systemd.services.mpd = {
      after = [ "network.target" "sound.target" ];
      description = "Music Player Daemon";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.mpd ];
      preStart = "mkdir -p ${cfg.dataDir} && chown -R ${cfg.user}:${cfg.group} ${cfg.dataDir}";
      script = "exec mpd --no-daemon ${mpdConf}";
      serviceConfig = {
        User = "${cfg.user}";
        PermissionsStartOnly = true;
      };
    };

    users.extraUsers = optionalAttrs (cfg.user == "mpd") (singleton {
      inherit uid;
      name = "mpd";
      group = cfg.group;
      extraGroups = [ "audio" ];
      description = "Music Player Daemon user";
      home = "${cfg.dataDir}";
    });

    users.extraGroups = optionalAttrs (cfg.group == "mpd") (singleton {
      name = "mpd";
      gid = gid;
    });
  };

}
