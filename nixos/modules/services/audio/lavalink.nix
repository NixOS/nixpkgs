{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.lavalink;
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    types
    ;

  format = pkgs.formats.yaml { };
in

{
  options.services.lavalink = {
    enable = mkEnableOption "Lavalink";

    package = lib.mkPackageOption pkgs "lavalink" { };

    password = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "s3cRe!p4SsW0rD";
      description = ''
        The password for Lavalink's authentication in plain text.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 2333;
      example = 4567;
      description = ''
        The port that Lavalink will use.
      '';
    };

    address = mkOption {
      type = types.str;
      default = "0.0.0.0";
      example = "127.0.0.1";
      description = ''
        The network address to bind to.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Whether to expose the port to the network.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "lavalink";
      example = "root";
      description = ''
        The user of the service.
      '';
    };

    group = mkOption {
      type = types.str;
      default = "lavalink";
      example = "medias";
      description = ''
        The group of the service.
      '';
    };

    home = mkOption {
      type = types.str;
      default = "/var/lib/lavalink";
      example = "/home/lavalink";
      description = ''
        The home folder for lavalink.
      '';
    };

    enableHttp2 = mkEnableOption "HTTP/2 support";

    jvmArgs = mkOption {
      type = types.str;
      default = "-Xmx4G";
      example = "-Djava.io.tmpdir=/var/lib/lavalink/tmp -Xmx6G";
      description = ''
        Set custom JVM arguments.
      '';
    };

    plugins = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            name = mkOption {
              type = types.nullOr types.str;
              example = "youtube";
              default = null;
              description = ''
                The name of the plugin to use for the plugin configuration.
              '';
            };

            dependency = mkOption {
              type = types.str;
              example = "dev.lavalink.youtube:youtube-plugin:1.8.0";
              description = ''
                The coordinates of the plugin.
              '';
            };

            repository = mkOption {
              type = types.str;
              example = "https://maven.example.com/releases";
              default = "https://maven.lavalink.dev/releases";
              description = ''
                The plugin repository. Defaults to the lavalink releases repository.
              '';
            };

            snapshot = mkOption {
              type = types.bool;
              default = false;
              example = true;
              description = ''
                Whether to use the snapshot repository instead of the release repository.
              '';
            };

            hash = mkOption {
              type = types.str;
              example = lib.fakeHash;
              default = lib.fakeHash;
              description = ''
                The hash of the plugin.
              '';
            };

            extraConfig = mkOption {
              type = types.submodule { freeformType = format.type; };
              default = { };
              description = ''
                The configuration for the plugin.
              '';
            };
          };
        }
      );
      default = [ ];
      example = [
        {
          name = "youtube";
          dependency = "dev.lavalink.youtube:youtube-plugin:1.8.0";
          snapshot = false;
          extraConfig = {
            enabled = true;
            allowSearch = true;
            allowDirectVideoIds = true;
            allowDirectPlaylistIds = true;
          };
          hash = lib.fakeHash;
        }
      ];
      description = ''
        A list of plugins for lavalink.
      '';
    };

    extraConfig = mkOption {
      type = types.submodule { freeformType = format.type; };
      description = ''
        Configuration to write to {file}`application.yml`.

        Individual configuration parameters can be overwritten using environment variables.
        See <https://lavalink.dev/configuration/index.html> for more information.
      '';
      default = {
        lavalink.server = {
          sources = {
            youtube = false;
            bandcamp = true;
            soundcloud = true;
            twitch = true;
            vimeo = true;
            nico = true;
            http = false;
            local = false;
          };

          filters = {
            volume = true;
            equalizer = true;
            karaoke = true;
            timescale = true;
            tremolo = true;
            distortion = true;
            rotation = true;
            channelMix = true;
            lowPass = true;
          };

          bufferDurationMs = 400;
          frameBufferDurationMs = 5000;
          opusEncodingQuality = 10;
          resamplingQuality = "LOW";
          trackStuckThresholdMs = 10000;
          useSeekGhosting = true;
          youtubePlaylistLoadLimit = 6;
          playerUpdateInterval = 5;
          youtubeSearchEnabled = true;
          soundcloudSearchEnabled = true;
          gc-warnings = true;
        };

        metrics.prometheus = {
          enabled = false;
          endpoint = "/metrics";
        };

        sentry = {
          dsn = "";
          environment = "";
        };

        logging = {
          file.path = "./logs/";

          level = {
            root = "INFO";
            lavalink = "INFO";
          };

          request = {
            enabled = true;
            includeClientInfo = true;
            includeHeaders = false;
            includeQueryString = true;
            includePayload = true;
            maxPayloadLength = 10000;
          };

          logback.rollingpolicy = {
            max-file-size = "1GB";
            max-history = 30;
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

    users.groups = mkIf (cfg.group == "lavalink") { lavalink = { }; };
    users.users = mkIf (cfg.user == "lavalink") {
      lavalink = {
        group = "lavalink";
        home = cfg.home;
        description = "The user for the Lavalink server";
        isSystemUser = true;
      };
    };

    systemd.tmpfiles.settings."10-lavalink" =
      let
        dirConfig = {
          mode = "0700";
          user = cfg.user;
          group = cfg.group;
        };
      in
      {
        "${cfg.home}/plugins".d = dirConfig;
        "${cfg.home}/".d = dirConfig;
      };

    systemd.services.lavalink = {
      description = "Lavalink Service";

      wantedBy = [ "multi-user.target" ];
      after = [
        "syslog.target"
        "network.target"
      ];

      script =
        let
          pluginLinks = lib.concatStringsSep "\n" (
            map (
              pluginConfig:
              let
                pluginParts = lib.match ''^(.*?:(.*?):)([0-9]+\.[0-9]+\.[0-9]+)$'' pluginConfig.dependency;
                pluginPath = (
                  lib.replaceStrings
                    [
                      "."
                      ":"
                    ]
                    [
                      "/"
                      "/"
                    ]
                    (lib.elemAt pluginParts 0)
                );
                pluginFileName = lib.elemAt pluginParts 1;
                pluginVersion = lib.elemAt pluginParts 2;
                pluginJarFile = lib.concatStrings [
                  pluginFileName
                  "-"
                  pluginVersion
                  ".jar"
                ];
                plugin = pkgs.fetchurl {
                  url = lib.concatStrings [
                    pluginConfig.repository
                    "/"
                    pluginPath
                    pluginVersion
                    "/"
                    pluginFileName
                    "-"
                    pluginVersion
                    ".jar"
                  ];
                  hash = pluginConfig.hash;
                };
              in
              "ln -sf ${plugin} plugins/${pluginJarFile}"
            ) cfg.plugins
          );
          configFile = format.generate "application.yml" (
            lib.recursiveUpdate (lib.recursiveUpdate cfg.extraConfig {
              server = {
                port = cfg.port;
                address = cfg.address;
                http2.enabled = cfg.enableHttp2;
              };
              plugins = lib.listToAttrs (
                lib.filter (x: x != null) (
                  lib.map (
                    pluginConfig:
                    if pluginConfig.name != null then
                      lib.nameValuePair (pluginConfig.name) (pluginConfig.extraConfig)
                    else
                      null
                  ) cfg.plugins
                )
              );
              lavalink.plugins = lib.map (
                pluginConfig:
                removeAttrs pluginConfig [
                  "name"
                  "extraConfig"
                  "hash"
                ]
              ) cfg.plugins;
            }) (lib.optionalAttrs (cfg.password != null) ({ lavalink.server.password = cfg.password; }))
          );
        in
        ''
          ${pluginLinks}
          ln -sf ${configFile} ${cfg.home}/application.yml
          export _JAVA_OPTIONS="${cfg.jvmArgs}"
          ${lib.getExe cfg.package}
        '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;

        Type = "simple";
        Restart = "on-failure";

        WorkingDirectory = cfg.home;
      };
    };
  };
}
