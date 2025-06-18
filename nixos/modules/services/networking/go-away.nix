{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  inherit (lib) types;
  yamlFormat = pkgs.formats.yaml { };

  cfg = config.services.go-away;
  hostConfig = config;
  enabledInstances = lib.filterAttrs (_: conf: conf.enable) cfg.instances;

  instanceName = name: if name == "" then "go-away" else "go-away-${name}";

  configFile = name: instance: yamlFormat.generate "${instanceName name}-config.yaml" instance.config;
  policyEtcPath = name: "go-away/${if name == "" then "default" else name}-policy.yaml";
  policyFile =
    name: instance:
    pkgs.runCommandLocal "${instanceName name}-policy.yaml"
      {
        nativeBuildInputs = [ cfg.package ];
      }
      ''
        cat ${yamlFormat.generate "${instanceName name}-policy.yaml" instance.policy} > $out
        go-away -check -config ${configFile name instance} -policy $out
      '';
in
{
  options.services.go-away = {
    package = lib.mkPackageOption pkgs "go-away" { };

    instances = lib.mkOption {
      default = { };
      description = ''
        An attribute set of Go-Away instances.

        The attribute name may be an empty string, in which case the `-<name>` suffix is not added to the service name
        and socket paths.
      '';
      type = types.attrsOf (
        types.submodule (
          { name, config, ... }:
          {
            options = {
              enable = lib.mkEnableOption "this instance of Go-Away" // {
                default = true;
              };

              extraFlags = lib.mkOption {
                default = [ ];
                description = "A list of extra flags to be passed to Go-Away.";
                example = [ "-slog-level DEBUG" ];
                type = types.listOf types.str;
              };

              bindHost = lib.mkOption {
                default = "";
                type = types.str;
              };

              bindPort = lib.mkOption {
                type = types.ints.positive;
              };

              useACMEHost = lib.mkOption {
                default = null;
                type = types.nullOr types.str;
              };

              tlsCertificate = lib.mkOption {
                default =
                  if config.useACMEHost != null then
                    "${hostConfig.security.acme.certs.${config.useACMEHost}.directory}/fullchain.pem"
                  else
                    null;
                type = types.nullOr types.str;
              };

              tlsKey = lib.mkOption {
                default =
                  if config.useACMEHost != null then
                    "${hostConfig.security.acme.certs.${config.useACMEHost}.directory}/key.pem"
                  else
                    null;
                type = types.nullOr types.str;
              };

              config = lib.mkOption {
                default = { };
                description = ''
                  TODO
                '';
                type = types.submodule {
                  freeformType = yamlFormat.type;
                  options = {
                    bind = lib.mkOption {
                      default = { };
                      type = types.submodule {
                        freeformType = yamlFormat.type;
                        options = {
                          address = lib.mkOption {
                            type = types.str;
                            default = "${config.bindHost}:${builtins.toString config.bindPort}";
                            readOnly = true;
                          };
                          tls-certificate = lib.mkOption {
                            type = types.nullOr types.str;
                            default =
                              if config.tlsCertificate != null then
                                "/run/credentials/${instanceName name}.service/tlsCertificate"
                              else
                                null;
                            readOnly = true;
                          };
                          tls-key = lib.mkOption {
                            type = types.nullOr types.str;
                            default =
                              if config.tlsKey != null then "/run/credentials/${instanceName name}.service/tlsKey" else null;
                            readOnly = true;
                          };
                          # TODO
                        };
                      };
                    };
                    # TODO
                  };
                };
              };

              policy = lib.mkOption {
                default = { };
                description = ''
                  TODO
                '';
                type = types.submodule {
                  freeformType = yamlFormat.type;
                  options = {
                    # TODO
                  };
                };
              };
            };
          }
        )
      );
    };
  };

  config = lib.mkIf (enabledInstances != { }) {
    environment.etc = lib.mapAttrs' (
      name: instance:
      lib.nameValuePair (policyEtcPath name) ({
        source = policyFile name instance;
      })
    ) enabledInstances;
    systemd.services = lib.mapAttrs' (
      name: instance:
      lib.nameValuePair "${instanceName name}" {
        description = "Go-Away (${if name == "" then "default" else name} instance)";
        wantedBy = [ "multi-user.target" ];
        wants = lib.lists.optional (
          instance.useACMEHost != null
        ) "acme-finished-${instance.useACMEHost}.target";
        after = [
          "network.target"
        ] ++ (lib.lists.optional (instance.useACMEHost != null) "acme-${instance.useACMEHost}.service");
        reloadTriggers = [ (policyFile name instance) ];

        serviceConfig = {
          DynamicUser = true;

          ExecStart = utils.escapeSystemdExecArgs (
            (lib.singleton (lib.getExe cfg.package))
            ++ [
              "-config"
              (configFile name instance)
              "-policy"
              "/etc/${policyEtcPath name}"
              # TODO Snippets. Would need to include the example things though.
              "-cache"
              "/var/cache/${instanceName name}"
              # TODO Other arguments that don't have a corresponding YAML option: -client-ip-header, -path
              # TODO Thing that should be handled as credential JWT_PRIVATE_KEY_SEED
            ]
            ++ instance.extraFlags
          );
          ExecReload = "${pkgs.coreutils}/bin/kill -SIGHUP $MAINPID";
          CacheDirectory = instanceName name;
          # TODO Socket support
          # RuntimeDirectory =
          #   if
          #     lib.any (lib.hasPrefix "/run/go-away") (
          #       with instance.settings;
          #       [
          #         BIND
          #         METRICS_BIND
          #       ]
          #     )
          #   then
          #     "go-away"
          #   else
          #     null;

          # hardening
          # TODO
          # NoNewPrivileges = true;
          # CapabilityBoundingSet = null;
          # SystemCallFilter = [
          #   "@system-service"
          #   "~@privileged"
          # ];
          # SystemCallArchitectures = "native";
          # MemoryDenyWriteExecute = true;
          AmbientCapabilities = lib.lists.optional (instance.bindPort < 1024) "CAP_NET_BIND_SERVICE";
          # TODO Anubis had above an empty string, make sure optional produces the same result when bindPort >= 1024
          LoadCredential = lib.lists.optionals (instance.tlsCertificate != null) [
            "tlsCertificate:${instance.tlsCertificate}"
            "tlsKey:${instance.tlsKey}"
          ];
          # PrivateMounts = true;
          # PrivateUsers = true;
          # PrivateTmp = true;
          # PrivateDevices = true;
          # ProtectHome = true;
          # ProtectClock = true;
          # ProtectHostname = true;
          # ProtectKernelLogs = true;
          # ProtectKernelModules = true;
          # ProtectKernelTunables = true;
          # ProtectProc = "invisible";
          # ProtectSystem = "strict";
          # ProtectControlGroups = "strict";
          # LockPersonality = true;
          # RemoveIPC = true;
          # RestrictRealtime = true;
          # RestrictSUIDSGID = true;
          # RestrictNamespaces = true;
          # RestrictAddressFamilies = [
          #   "AF_UNIX"
          #   "AF_INET"
          #   "AF_INET6"
          # ];
        };
      }
    ) enabledInstances;
  };

  meta.maintainers = with lib.maintainers; [
    geoffreyfrogeye
  ];
  # TODO Documentation
  # meta.doc = ./go-away.md;
}
# TODO Tests
