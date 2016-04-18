{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.subsonic;
  homeDir = "/var/subsonic";

in
{
  options = {
    services.subsonic = {
      enable = mkEnableOption "Subsonic daemon";

      home = mkOption {
        type = types.path;
        default = "${homeDir}";
        description = ''
          The directory where Subsonic will create files.
          Make sure it is writable.
        '';
      };

      listenAddress = mkOption {
        type = types.string;
        default = "0.0.0.0";
        description = ''
          The host name or IP address on which to bind Subsonic.
          Only relevant if you have multiple network interfaces and want
          to make Subsonic available on only one of them. The default value
          will bind Subsonic to all available network interfaces.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 4040;
        description = ''
          The port on which Subsonic will listen for
          incoming HTTP traffic. Set to 0 to disable.
        '';
      };

      httpsPort = mkOption {
        type = types.int;
        default = 0;
        description = ''
          The port on which Subsonic will listen for
          incoming HTTPS traffic. Set to 0 to disable.
        '';
      };

      contextPath = mkOption {
        type = types.path;
        default = "/";
        description = ''
          The context path, i.e., the last part of the Subsonic
          URL. Typically '/' or '/subsonic'. Default '/'
        '';
      };

      maxMemory = mkOption {
        type = types.int;
        default = 100;
        description = ''
          The memory limit (max Java heap size) in megabytes.
          Default: 100
        '';
      };

      defaultMusicFolder = mkOption {
        type = types.path;
        default = "/var/music";
        description = ''
          Configure Subsonic to use this folder for music.  This option
          only has effect the first time Subsonic is started.
        '';
      };

      defaultPodcastFolder = mkOption {
        type = types.path;
        default = "/var/music/Podcast";
        description = ''
          Configure Subsonic to use this folder for Podcasts.  This option
          only has effect the first time Subsonic is started.
        '';
      };

      defaultPlaylistFolder = mkOption {
        type = types.path;
        default = "/var/playlists";
        description = ''
          Configure Subsonic to use this folder for playlists.  This option
          only has effect the first time Subsonic is started.
        '';
      };

      transcoders = mkOption {
        type = types.listOf types.path;
        default = [ "${pkgs.ffmpeg.bin}/bin/ffmpeg" ];
        description = ''
          List of paths to transcoder executables that should be accessible
          from Subsonic. Symlinks will be created to each executable inside
          ${cfg.home}/transcoders.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.subsonic = {
      description = "Personal media streamer";
      after = [ "local-fs.target" "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.jre}/bin/java -Xmx${toString cfg.maxMemory}m \
            -Dsubsonic.home=${cfg.home} \
            -Dsubsonic.host=${cfg.listenAddress} \
            -Dsubsonic.port=${toString cfg.port} \
            -Dsubsonic.httpsPort=${toString cfg.httpsPort} \
            -Dsubsonic.contextPath=${cfg.contextPath} \
            -Dsubsonic.defaultMusicFolder=${cfg.defaultMusicFolder} \
            -Dsubsonic.defaultPodcastFolder=${cfg.defaultPodcastFolder} \
            -Dsubsonic.defaultPlaylistFolder=${cfg.defaultPlaylistFolder} \
            -Djava.awt.headless=true \
            -verbose:gc \
            -jar ${pkgs.subsonic}/subsonic-booter-jar-with-dependencies.jar
        '';
        # Install transcoders.
        ExecStartPre = ''
          ${pkgs.coreutils}/bin/rm -rf ${cfg.home}/transcode ; \
          ${pkgs.coreutils}/bin/mkdir -p ${cfg.home}/transcode ; \
          ${pkgs.bash}/bin/bash -c ' \
            for exe in "$@"; do \
              ${pkgs.coreutils}/bin/ln -sf "$exe" ${cfg.home}/transcode; \
            done' IGNORED_FIRST_ARG ${toString cfg.transcoders}
        '';
        # Needed for Subsonic to find subsonic.war.
        WorkingDirectory = "${pkgs.subsonic}";
        Restart = "always";
        User = "subsonic";
        UMask = "0022";
      };
    };

    users.extraUsers.subsonic = {
      description = "Subsonic daemon user";
      home = homeDir;
      createHome = true;
      group = "subsonic";
      uid = config.ids.uids.subsonic;
    };

    users.extraGroups.subsonic.gid = config.ids.gids.subsonic;
  };
}
