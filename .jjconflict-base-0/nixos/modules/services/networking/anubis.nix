{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;
  jsonFormat = pkgs.formats.json { };

  cfg = config.services.anubis;
  enabledInstances = lib.filterAttrs (_: conf: conf.enable) cfg.instances;
  instanceName = name: if name == "" then "anubis" else "anubis-${name}";

  commonSubmodule =
    isDefault:
    let
      mkDefaultOption =
        path: opts:
        lib.mkOption (
          opts
          // lib.optionalAttrs (!isDefault && opts ? default) {
            default =
              lib.attrByPath (lib.splitString "." path)
                (throw "This is a bug in the Anubis module. Please report this as an issue.")
                cfg.defaultOptions;
            defaultText = lib.literalExpression "config.services.anubis.defaultOptions.${path}";
          }
        );
    in
    { name, ... }:
    {
      options = {
        enable = lib.mkEnableOption "this instance of Anubis" // {
          default = true;
        };
        user = mkDefaultOption "user" {
          default = "anubis";
          description = ''
            The user under which Anubis is run.

            This module utilizes systemd's DynamicUser feature. See the corresponding section in
            {manpage}`systemd.exec(5)` for more details.
          '';
          type = types.str;
        };
        group = mkDefaultOption "group" {
          default = "anubis";
          description = ''
            The group under which Anubis is run.

            This module utilizes systemd's DynamicUser feature. See the corresponding section in
            {manpage}`systemd.exec(5)` for more details.
          '';
          type = types.str;
        };

        botPolicy = lib.mkOption {
          default = null;
          description = ''
            Anubis policy configuration in Nix syntax. Set to `null` to use the baked-in policy which should be
            sufficient for most use-cases.

            This option has no effect if `settings.POLICY_FNAME` is set to a different value, which is useful for
            importing an existing configuration.

            See [the documentation](https://anubis.techaro.lol/docs/admin/policies) for details.
          '';
          type = types.nullOr jsonFormat.type;
        };

        extraFlags = mkDefaultOption "extraFlags" {
          default = [ ];
          description = "A list of extra flags to be passed to Anubis.";
          example = [ "-metrics-bind \"\"" ];
          type = types.listOf types.str;
        };

        settings = lib.mkOption {
          default = { };
          description = ''
            Freeform configuration via environment variables for Anubis.

            See [the documentation](https://anubis.techaro.lol/docs/admin/installation) for a complete list of
            available environment variables.
          '';
          type = types.submodule [
            {
              freeformType =
                with types;
                attrsOf (
                  nullOr (oneOf [
                    str
                    int
                    bool
                  ])
                );

              options = {
                # BIND and METRICS_BIND are defined in instance specific options, since global defaults don't make sense
                BIND_NETWORK = mkDefaultOption "settings.BIND_NETWORK" {
                  default = "unix";
                  description = ''
                    The network family that Anubis should bind to.

                    Accepts anything supported by Go's [`net.Listen`](https://pkg.go.dev/net#Listen).

                    Common values are `tcp` and `unix`.
                  '';
                  example = "tcp";
                  type = types.str;
                };
                METRICS_BIND_NETWORK = mkDefaultOption "settings.METRICS_BIND_NETWORK" {
                  default = "unix";
                  description = ''
                    The network family that the metrics server should bind to.

                    Accepts anything supported by Go's [`net.Listen`](https://pkg.go.dev/net#Listen).

                    Common values are `tcp` and `unix`.
                  '';
                  example = "tcp";
                  type = types.str;
                };
                SOCKET_MODE = mkDefaultOption "settings.SOCKET_MODE" {
                  default = "0770";
                  description = "The permissions on the Unix domain sockets created.";
                  example = "0700";
                  type = types.str;
                };
                DIFFICULTY = mkDefaultOption "settings.DIFFICULTY" {
                  default = 4;
                  description = ''
                    The difficulty required for clients to solve the challenge.

                    Currently, this means the amount of leading zeros in a successful response.
                  '';
                  type = types.int;
                  example = 5;
                };
                SERVE_ROBOTS_TXT = mkDefaultOption "settings.SERVE_ROBOTS_TXT" {
                  default = false;
                  description = ''
                    Whether to serve a default robots.txt that denies access to common AI bots by name and all other
                    bots by wildcard.
                  '';
                  type = types.bool;
                };

                # generated by default
                POLICY_FNAME = mkDefaultOption "settings.POLICY_FNAME" {
                  default = null;
                  description = ''
                    The bot policy file to use. Leave this as `null` to respect the value set in
                    {option}`services.anubis.instances.<name>.botPolicy`.
                  '';
                  type = types.nullOr types.path;
                };
              };
            }
            (lib.optionalAttrs (!isDefault) (instanceSpecificOptions name))
          ];
        };
      };
    };

  instanceSpecificOptions = name: {
    options = {
      # see other options above
      BIND = lib.mkOption {
        default = "/run/anubis/${instanceName name}.sock";
        description = ''
          The address that Anubis listens to. See Go's [`net.Listen`](https://pkg.go.dev/net#Listen) for syntax.

          Defaults to Unix domain sockets. To use TCP sockets, set this to a TCP address and `BIND_NETWORK` to `"tcp"`.
        '';
        example = ":8080";
        type = types.str;
      };
      METRICS_BIND = lib.mkOption {
        default = "/run/anubis/${instanceName name}-metrics.sock";
        description = ''
          The address Anubis' metrics server listens to. See Go's [`net.Listen`](https://pkg.go.dev/net#Listen) for
          syntax.

          The metrics server is enabled by default and may be disabled. However, due to implementation details, this is
          only possible by setting a command line flag. See {option}`services.anubis.defaultOptions.extraFlags` for an
          example.

          Defaults to Unix domain sockets. To use TCP sockets, set this to a TCP address and `METRICS_BIND_NETWORK` to
          `"tcp"`.
        '';
        example = "127.0.0.1:8081";
        type = types.str;
      };
      TARGET = lib.mkOption {
        description = ''
          The reverse proxy target that Anubis is protecting. This is a required option.

          The usage of Unix domain sockets is supported by the following syntax: `unix:///path/to/socket.sock`.
        '';
        example = "http://127.0.0.1:8000";
        type = types.str;
      };
    };
  };
in
{
  options.services.anubis = {
    package = lib.mkPackageOption pkgs "anubis" { };

    defaultOptions = lib.mkOption {
      default = { };
      description = "Default options for all instances of Anubis.";
      type = types.submodule (commonSubmodule true);
    };

    instances = lib.mkOption {
      default = { };
      description = ''
        An attribute set of Anubis instances.

        The attribute name may be an empty string, in which case the `-<name>` suffix is not added to the service name
        and socket paths.
      '';
      type = types.attrsOf (types.submodule (commonSubmodule false));
    };
  };

  config = lib.mkIf (enabledInstances != { }) {
    users.users = lib.mkIf (cfg.defaultOptions.user == "anubis") {
      anubis = {
        isSystemUser = true;
        group = cfg.defaultOptions.group;
      };
    };

    users.groups = lib.mkIf (cfg.defaultOptions.group == "anubis") {
      anubis = { };
    };

    systemd.services = lib.mapAttrs' (
      name: instance:
      lib.nameValuePair "${instanceName name}" {
        description = "Anubis (${if name == "" then "default" else name} instance)";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];

        environment = lib.mapAttrs (lib.const (lib.generators.mkValueStringDefault { })) (
          lib.filterAttrs (_: v: v != null) instance.settings
        );

        serviceConfig = {
          User = instance.user;
          Group = instance.group;
          DynamicUser = true;

          ExecStart = lib.concatStringsSep " " (
            (lib.singleton (lib.getExe cfg.package)) ++ instance.extraFlags
          );
          RuntimeDirectory =
            if
              lib.any (lib.hasPrefix "/run/anubis") (
                with instance.settings;
                [
                  BIND
                  METRICS_BIND
                ]
              )
            then
              "anubis"
            else
              null;

          # hardening
          NoNewPrivileges = true;
          CapabilityBoundingSet = null;
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
          ];
          SystemCallArchitectures = "native";
          MemoryDenyWriteExecute = true;

          PrivateUsers = true;
          PrivateTmp = true;
          PrivateDevices = true;
          ProtectHome = true;
          ProtectClock = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          ProtectControlGroups = "strict";
          LockPersonality = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          RestrictNamespaces = true;
          RestrictAddressFamilies = [
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
          ];
        };
      }
    ) enabledInstances;
  };

  meta.maintainers = with lib.maintainers; [ soopyc ];
  meta.doc = ./anubis.md;
}
