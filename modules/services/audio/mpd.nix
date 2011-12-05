{ config, pkgs, ... }:

with pkgs.lib;

let

  uid = config.ids.uids.mpd;
  gid = config.ids.gids.mpd;

in

{

  ###### interface

  options = {

    services.mpd = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to enable the MPD music player daemon (server).
        '';
      };

      conffile = mkOption {
        default = ''
          music_directory     "${config.services.mpd.dataDir}/music"
          playlist_directory  "${config.services.mpd.dataDir}/playlists"
          db_file             "${config.services.mpd.dataDir}/tag_cache"
          state_file          "${config.services.mpd.dataDir}/state"
          sticker_file        "${config.services.mpd.dataDir}/sticker.sql"
          log_file            "/var/log/mpd.log"
          pid_file            "/var/run/mpd/mpd.pid"
          bind_to_address     "localhost"
          user                "mpd"
        '';
        description = ''The contents of the MPD configuration file mpd.conf'';
      };

      dataDir = mkOption {
        default = "/var/lib/mpd/";
        example = "debug";
        description = ''
          The root directory of the MPD data tree. Contains a tag cache,
	  playlists and a music/ subdirectory that should contain (or
          symlink to) your music collection.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.mpd.enable {

    environment.systemPackages = [ pkgs.mpd ];

    users.extraUsers = singleton
      { name = "mpd";
        group = "mpd";
        extraGroups = [ "audio" ];
        description = "MPD system-wide daemon";
        home = "${config.services.mpd.dataDir}";
      };

    users.extraGroups = singleton
      { name = "mpd";
        inherit gid;
      };

    jobs.mpd =
      { description = "MPD system-wide server";

        startOn = "startup";

        preStart =
          ''
            mkdir -p /var/run/mpd && chown mpd /var/run/mpd
            test -d ${config.services.mpd.dataDir} || \
            ( mkdir -p --mode 755 ${config.services.mpd.dataDir}/music \
                                  ${config.services.mpd.dataDir}/playlists && \
              chown -R mpd:mpd ${config.services.mpd.dataDir} )
          '';

        daemonType = "fork";
        exec =
          ''
            ${pkgs.mpd}/bin/mpd ${pkgs.writeText "mpd.conf" config.services.mpd.conffile}
          '';
      };

  };

}
