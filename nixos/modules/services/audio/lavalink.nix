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
    literalExpression
    mkRemovedOptionModule
    mkRenamedOptionModule
    attrValues
    pipe
    filterAttrs
    mapAttrs
    optionalString
    ;

  cfg = config.services.lavalink;

  format = pkgs.formats.yaml { };

  hasPlugins = cfg.plugins != { };
  isDeprecatedPlugin = (builtins.typeOf cfg.plugins) == "list";
  pluginModule.options = {
    dependency = mkOption {
      type = types.str;
      example = "dev.lavalink.youtube:youtube-plugin:1.8.0";
      description = ''
        The coordinates of the plugin.
      '';
    };

    repository = mkOption {
      type = types.str;
      default = "https://maven.lavalink.dev/releases";
      example = "https://maven.example.com/releases";
      description = ''
        The plugin repository. Defaults to the lavalink releases repository.

        To use the snapshots repository, use <https://maven.lavalink.dev/snapshots> instead.
      '';
    };

    hash = mkOption {
      type = types.str;
      default = "";
      example = lib.fakeHash;
      description = ''
        The hash of the plugin's jar file
      '';
    };

    settings = mkOption {
      type = types.submodule { freeformType = format.type; };
      default = { };
      example = literalExpression ''
        {
          # Settings part of the youtube plugin
          enabled = true;
          allowSearch = true;
          allowDirectVideoIds = true;
          allowDirectPlaylistIds = true;
        }
      '';
      description = ''
        The settings for the plugin.
      '';
    };
  };
in

{
  imports = [
    (mkRemovedOptionModule
      [
        "services"
        "lavalink"
        "password"
      ]
      ''
        The {option}`services.lavalink.password` option was removed,
        because it's insecure to store passwords in the nix store.

        Define a path to a file, outside the nix store, containing the
        password in {option}`services.lavalink.passwordFile` instead.

        See the [NixOS release notes] for more information.

        [NixOS release notes]: https://nixos.org/manual/nixos/unstable/release-notes#sec-release-26.05-incompatibilities
      ''
    )
    (mkRenamedOptionModule
      [
        "services"
        "lavalink"
        "extraConfig"
      ]
      [
        "services"
        "lavalink"
        "settings"
      ]
    )
    (mkRenamedOptionModule
      [
        "services"
        "lavalink"
        "enableHttp2"
      ]
      [
        "services"
        "lavalink"
        "settings"
        "server"
        "http2"
        "enabled"
      ]
    )
    (mkRenamedOptionModule
      [
        "services"
        "lavalink"
        "port"
      ]
      [
        "services"
        "lavalink"
        "settings"
        "server"
        "port"
      ]
    )
  ];

  options.services.lavalink = {
    enable = mkEnableOption "Lavalink";

    package = lib.mkPackageOption pkgs "lavalink" { };

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
      example = "media";
      description = ''
        The user of the service.
      '';
    };

    group = mkOption {
      type = types.str;
      default = "lavalink";
      example = "media";
      description = ''
        The group of the service.
      '';
    };

    home = mkOption {
      type = types.str;
      default = "/var/lib/lavalink";
      example = "/srv/lavalink";
      description = ''
        The home directory containing lavalink's state files,
        {file}`application.yml` configuration, and plugins.
      '';
    };

    jvmArgs = mkOption {
      type = types.str;
      default = "";
      example = "-Djava.io.tmpdir=/var/lib/lavalink/tmp -Xmx6G";
      description = ''
        Set custom JVM arguments.
      '';
    };

    passwordFile = mkOption {
      type = types.nullOr types.externalPath;
      default = null;
      example = "/run/secrets/lavalinkPassword";
      description = ''
        A file containing the password for authentication with lavalink.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "/run/secrets/lavalink/passwordEnvFile";
      description = ''
        Add custom environment variables from a file.

        See <https://lavalink.dev/configuration/index.html#example-environment-variables>
        for the full documentation.
      '';
    };

    plugins = mkOption {
      type =
        types.either
          # Pre 26.05 definition
          (types.listOf (
            types.submodule {
              options = (removeAttrs pluginModule.options [ "settings" ]) // {
                configName = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  description = ''
                    The configuration key of the plugin in the server's
                    {file}`application.yml` under `plugins`.

                    This option is deprecated. Please migrate to the
                    attribute set definition instead.

                    See the [NixOS release notes] for more information.

                    [NixOS release notes]: https://nixos.org/manual/nixos/unstable/release-notes#sec-release-26.05-incompatibilities
                  '';
                };

                extraConfig = pluginModule.options.settings // {
                  description = pluginModule.options.settings.description + ''
                    This option is deprecated. Please migrate to the
                    attribute set definition instead.

                    See the [NixOS release notes] for more information.

                    [NixOS release notes]: https://nixos.org/manual/nixos/unstable/release-notes#sec-release-26.05-incompatibilities
                  '';
                };
              };
            }
          ))
          (types.attrsOf (types.submodule pluginModule));

      # Migrate lists
      apply =
        config:

        if (lib.typeOf config) != "list" then
          config
        else
          let
            updatePlugin = plugin: {
              name = if plugin.configName != null then plugin.configName else plugin.dependency;
              value = (removeAttrs plugin [ "extraConfig" ]) // {
                settings = plugin.extraConfig;
              };
            };
          in
          pipe config [
            (map updatePlugin)
            builtins.listToAttrs
          ];

      default = { };

      example = literalExpression ''
        {
          youtube = {
            # Fetcher arguments
            dependency = "dev.lavalink.youtube:youtube-plugin:1.8.0";
            repository = "https://maven.lavalink.dev/snapshots";
            hash = lib.fakeHash;

            # Add an object called "youtube" with the
            # following settings at the root of the
            # application.yaml
            settings = {
              enabled = true;
              allowSearch = true;
              allowDirectVideoIds = true;
              allowDirectPlaylistIds = true;
            };
          }

          lavasrc = {
            dependency = "com.github.topi314.lavasrc:lavasrc-plugin:4.8.1";
            hash = lib.fakeHash;

            settings = {
              providers = [ "ytsearch:%QUERY%" ];
              lyrics-sources.youtube = true;
            };
          }
        }
      '';

      description = ''
        Plugins mapped to fetcher arguments and their settings.

        Make sure to set the same attribute name as the key used
        for configuration under `plugins`. Usually, if the plugin
        provides server settings, those are found in the
        {file}`README.md` of the project's repository.
      '';
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = format.type;

        options.server = {
          address = mkOption {
            type = types.str;
            default = "0.0.0.0";
            example = "127.0.0.1";
            description = ''
              The network address to bind to.
            '';
          };

          port = mkOption {
            type = types.port;
            default = 2333;
            example = 4567;
            description = ''
              The port that to bind to.
            '';
          };

          http2.enabled = mkEnableOption "HTTP/2 support";
        };
      };

      description = ''
        Configuration to write to {file}`application.yml`.
        See <https://lavalink.dev/configuration/#example-applicationyml> for the full documentation.

        Individual configuration parameters can be overwritten using environment variables.
        See <https://lavalink.dev/configuration/#example-environment-variables> for more information.
      '';

      default = { };

      example = literalExpression ''
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

  config = mkIf cfg.enable {
    assertions = lib.optionals isDeprecatedPlugin [
      {
        assertion = lib.lists.all (
          pluginCfg: pluginCfg.extraConfig == { } || pluginCfg.configName != null
        ) cfg.plugins;
        message = "Plugins with {option}`extraConfig` defined require the option {option}`configName`";
      }
    ];

    warnings = lib.optionals isDeprecatedPlugin [
      ''
        Defining a list of plugins has been deprecated in favor of an attribute set.
        See the [NixOS release notes] for more information.

        [NixOS release notes]: https://nixos.org/manual/nixos/unstable/release-notes#sec-release-26.05-incompatibilities
      ''
    ];

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

    users.groups = mkIf (cfg.group == "lavalink") { lavalink = { }; };
    users.users = mkIf (cfg.user == "lavalink") {
      lavalink = {
        isSystemUser = true;
        description = "The user for the Lavalink server";
        group = "lavalink";
        inherit (cfg) home;
      };
    };

    systemd.services.lavalink = {
      description = "Lavalink Service";

      wantedBy = [ "multi-user.target" ];
      after = [
        "syslog.target"
        "network.target"
      ];

      environment = mkIf (cfg.jvmArgs != "") { JAVA_TOOL_OPTIONS = cfg.jvmArgs; };

      preStart =
        let
          fetchPlugin =
            plugin:
            let
              pluginParts = lib.match ''^(.*?:(.*?):)([0-9]+\.[0-9]+\.[0-9]+)$'' plugin.dependency;

              pluginWebPath = lib.replaceStrings [ "." ":" ] [ "/" "/" ] (lib.elemAt pluginParts 0);

              pluginFileName = lib.elemAt pluginParts 1;
              pluginVersion = lib.elemAt pluginParts 2;

              pluginFile = "${pluginFileName}-${pluginVersion}.jar";
              pluginUrl = "${plugin.repository}/${pluginWebPath}${pluginVersion}/${pluginFile}";
            in
            pkgs.fetchurl {
              url = pluginUrl;
              inherit (plugin) hash;
            };

          pluginFarm = pipe cfg.plugins [
            attrValues
            (map fetchPlugin)
            (pkgs.linkFarmFromDrvs "lavalink-plugins")
          ];

          configWithPlugins = lib.attrsets.recursiveUpdate cfg.settings {
            plugins = pipe cfg.plugins [
              (filterAttrs (_: plugin: plugin.settings != { }))
              (mapAttrs (_: plugin: plugin.settings))
            ];

            lavalink.pluginsDir = pluginFarm;
            lavalink.plugins = pipe cfg.plugins [
              attrValues
              (map (
                pluginConfig:
                removeAttrs pluginConfig [
                  "configName"
                  "extraConfig"
                  "settings"
                  "hash"
                ]
              ))
            ];
          };

          configFile = format.generate "application.yml" (
            if hasPlugins then configWithPlugins else cfg.settings
          );
        in
        ''
          ln -sf ${configFile} "${cfg.home}/application.yml"
        '';

      script = ''
        ${optionalString (cfg.passwordFile != null) ''
          export LAVALINK_SERVER_PASSWORD="$(cat "$CREDENTIALS_DIRECTORY/lavalink_password")"
        ''}
        ${lib.getExe cfg.package}
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;

        Type = "simple";
        Restart = "on-failure";

        EnvironmentFile = cfg.environmentFile;
        LoadCredential = mkIf (cfg.passwordFile != null) [ "lavalink_password:${cfg.passwordFile}" ];
        StateDirectory = mkIf (cfg.home == "/var/lib/lavalink") "lavalink";
        WorkingDirectory = "~";

        # Hardening
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        CapabilityBoundingSet = "";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
        ];
        UMask = "0027";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ nanoyaki ];
}
