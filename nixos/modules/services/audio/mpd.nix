{ config, lib, pkgs, ... }:

with lib;

let

  uid = config.ids.uids.mpd;
  gid = config.ids.gids.mpd;
  cfg = config.services.mpd;

  mpdConf = pkgs.writeText "mpd.conf" ''
    music_directory     "${cfg.musicDirectory}"
    playlist_directory  "${cfg.dataDir}/playlists"
    db_file             "${cfg.dataDir}/tag_cache"
    state_file          "${cfg.dataDir}/state"
    sticker_file        "${cfg.dataDir}/sticker.sql"
    log_file            "syslog"
    user                "mpd"
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
          Extra configuration added to the end of MPD's
          configuration file, mpd.conf.
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

    };  

  };  


  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.mpd = {
      after = [ "network.target" "sound.target" ];
      description = "Music Player Daemon";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.mpd ];
      preStart = "mkdir -p ${cfg.dataDir} && chown -R mpd:mpd  ${cfg.dataDir}";
      script = "exec mpd --no-daemon ${mpdConf}";
    };

    users.extraUsers.mpd = {
      inherit uid;
      group = "mpd";
      extraGroups = [ "audio" ];
      description = "Music Player Daemon user";
      home = "${cfg.dataDir}";
    };

    users.extraGroups.mpd.gid = gid;

  };

}
