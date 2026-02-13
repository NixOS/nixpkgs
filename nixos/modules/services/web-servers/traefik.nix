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
    attrByPath
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
    splitStringBy
    ;

  cfg = config.services.traefik;
  opt = options.services.traefik;

  # check if the option has been changed
  ## isDefault :: String -> bool
  ## eg. isDefault "install.settings" == (cfg.install.settings == opt.install.settings.default)
  isDefault =
    attrPathStr:
    let
      sepPath = splitStringBy (prev: curr: builtins.elem curr [ "." ]) false attrPathStr;
    in
    attrByPath (sepPath ++ [ "default" ]) (throw "isDefault failed") opt
    == attrByPath sepPath (throw "isDefault failed") cfg;

  # JSON is considered valid YAML by Traefik.
  format = pkgs.formats.json { };

  installFile =
    if cfg.install.file == null then
      format.generate "install_config.json" cfg.install.settings
    else
      cfg.install.file;
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
        "install"
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
        "install"
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
        "routing"
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
        "routing"
        "settings"
      ]
    )
  ];
  options.services.traefik = {
    enable = mkEnableOption "Traefik web server";
    package = mkPackageOption pkgs "traefik" { };

    install = {
      file = mkOption {
        default = null;
        example = literalExpression "/path/to/install_config.toml";
        type = nullOr path;
        description = ''
          Path to Traefik's install configuration file.

          ::: {.note}
          You cannot use this option alongside the declarative configuration options.
          :::
        '';
      };
      settings = mkOption {
        description = ''
          Install configuration for Traefik, written in Nix.

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

    routing = {
      file = mkOption {
        default = null;
        example = literalExpression "/path/to/routing_config.toml";
        type = nullOr path;
        description = ''
          Path to Traefik's routing configuration file.

          ::: {.note}
          You cannot use this option alongside the declarative configuration options.
          :::
        '';
      };
      dir = mkOption {
        default = "/var/lib/traefik/routing";
        example = literalExpression "/etc/traefik/";
        type = nullOr path;
        description = ''
          Path to the directory Traefik should watch for configuration files.

          ::: {.warning}
          Files in this directory matching the glob `_nixos-*` (reserved for Nix-managed routing configurations) will be deleted as part of
          `systemd-tmpfiles-resetup.service`, _**regardless of their origin.**_.
          :::
        '';
      };
      files = mkOption {
        type = attrsOf (submodule {
          options.settings = mkOption {
            type = format.type;
            description = ''
              Routing configuration for Traefik, written in Nix.

              ::: {.note}
              This will be serialized to JSON (which is considered valid YAML) at build, and passed as part of the install file.
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
          Routing configuration files to write. These are symlinked in `services.traefik.routing.dir` upon activation,
          allowing configuration to be upated without restarting the primary daemon.

          ::: {.note}
          Due to [a limitation in Traefik](https://github.com/traefik/traefik/issues/10890); any syntax error in a routing configuration will cause the _**entire file provider**_ to be ignored.
          This may cause interuption in service, which may include access to the Traefik dashboard, if [enabled and configured](https://doc.traefik.io/traefik/reference/install-configuration/api-dashboard/).
          :::
        '';
      };
      # TODO: Drop in 27.05.
      settings = mkOption {
        type = format.type;
        description = ''
          Routing configuration for Traefik, written in Nix.
          This option is intended for easily migrating pre-26.11 Traefik configurations, and will be removed in NixOS 27.05.

          ::: {.note}
          Configurations added here will be translated into a file for {option}`services.traefik.routing.files`, named `custom-migrated`.
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
        This can be used to pass secrets such as [DNS challenge API tokens](https://doc.traefik.io/traefik/reference/install-configuration/tls/certificate-resolvers/acme/#providers) or [ENV variables](https://doc.traefik.io/traefik/reference/install-configuration/boot-environment/#environment-variables).
        ```
        DESEC_TOKEN=
        TRAEFIK_CERTIFICATESRESOLVERS_<NAME>_ACME_EAB_HMACENCODED=
        TRAEFIK_CERTIFICATESRESOLVERS_<NAME>_ACME_EAB_KID=
        ```
        ::: {.warn}
        The traefik install configuration methods (env, CLI, and file) are mutually exclusive.
        :::
        ```
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = (!(isDefault "install.file")) -> isDefault "install.settings";
        message = ''
          The 'services.traefik.install.file' and 'services.traefik.install.settings'
          options are mutually exclusive for the Traefik install config.
          It is recommended to use 'settings'.
        '';
      }
      {
        assertion =
          (!(isDefault "install.file"))
          -> (builtins.all (
            map isDefault [
              "routing.files"
              "routing.dir"
              "routing.file"
            ]
          ));
        message = ''
          None of the routing configuration options may be used if Traefik is being managed imperatively.
          The following options have non-default values:
            - ${
              concatMapStringsSep "\n  - " (str: "'services.traefik.routing.${str}'") (
                filter (attr: !(isDefault "routing.${attr}")) [
                  "files"
                  "dir"
                  "file"
                  "settings" # TODO: Drop in 27.05.
                ]
              )
            }
        '';
      }
      {
        assertion = !(isDefault "routing.file") -> cfg.routing.dir == null;
        message = ''
          The 'services.traefik.routing.file' and 'services.traefik.routing.dir' options
          are mutually exclusive for the Traefik routing config. It is recommended to use
          'services.traefik.routing.dir' with 'services.traefik.routing.files'.
        '';
      }
      {
        assertion = !(isDefault "routing.files") -> !(isDefault "routing.dir");
        message = ''
          'services.traefik.routing.files' requires the routing file provider to be set
          to a directory. Please set a path for 'services.traefik.routing.dir'.
        '';
      }
      {
        assertion = cfg.group != "docker";
        message = ''
          Setting the primary group to 'docker' will cause files, such as those generated
          by 'services.traefik.routing.files', to be owned by the group 'docker', which
          may be a security risk. Use 'services.traefik.supplementaryGroups' instead.
        '';
      }
    ];

    warnings =
      optional (!(builtins.elem "docker" cfg.supplementaryGroups -> config.virtualisation.docker.enable))
        "'services.traefik.supplementaryGroups' contains the 'docker' group, but 'services.docker' is not enabled."
      ++ optional (!(isDefault "routing.settings")) ''
        'services.traefik.routing.settings' is in use, but that option is deprecated.
        Please migrate your configuration to an explicit file instead.

        You may do so by moving the value of 'services.traefik.routing.settings' to
        'services.traefik.routing.files.<name>.settings', where <name> is an arbitrary
        string that ideally identifies the configuration's purpose.

        The following files define 'services.traefik.routing.settings' and should be migrated:
          - ${
            concatStringsSep "\n  - " (
              remove ./traefik.nix (map (attr: attr.file) opt.routing.settings.definitionsWithLocations)
            )
          }
      '';

    # https://github.com/quic-go/quic-go/wiki/UDP-Buffer-Sizes
    boot.kernel.sysctl = {
      "net.core.rmem_max" = 2500000;
      "net.core.wmem_max" = 2500000;
    };

    # If a routing file or directory has been set, add it as a provider in the install configuration
    services.traefik = mkIf (isDefault "install.file") {
      routing.files = mkIf (!(isDefault "install.file")) {
        "custom-migrated".settings = cfg.routing.settings;
      };
      install.settings =
        mkIf (!(isDefault "routing.dir") || !(isDefault "routing.file")) mkIf
          (cfg.routing.dir != null || !(isDefault "routing.file"))
          {
            providers.file = {
              directory = mkIf (!(isDefault "routing.dir")) cfg.routing.dir;
              filename = mkIf (!(isDefault "routing.file")) cfg.routing.file;
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
      unitConfig.Documentation = "https://doc.traefik.io/traefik/";
      serviceConfig = {
        EnvironmentFile = cfg.environmentFiles;
        ExecStart = "${getExe cfg.package} --configfile=${installFile}";
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
        ReadOnlyPaths = optional (cfg.routing.dir != null) cfg.routing.dir;
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
      (mkIf (cfg.routing.dir != null) (
        {
          ${cfg.routing.dir}.d = {
            inherit (cfg) user group;
            mode = "0700";
          };
          "${cfg.routing.dir}/_nixos-*".r = { };
        }
        // (mapAttrs' (
          name: value:
          nameValuePair "${cfg.routing.dir}/_nixos-${name}.yml" {
            "L+" = {
              mode = "0444";
              argument = toString (format.generate name value.settings);
            };
          }
        ) cfg.routing.files)
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
