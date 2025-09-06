{
  options,
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib.types)
    attrsOf
    bool
    listOf
    nullOr
    path
    str
    submodule
    ;
  inherit (lib)
    concatMapStringsSep
    concatStringsSep
    filter
    getExe
    literalExpression
    maintainers
    mapAttrs'
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    mkRenamedOptionModule
    nameValuePair
    optional
    optionalAttrs
    remove
    ;

  cfg = config.services.traefik;
  opt = options.services.traefik;

  # JSON is considered valid YAML by Traefik.
  format = pkgs.formats.json { };

  staticFile =
    if cfg.static.file == null then
      format.generate "static_config.json" cfg.static.settings
    else
      cfg.static.file;

  finalStaticFile = if cfg.useEnvSubst then "/run/traefik/config.json" else staticFile;
in
{
  imports = [
    (mkRenamedOptionModule
      [
        "services"
        "traefik"
        "staticConfigFile"
      ]
      [
        "services"
        "traefik"
        "static"
        "file"
      ]
    )
    (mkRenamedOptionModule
      [
        "services"
        "traefik"
        "staticConfigOptions"
      ]
      [
        "services"
        "traefik"
        "static"
        "settings"
      ]
    )
    (mkRenamedOptionModule
      [
        "services"
        "traefik"
        "dynamicConfigFile"
      ]
      [
        "services"
        "traefik"
        "dynamic"
        "file"
      ]
    )
    (mkRenamedOptionModule
      [
        "services"
        "traefik"
        "dynamicConfigOptions"
      ]
      [
        "services"
        "traefik"
        "dynamic"
        "settings"
      ]
    )
  ];
  options.services.traefik = {
    enable = mkEnableOption "Traefik web server";
    package = mkPackageOption pkgs "traefik" { };

    static = {
      file = mkOption {
        default = null;
        example = literalExpression "/path/to/static_config.toml";
        type = nullOr path;
        description = ''
          Path to Traefik's static configuration file.

          ::: {.note}
          Using this option has precedence over {option}`services.traefik.static.settings`.
          :::
        '';
      };
      settings = mkOption {
        description = ''
          Static configuration for Traefik, written in Nix.

          ::: {.note}
          This will be serialized to JSON (which is considered valid YAML) at build, and passed to Traefik as `--configfile`.
          :::
        '';
        type = format.type;
        default = {
          entryPoints.http.address = ":80";
        };
        example = {
          entryPoints = {
            "web" = {
              address = ":80";
              http.redirections.entryPoint = {
                permanent = true;
                scheme = "https";
                to = "websecure";
              };
            };
            "websecure" = {
              address = ":443";
              asDefault = true;
            };
          };
        };
      };
    };

    dynamic = {
      file = mkOption {
        default = null;
        example = literalExpression "/path/to/dynamic_config.toml";
        type = nullOr path;
        description = ''
          Path to Traefik's dynamic configuration file.

          ::: {.note}
          You cannot use this option alongside the declarative configuration options.
          :::
        '';
      };
      dir = mkOption {
        default = null;
        example = literalExpression "/var/lib/traefik/dynamic";
        type = nullOr path;
        description = ''
          Path to the directory Traefik should watch for configuration files.

          ::: {.warning}
          Files in this directory matching the glob `_nixos-*` (reserved for Nix-managed dynamic configurations) will be deleted as part of
          `systemd-tmpfiles-resetup.service`, _**regardless of their origin.**_.
          :::
        '';
      };
      files = mkOption {
        type = attrsOf (submodule {
          options.settings = mkOption {
            type = format.type;
            description = ''
              Dynamic configuration for Traefik, written in Nix.

              ::: {.note}
              This will be serialized to JSON (which is considered valid YAML) at build, and passed as part of the static file.
              :::
            '';
            example = {
              http.routers."api" = {
                service = "api@internal";
                rule = "Host(`localhost`)";
              };
            };
          };
        });
        default = { };
        example = {
          "dashboard".settings = {
            http.routers."api" = {
              service = "api@internal";
              rule = "Host(`198.51.100.1`)";
            };
          };
        };
        description = ''
          Dynamic configuration files to write. These are symlinked in `services.traefik.dynamic.dir` upon activation,
          allowing configuration to be upated without restarting the primary daemon.

          ::: {.note}
          Due to [a limitation in Traefik](https://github.com/traefik/traefik/issues/10890); any syntax error in a dynamic configuration will cause the _**entire file provider**_ to be ignored.
          This may cause interuption in service, which may include access to the Traefik dashboard, if [enabled and configured](https://doc.traefik.io/traefik/operations/dashboard).
          :::
        '';
      };
      # TODO: Drop in 26.11.
      settings = mkOption {
        type = format.type;
        description = ''
          Dynamic configuration for Traefik, written in Nix.
          This option is intended for easily migrating pre-26.05 Traefik configurations, and will be removed in NixOS 26.11.

          ::: {.note}
          Configurations added here will be translated into a file for {option}`services.traefik.dynamic.files`, named `custom-migrated`.
          :::
        '';
        default = { };
        example = {
          http.routers."api" = {
            service = "api@internal";
            rule = "Host(`localhost`)";
          };
        };
      };
    };

    dataDir = mkOption {
      default = "/var/lib/traefik";
      type = path;
      description = ''
        Location for any persistent data Traefik creates, such as the ACME certificate store.

        ::: {.note}
        If left as the default value, this directory will automatically be created
        before the Traefik server starts, otherwise you are responsible for ensuring
        the directory exists with appropriate ownership and permissions.
        :::
      '';
    };

    user = mkOption {
      default = "traefik";
      example = "docker";
      type = str;
      description = ''
        User under which Traefik runs.

        ::: {.note}
        If left as the default value this user will automatically be created
        on system activation, otherwise you are responsible for
        ensuring the user exists before the Traefik service starts.
        :::
      '';
    };

    group = mkOption {
      default = "traefik";
      type = str;
      description = ''
        Primary group under which Traefik runs.
        For the Docker backend, use {option}`services.traefik.supplementaryGroups` instead of overriding this option.

        ::: {.note}
        If left as the default value this group will automatically be created
        on system activation, otherwise you are responsible for
        ensuring the group exists before the Traefik service starts.
        :::
      '';
    };

    supplementaryGroups = mkOption {
      default = [ ];
      type = listOf str;
      example = [ "docker" ];
      description = ''
        Additional groups under which Traefik runs.
        This can be used to give additional permissions, such as the group required by the `docker` provider.

        ::: {.note}
        With the `docker` provider, Traefik manages connection to containers via the Docker socket,
        which requires membership of the `docker` group for write access.
        :::
      '';
    };

    environmentFiles = mkOption {
      default = [ ];
      type = listOf path;
      example = [ "/run/secrets/traefik.env" ];
      description = ''
        Files to load as an environment file just before Traefik starts.
        This can be used to pass secrets such as [DNS challenge API tokens](https://doc.traefik.io/traefik/https/acme/#providers) or [EAB credentials](https://doc.traefik.io/traefik/reference/static-configuration/env/).
        ```
        DESEC_TOKEN=
        TRAEFIK_CERTIFICATESRESOLVERS_<NAME>_ACME_EAB_HMACENCODED=
        TRAEFIK_CERTIFICATESRESOLVERS_<NAME>_ACME_EAB_KID=
        ```
        ::: {.warn}
        The traefik static configuration methods (env, CLI, and file) are mutually exclusive.
        :::

        Rather than setting secret values with the traefik environment variable syntax,
        it is recommended to set arbitrary environment variables, then reference them with `$VARNAME` in e.g.
        {option}`services.traefik.static.settings`, like so:
        ```nix
        {
          services.traefik = {
            static.settings.somesecretvalue = "$SECRETNAME";
            useEnvSubst = true; # Necessary in order to use environment variables in the Traefik config.
            environmentFiles = [ /path/to/file/that/defines/SECRETNAME ];
          };
        }
        ```
      '';
    };

    useEnvSubst = mkOption {
      default = cfg.environmentFiles != [ ];
      defaultText = "config.services.traefik.environmentFiles != [ ]";
      type = bool;
      example = true;
      description = ''
        Whether to use `envSubst` in the `ExecStartPre` phase to augment the generated static config. See {option}`services.traefik.environmentFiles`.

        ::: {.note}
        If you use environment files with Traefik but *do not* utilise environment variables in the static config, this can safely be disabled to reduce startup time.
        :::
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion =
          cfg.static.file != opt.static.file.default -> cfg.static.settings == opt.static.settings.default;
        message = ''
          The 'services.traefik.static.file' and 'services.traefik.static.settings'
          options are mutually exclusive for the Traefik static config.
          It is recommended to use 'settings'.
        '';
      }
      {
        assertion =
          cfg.static.file != opt.static.file.default
          -> (
            cfg.dynamic.files == opt.dynamic.files.default
            && cfg.dynamic.dir == opt.dynamic.dir.default
            && cfg.dynamic.file == opt.dynamic.file.default
          );
        message = ''
          None of the dynamic configuration options may be used if Traefik is being managed imperatively.
          The following options have non-default values:
            - ${
              concatMapStringsSep "\n  - " (str: "'services.traefik.dynamic.${str}'") (
                filter (attr: cfg.dynamic.${attr} != opt.dynamic.${attr}.default) [
                  "files"
                  "dir"
                  "file"
                  "settings" # TODO: Drop in 26.11.
                ]
              )
            }
        '';
      }
      {
        assertion =
          cfg.dynamic.file != opt.dynamic.file.default -> cfg.dynamic.dir == opt.dynamic.dir.default;
        message = ''
          The 'services.traefik.dynamic.file' and 'services.traefik.dynamic.dir' options
          are mutually exclusive for the Traefik dynamic config. It is recommended to use
          'services.traefik.dynamic.dir' with 'services.traefik.dynamic.files'.
        '';
      }
      {
        assertion =
          cfg.dynamic.files != opt.dynamic.files.default -> cfg.dynamic.dir != opt.dynamic.dir.default;
        message = ''
          'services.traefik.dynamic.files' requires the dynamic file provider to be set
          to a directory. Please set a path for 'services.traefik.dynamic.dir'.
        '';
      }
      {
        assertion = cfg.group != "docker";
        message = ''
          Setting the primary group to 'docker' will cause files, such as those generated
          by 'services.traefik.dynamic.files', to be owned by the group 'docker', which
          may be a security risk. Use 'services.traefik.supplementaryGroups' instead.
        '';
      }
    ];

    warnings =
      optional (!(builtins.elem "docker" cfg.supplementaryGroups -> config.virtualisation.docker.enable))
        "'services.traefik.supplementaryGroups' contains the 'docker' group, but 'services.docker' is not enabled."
      ++ optional (cfg.dynamic.settings != opt.dynamic.settings.default) ''
        'services.traefik.dynamic.settings' is in use, but that option is deprecated.
        Please migrate your configuration to an explicit file instead.

        You may do so by moving the value of 'services.traefik.dynamic.settings' to
        'services.traefik.dynamic.files.<name>.settings', where <name> is an arbitrary
        string that ideally identifies the configuration's purpose.

        The following files define 'services.traefik.dynamic.settings' and should be migrated:
          - ${
            concatStringsSep "\n  - " (
              remove ./traefik.nix (map (attr: attr.file) opt.dynamic.settings.definitionsWithLocations)
            )
          }
      '';

    # https://github.com/quic-go/quic-go/wiki/UDP-Buffer-Sizes
    boot.kernel.sysctl = {
      "net.core.rmem_max" = 2500000;
      "net.core.wmem_max" = 2500000;
    };

    # If a dynamic file or directory has been set, add it as a provider in the static configuration
    services.traefik = mkIf (cfg.static.file == opt.static.file.default) {
      dynamic.files = mkIf (cfg.dynamic.settings != opt.dynamic.settings.default) {
        "custom-migrated".settings = cfg.dynamic.settings;
      };
      static.settings =
        mkIf (cfg.dynamic.dir != opt.dynamic.dir.default || cfg.dynamic.file != opt.dynamic.file.default)
          {
            providers.file = {
              directory = mkIf (cfg.dynamic.dir != opt.dynamic.dir.default) cfg.dynamic.dir;
              filename = mkIf (cfg.dynamic.file != opt.dynamic.file.default) cfg.dynamic.file;
              watch = mkDefault true;
            };
          };
    };

    systemd.services.traefik = {
      description = "Traefik reverse proxy";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      startLimitIntervalSec = 86400;
      startLimitBurst = 5;
      serviceConfig = {
        Documentation = "https://doc.traefik.io/traefik/";
        EnvironmentFile = cfg.environmentFiles;
        ExecStartPre = optional cfg.useEnvSubst "${getExe pkgs.envsubst} -i '${staticFile}' > '${finalStaticFile}'";
        ExecStart = "${getExe cfg.package} --configfile=${finalStaticFile}";
        Type = "notify";
        User = cfg.user;
        Group = cfg.group;
        SupplementaryGroups = mkIf (cfg.supplementaryGroups != [ ]) cfg.supplementaryGroups;
        Restart = "always";
        AmbientCapabilities = "cap_net_bind_service";
        CapabilityBoundingSet = "cap_net_bind_service";
        NoNewPrivileges = true;
        TasksMax = 64;
        LimitNOFILE = 1048576;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ReadWritePaths = [ cfg.dataDir ];
        ReadOnlyPaths = optional (cfg.dynamic.dir != null) cfg.dynamic.dir;
        RuntimeDirectoryMode = "0700";
        RuntimeDirectory = "traefik";
        WorkingDirectory = cfg.dataDir;
        WatchdogSec = "1s";
      };
    };

    systemd.tmpfiles.settings."10-traefik" = mkMerge [
      (mkIf (cfg.user == "traefik") {
        ${cfg.dataDir}.d = {
          inherit (cfg) user group;
          mode = "0700";
        };
      })
      (mkIf (cfg.dynamic.dir != null) (
        {
          ${cfg.dynamic.dir}.d = {
            inherit (cfg) user group;
            mode = "0700";
          };
          "${cfg.dynamic.dir}/_nixos-*".r = { };
        }
        // (mapAttrs' (
          name: value:
          nameValuePair "${cfg.dynamic.dir}/_nixos-${name}.yml" {
            "L+" = {
              mode = "0444";
              argument = toString (format.generate name value.settings);
            };
          }
        ) cfg.dynamic.files)
      ))
    ];

    users = {
      users = optionalAttrs (cfg.user == "traefik") {
        traefik = {
          inherit (cfg) group;
          isSystemUser = true;
        };
      };
      groups = optionalAttrs (cfg.group == "traefik") { traefik = { }; };
    };
  };

  meta.maintainers = with maintainers; [
    jackr
    therealgramdalf
  ];
}
