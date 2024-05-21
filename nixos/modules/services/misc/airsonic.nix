{ config, lib, options, pkgs, ... }:

with lib;

let
  cfg = config.services.airsonic;
  opt = options.services.airsonic;
in {
  options = {

    services.airsonic = {
      enable = mkEnableOption "Airsonic, the Free and Open Source media streaming server (fork of Subsonic and Libresonic)";

      user = mkOption {
        type = types.str;
        default = "airsonic";
        description = "User account under which airsonic runs.";
      };

      home = mkOption {
        type = types.path;
        default = "/var/lib/airsonic";
        description = ''
          The directory where Airsonic will create files.
          Make sure it is writable.
        '';
      };

      virtualHost = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Name of the nginx virtualhost to use and setup. If null, do not setup any virtualhost.
        '';
      };

      listenAddress = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = ''
          The host name or IP address on which to bind Airsonic.
          The default value is appropriate for first launch, when the
          default credentials are easy to guess. It is also appropriate
          if you intend to use the virtualhost option in the service
          module. In other cases, you may want to change this to a
          specific IP or 0.0.0.0 to listen on all interfaces.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 4040;
        description = ''
          The port on which Airsonic will listen for
          incoming HTTP traffic. Set to 0 to disable.
        '';
      };

      contextPath = mkOption {
        type = types.path;
        default = "/";
        description = ''
          The context path, i.e., the last part of the Airsonic
          URL. Typically '/' or '/airsonic'. Default '/'
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

      transcoders = mkOption {
        type = types.listOf types.path;
        default = [ "${pkgs.ffmpeg.bin}/bin/ffmpeg" ];
        defaultText = literalExpression ''[ "''${pkgs.ffmpeg.bin}/bin/ffmpeg" ]'';
        description = ''
          List of paths to transcoder executables that should be accessible
          from Airsonic. Symlinks will be created to each executable inside
          ''${config.${opt.home}}/transcoders.
        '';
      };

      jre = mkPackageOption pkgs "jre8" {
        extraDescription = ''
          ::: {.note}
          Airsonic only supports Java 8, airsonic-advanced requires at least
          Java 11.
          :::
        '';
      };

      war = mkOption {
        type = types.path;
        default = "${pkgs.airsonic}/webapps/airsonic.war";
        defaultText = literalExpression ''"''${pkgs.airsonic}/webapps/airsonic.war"'';
        description = "Airsonic war file to use.";
      };

      jvmOptions = mkOption {
        description = ''
          Extra command line options for the JVM running AirSonic.
          Useful for sending jukebox output to non-default alsa
          devices.
        '';
        default = [
        ];
        type = types.listOf types.str;
        example = [
          "-Djavax.sound.sampled.Clip='#CODEC [plughw:1,0]'"
          "-Djavax.sound.sampled.Port='#Port CODEC [hw:1]'"
          "-Djavax.sound.sampled.SourceDataLine='#CODEC [plughw:1,0]'"
          "-Djavax.sound.sampled.TargetDataLine='#CODEC [plughw:1,0]'"
        ];
      };

    };
  };

  config = mkIf cfg.enable {
    systemd.services.airsonic = {
      description = "Airsonic Media Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        # Install transcoders.
        rm -rf ${cfg.home}/transcode
        mkdir -p ${cfg.home}/transcode
        for exe in ${toString cfg.transcoders}; do
          ln -sf "$exe" ${cfg.home}/transcode
        done
      '';
      serviceConfig = {
        ExecStart = ''
          ${cfg.jre}/bin/java -Xmx${toString cfg.maxMemory}m \
          -Dairsonic.home=${cfg.home} \
          -Dserver.address=${cfg.listenAddress} \
          -Dserver.port=${toString cfg.port} \
          -Dairsonic.contextPath=${cfg.contextPath} \
          -Djava.awt.headless=true \
          ${optionalString (cfg.virtualHost != null)
            "-Dserver.use-forward-headers=true"} \
          ${toString cfg.jvmOptions} \
          -verbose:gc \
          -jar ${cfg.war}
        '';
        Restart = "always";
        User = "airsonic";
        UMask = "0022";
      };
    };

    services.nginx = mkIf (cfg.virtualHost != null) {
      enable = true;
      recommendedProxySettings = true;
      virtualHosts.${cfg.virtualHost} = {
        locations.${cfg.contextPath}.proxyPass = "http://${cfg.listenAddress}:${toString cfg.port}";
      };
    };

    users.users.airsonic = {
      description = "Airsonic service user";
      group = "airsonic";
      name = cfg.user;
      home = cfg.home;
      createHome = true;
      isSystemUser = true;
    };
    users.groups.airsonic = {};
  };
}
