{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    types
    ;

  cfg = config.services.lavalink;

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
        The home directory for lavalink.
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

    environmentFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "/run/secrets/lavalink/passwordEnvFile";
      description = ''
        Add custom environment variables from a file.
        See <https://lavalink.dev/configuration/index.html#example-environment-variables> for the full documentation.
      '';
    };

    plugins = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
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

                To use the snapshots repository, use <https://maven.lavalink.dev/snapshots> instead
              '';
            };

            hash = mkOption {
              type = types.str;
              example = lib.fakeHash;
              description = ''
                The hash of the plugin.
              '';
            };

            configName = mkOption {
              type = types.nullOr types.str;
              example = "youtube";
              default = null;
              description = ''
                The name of the plugin to use as the key for the plugin configuration.
              '';
            };

            extraConfig = mkOption {
              type = types.submodule { freeformType = format.type; };
              default = { };
              description = ''
                The configuration for the plugin.

                The {option}`services.lavalink.plugins.*.configName` option must be set.
              '';
            };
          };
        }
      );
      default = [ ];

      example = lib.literalExpression ''
        [
          {
            dependency = "dev.lavalink.youtube:youtube-plugin:1.8.0";
            repository = "https://maven.lavalink.dev/snapshots";
            hash = lib.fakeHash;
            configName = "youtube";
            extraConfig = {
              enabled = true;
              allowSearch = true;
              allowDirectVideoIds = true;
              allowDirectPlaylistIds = true;
            };
          }
        ]
      '';

      description = ''
        A list of plugins for lavalink.
      '';
    };

    extraConfig = mkOption {
      type = types.submodule { freeformType = format.type; };

      description = ''
        Configuration to write to {file}`application.yml`.
        See <https://lavalink.dev/configuration/#example-applicationyml> for the full documentation.

        Individual configuration parameters can be overwritten using environment variables.
        See <https://lavalink.dev/configuration/#example-environment-variables> for more information.
      '';

      default = { };

      example = lib.literalExpression ''
        {
          lavalink.server = {
            sources.twitch = true;

            filters.volume = true;
          };

          logging.file.path = "./logs/";
        }
      '';
    };
  };

  config =
    let
      pluginSymlinks = lib.concatStringsSep "\n" (
        map (
          pluginCfg:
          let
            pluginParts = lib.match ''^(.*?:(.*?):)([0-9]+\.[0-9]+\.[0-9]+)$'' pluginCfg.dependency;

            pluginWebPath = lib.replaceStrings [ "." ":" ] [ "/" "/" ] (lib.elemAt pluginParts 0);

            pluginFileName = lib.elemAt pluginParts 1;
            pluginVersion = lib.elemAt pluginParts 2;

            pluginFile = "${pluginFileName}-${pluginVersion}.jar";
            pluginUrl = "${pluginCfg.repository}/${pluginWebPath}${pluginVersion}/${pluginFile}";

            plugin = pkgs.fetchurl {
              url = pluginUrl;
              inherit (pluginCfg) hash;
            };
          in
          "ln -sf ${plugin} ${cfg.home}/plugins/${pluginFile}"
        ) cfg.plugins
      );

      pluginExtraConfigs = builtins.listToAttrs (
        builtins.map (
          pluginConfig: lib.attrsets.nameValuePair pluginConfig.configName pluginConfig.extraConfig
        ) (lib.lists.filter (pluginCfg: pluginCfg.configName != null) cfg.plugins)
      );

      config = lib.attrsets.recursiveUpdate cfg.extraConfig {
        server = {
          inherit (cfg) port address;
          http2.enabled = cfg.enableHttp2;
        };

        plugins = pluginExtraConfigs;
        lavalink.plugins = (
          builtins.map (
            pluginConfig:
            builtins.removeAttrs pluginConfig [
              "name"
              "extraConfig"
              "hash"
            ]
          ) cfg.plugins
        );
      };

      configWithPassword = lib.attrsets.recursiveUpdate config (
        lib.attrsets.optionalAttrs (cfg.password != null) { lavalink.server.password = cfg.password; }
      );

      configFile = format.generate "application.yml" configWithPassword;
    in
    mkIf cfg.enable {
      assertions = [
        {
          assertion =
            !(lib.lists.any (
              pluginCfg: pluginCfg.extraConfig != { } && pluginCfg.configName == null
            ) cfg.plugins);
          message = "Plugins with extra configuration need to have the `configName` attribute defined";
        }
      ];

      networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

      users.groups = mkIf (cfg.group == "lavalink") { lavalink = { }; };
      users.users = mkIf (cfg.user == "lavalink") {
        lavalink = {
          inherit (cfg) home;
          group = "lavalink";
          description = "The user for the Lavalink server";
          isSystemUser = true;
        };
      };

      systemd.tmpfiles.settings."10-lavalink" =
        let
          dirConfig = {
            inherit (cfg) user group;
            mode = "0700";
          };
        in
        {
          "${cfg.home}/plugins".d = mkIf (cfg.plugins != [ ]) dirConfig;
          ${cfg.home}.d = dirConfig;
        };

      systemd.services.lavalink = {
        description = "Lavalink Service";

        wantedBy = [ "multi-user.target" ];
        after = [
          "syslog.target"
          "network.target"
        ];

        script = ''
          ${pluginSymlinks}

          ln -sf ${configFile} ${cfg.home}/application.yml
          export _JAVA_OPTIONS="${cfg.jvmArgs}"

          ${lib.getExe cfg.package}
        '';

        serviceConfig = {
          User = cfg.user;
          Group = cfg.group;

          Type = "simple";
          Restart = "on-failure";

          EnvironmentFile = cfg.environmentFile;
          WorkingDirectory = cfg.home;
        };
      };
    };
}
