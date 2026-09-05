{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib.types)
    attrsOf
    listOf
    nullOr
    path
    str
    submodule
    ;
  inherit (lib)
    converge
    filterAttrsRecursive
    getExe
    literalExpression
    mapAttrs'
    mkDefault
    mkIf
    mkMerge
    mkOption
    mkRemovedOptionModule
    mkRenamedOptionModule
    nameValuePair
    optional
    recursiveUpdate
    types
    ;

  cfg = config.services.traefik;
  # Traefik accepts JSON as a valid YAML subset
  json = pkgs.formats.json { };
in
{
  imports = [
    (mkRemovedOptionModule
      [
        "services"
        "traefik"
        "useEnvSubst"
      ]
      "Use `services.traefik.environmentFiles` instead, see https://nixos.org/manual/nixos/stable/#module-services-traefik-environment"
    )
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
    enable = lib.mkEnableOption "Traefik, an open-source, cloud-native reverse proxy";
    package = lib.mkPackageOption pkgs "traefik" { };

    install = {
      file = mkOption {
        default = json.generate "install_config.json" (
          # converge is needed to fully remove entire trees of empty attribute sets
          converge (
            # remove `null` (used for comparisons of unset values)
            # and `{}` or `[]`, which is left behind by type checked submodule options
            filterAttrsRecursive (_: val: val != null && val != { } && val != [ ])
          ) cfg.install.settings
        );
        defaultText = literalExpression ''
          (pkgs.formats.json { }).generate "install_config.json" (
            # converge is needed to fully remove entire trees of empty attribute sets
            converge (
              # remove `null` (used for comparisons of unset values)
              # and `{}` or `[]`, which is left behind by type checked submodule options
              filterAttrsRecursive (_: val: val != null && val != { } && val != [ ])
            ) config.services.traefik.install.settings
          );
        '';
        example = literalExpression "/path/to/install_config.yml";
        type = path;
        description = ''
          Path to Traefik's install configuration file, passed to the daemon with the `--configfile` flag
        '';
      };
      settings = mkOption {
        description = ''
          Install configuration for Traefik, written in Nix.

          A full list of available options can be found in the [Traefik docs](https://doc.traefik.io/traefik/reference/install-configuration/configuration-options/)

          ::: {.warning}
          Empty values (`{}`, `[]`, and `null`) are filtered out by default, since they are used to represent
          unset values in option defaults.
          Instead of declaring empty but present attributes as `attr = {}`, declare them as `attr = true`.
          To see exactly how this is handled, see the default value of `services.traefik.install.settings`
          :::

          ::: {.note}
          This will be serialized to JSON (which Traefik accepts JSON as a valid YAML subset) at build, and passed to Traefik with `--configfile`.
          :::
        '';
        type = types.submodule {
          freeformType = json.type;
          options = {
            providers = {
              file = {
                filename = mkOption {
                  default = cfg.routing.file;
                  defaultText = literalExpression "config.services.traefik.routing.file";
                  description = "Load routing configuration from a file.";
                };
                directory = mkOption {
                  default = cfg.routing.dir;
                  defaultText = literalExpression "config.services.traefik.routing.dir";
                  description = "Load routing configuration from one or more .yml or .toml files in a directory";
                };
              };
            };
          };
        };
        default = { };
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
        default = cfg.routing.settingsDrv;
        defaultText = literalExpression "config.services.traefik.routing.settingsDrv";
        example = literalExpression "/path/to/routing_config.yml";
        type = nullOr path;
        description = ''
          Path to Traefik's routing configuration file.
        '';
      };
      dir = mkOption {
        default = null;
        example = literalExpression "/etc/traefik/routing";
        type = nullOr path;
        description = ''
          Path to the directory Traefik should watch for configuration files.

          ::: {.warning}
          Files in this directory matching the glob `__nixos-*` (reserved for Nix-managed routing configurations) will be deleted as part of
          `systemd-tmpfiles-resetup.service`, _**regardless of their origin.**_.
          :::
        '';
      };
      extraFiles = mkOption {
        type = attrsOf (submodule {
          options.settings = mkOption {
            type = json.type;
            description = ''
              Routing configuration for Traefik, written in Nix.

              Available options can be found in the [Traefik docs](https://doc.traefik.io/traefik/reference/routing-configuration/other-providers/file/)

              ::: {.note}
              This will be serialized to JSON (which Traefik accepts as a valid YAML subset)
              at build, and symlinked to `services.traefik.routing.dir` if set
              :::

              ::: {.note}
              If `services.traefik.routing.dir` is not defined, these will be merged
              with `services.traefik.routing.settings` to form `services.traefik.routing.settingsDrv`
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
        # TODO validate `extraFiles` and `settingsDrv` by json schema
        # Traefik does not currently provide a schema, as they are "focused elsewhere"
        # A third party schema has been created and added to https://schemastore.org, which was generated from the traefik source code:
        # https://github.com/xunleii/traefik-json-schema
        # This could be adapted to provide schema validation based on `cfg.package`, which Traefik seems to be open to
        # https://github.com/traefik/traefik/issues/10889#issuecomment-2222821676
        description = ''
          Routing configuration files to write. These are symlinked in `services.traefik.routing.dir` upon activation,
          allowing configuration to be updated without restarting the primary daemon.

          ::: {.warning}
          Due to [a limitation in Traefik](https://github.com/traefik/traefik/issues/10890); a syntax error in _**any**_ routing configuration will cause the _**entire file provider**_ to be ignored.
          This may cause interruption in service, which may include access to the Traefik dashboard, if [enabled and configured](https://doc.traefik.io/traefik/reference/install-configuration/api-dashboard/).
          :::
        '';
      };

      settings = mkOption {
        type = json.type;
        description = ''
          Routing configuration for Traefik, written in Nix.

          Available options can be found in the [Traefik docs](https://doc.traefik.io/traefik/reference/routing-configuration/other-providers/file/)
        '';
        default = { };
        example = {
          http.routers."api" = {
            service = "api@internal";
            rule = "Host(`localhost`)";
          };
        };
      };

      settingsDrv = mkOption {
        type = nullOr path;
        readOnly = true;
        description = ''
          Final declarative routing configuration. If `services.traefik.routing.settings` is declared, this will contain it.
          If `services.traefik.routing.extraFiles` is declared but `services.traefik.routing.dir` is not,
          the contents of `services.traefik.routing.extraFiles.*.settings` will be merged with `services.traefik.routing.settings`.
          This allows other modules to write `enableTraefik` options which are compatible with both `services.traefik.routing.extraFiles` and `services.traefik.routing.settings`

          ::: {.note}
          Modules implementing an `enableTraefik` option should list the following in its description, so that users may override values as needed:
          - The names of any added:
            - `extraFiles`
            - `services`
            - `routers`
          - Whether they declare a router, service, or both
          :::
        '';
        default =
          if (cfg.routing.settings != { }) then
            json.generate "traefik-routing-settings.yml" (
              recursiveUpdate cfg.routing.settings (
                lib.optionalAttrs (cfg.routing.extraFiles != { } && cfg.routing.dir == null) lib.foldAttrs (
                  item: acc: recursiveUpdate item acc
                ) { } (lib.mapAttrsToList (name: value: value.settings) cfg.routing.extraFiles)
              )
            )
          else
            null;
        defaultText = literalExpression ''
          if (config.services.traefik.routing.settings != { }) then
            json.generate "traefik-routing-settings.yml" (
              recursiveUpdate config.services.traefik.routing.settings (
                lib.optionalAttrs (config.services.traefik.routing.extraFiles != { } && config.services.traefik.routing.dir == null) lib.foldAttrs (
                  item: acc: recursiveUpdate item acc
                ) { } (lib.mapAttrsToList (name: value: value.settings) config.services.traefik.routing.extraFiles)
              )
            )
          else
            null;
        '';
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
        With the `docker` routing provider, Traefik manages connection to containers via the Docker socket,
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
        This can be used to pass secrets such as [DNS challenge API tokens][dns-secrets] or [ENV variables][env-vars].

        ```
        DESEC_TOKEN=
        TRAEFIK_CERTIFICATESRESOLVERS_<NAME>_ACME_EAB_HMACENCODED=
        TRAEFIK_CERTIFICATESRESOLVERS_<NAME>_ACME_EAB_KID=
        ```

        ::: {.warn}
        The traefik install configuration methods (env, CLI, and file) are mutually exclusive.
        It’s crucial to choose one method and stick to it, as mixing different configuration options is not supported and can lead to unexpected behavior.
        :::

        [dns-secrets]: https://doc.traefik.io/traefik/reference/install-configuration/tls/certificate-resolvers/acme/#providers
        [env-vars]: https://doc.traefik.io/traefik/reference/install-configuration/boot-environment/#environment-variables
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.routing.file != null -> cfg.routing.dir == null;
        message = ''
          The 'services.traefik.routing.file' and 'services.traefik.routing.dir' options are mutually exclusive.
          It is recommended to use 'services.traefik.routing.dir' with 'services.traefik.routing.extraFiles'.
        '';
      }
      {
        assertion = cfg.routing.extraFiles != { } && cfg.routing.settings == { } -> cfg.routing.dir != null;
        message = ''
          'services.traefik.routing.extraFiles' requires the routing file provider to be set
          to a directory. Please set a path for 'services.traefik.routing.dir'.
        '';
      }
      {
        assertion = cfg.group != "docker";
        message = ''
          Setting the primary group to 'docker' will cause files, such as those generated
          by 'services.traefik.routing.extraFiles', to be owned by the group 'docker', which
          may be a security risk. Use 'services.traefik.supplementaryGroups' instead.
        '';
      }
      {
        assertion = (lib.collect (val: val == { })) cfg.install.settings == [ ];
        message = ''
          `services.traefik.install.settings` contains empty attribute sets, which are now reserved for filtering unset typed options.
          Instead of e.g. `services.traefik.install.settings.api = {};`, use `services.traefik.install.settings.api = true;`
        '';
      }
    ];

    warnings =
      optional (!(builtins.elem "docker" cfg.supplementaryGroups -> config.virtualisation.docker.enable))
        "'services.traefik.supplementaryGroups' contains the 'docker' group, but 'virtualisation.docker.enable' is not enabled. If this is intentional, please open an issue notifying the Traefik NixOS module maintainers";

    # https://github.com/quic-go/quic-go/wiki/UDP-Buffer-Sizes
    boot.kernel.sysctl = {
      "net.core.rmem_max" = mkDefault 7500000;
      "net.core.wmem_max" = mkDefault 7500000;
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
        ExecStart = "${getExe cfg.package} --configfile=${cfg.install.file}";
        Type = "notify";
        User = cfg.user;
        Group = cfg.group;
        SupplementaryGroups = cfg.supplementaryGroups;
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
        RuntimeDirectory = "traefik";
        RuntimeDirectoryMode = "0700";
        WorkingDirectory = cfg.dataDir;
        WatchdogSec = "1s";
      };
    };

    systemd.tmpfiles.settings."10-traefik" = mkMerge [
      (mkIf (cfg.user == "traefik" || cfg.group == "traefik") {
        ${cfg.dataDir}.d = {
          user = mkIf (cfg.user == "traefik") cfg.user;
          group = mkIf (cfg.group == "traefik") cfg.group;
          mode = "0770";
        };
      })
      (mkIf (cfg.routing.dir != null && (cfg.user == "traefik" || cfg.group == "traefik")) {
        ${cfg.routing.dir}.d = {
          user = mkIf (cfg.user == "traefik") cfg.user;
          group = mkIf (cfg.group == "traefik") cfg.group;
          # Traefik doesn't need write perms on this, only read/execute. Global read isn't a security risk
          # because the files that are linked within are already in /nix/store
          mode = "0555";
        };
      })
      (mkIf (cfg.routing.dir != null) (
        {
          # Remove previous declarative routing configuration files
          "${cfg.routing.dir}/__nixos-*".r = { };
        }
        // (mapAttrs' (
          name: value:
          nameValuePair "${cfg.routing.dir}/__nixos-${name}.yml" {
            "L+".argument = toString (json.generate name value.settings);
          }
        ) cfg.routing.extraFiles)
      ))
    ];

    users = {
      users = mkIf (cfg.user == "traefik") {
        traefik = {
          inherit (cfg) group;
          isSystemUser = true;
        };
      };
      groups = mkIf (cfg.group == "traefik") { traefik = { }; };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [
      jackr
      therealgramdalf
    ];
    doc = ./traefik.md;
  };
}
