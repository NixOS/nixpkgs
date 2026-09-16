# Non-module arguments
# These are separate from the module arguments to avoid implicit dependencies.
# This makes service modules self-contains, allowing mixing of Nixpkgs versions.
{ pkgs }:

# The module
{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption types;

  # Paths are interpolated rather than `toString`ed on purpose: interpolation
  # copies the path into the store, so the resulting argument still resolves on
  # the machine that runs the service. `toString` would yield the path of the
  # source tree the configuration was evaluated from, which is not there at
  # runtime.
  pathOrStr = types.coercedTo types.path (x: "${x}") types.str;

  # `argv` and `flags` share a single `lib.mkOrder` space, so flags need a
  # priority. This one sits between `lib.modules.defaultOrderPriority` (1000,
  # what an unadorned `argv` definition gets) and `lib.mkAfter` (1500): plain
  # flags follow plain `argv` entries, while `lib.mkAfter` on `argv` still lands
  # after the flags. See the `flags` option description.
  unadornedFlagPriority = 1250;

  # `attrListWith` re-emits every flag wrapped in `lib.mkOrder`, using
  # `lib.modules.defaultOrderPriority` for flags that carried no ordering
  # property of their own. Rewrite exactly that priority; anything else is an
  # explicit `lib.mkOrder` from the user and is passed through verbatim.
  atFlagPriority =
    def:
    if def.value._type or null == "order" && def.value.priority == lib.modules.defaultOrderPriority then
      def // { value = lib.mkOrder unadornedFlagPriority def.value.content; }
    else
      def;
in
{
  # https://nixos.org/manual/nixos/unstable/#modular-services
  _class = "service";
  imports = [
    ../modules/generic/meta-maintainers.nix
    ../modules/generic/assertions.nix
    (lib.modules.importApply ./config-data.nix { inherit pkgs; })
  ];
  options = {
    services = mkOption {
      type = types.attrsOf (
        types.submoduleWith {
          modules = [
            (lib.modules.importApply ./service.nix { inherit pkgs; })
          ];
        }
      );
      description = ''
        A collection of [modular services](https://nixos.org/manual/nixos/unstable/#modular-services) that are configured in one go.

        You could consider the sub-service relationship to be an ownership relation.
        It **does not** automatically create any other relationship between services (e.g. systemd slices), unless perhaps such a behavior is explicitly defined and enabled in another option.
      '';
      default = { };
      visible = "shallow";
    };

    enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to enable this service.
        When disabled, the service manager generates no configuration for the
        service at all. This is a Nix-level switch, not a "present but stopped"
        state: a disabled service does not show up in the generated
        configuration of any service manager.
      '';
    };

    dependencies = mkOption {
      type = types.submodule {
        options = {
          after = mkOption {
            type = types.listOf types.str;
            default = [ ];
            example = [ "database" ];
            description = ''
              Services that must have finished starting before this service starts.
              The names refer to sibling services at the same level of the
              service tree. Each service manager maps them to its own
              dependency and ordering mechanism.
            '';
          };

          before = mkOption {
            type = types.listOf types.str;
            default = [ ];
            example = [ "web-server" ];
            description = ''
              Services that must start after this service has finished starting.
              The names refer to sibling services at the same level of the
              service tree.
            '';
          };

          requires = mkOption {
            type = types.listOf types.str;
            default = [ ];
            example = [ "filesystems" ];
            description = ''
              Services that must be running for this service to run. If a
              required service fails, this service is stopped as well.
              The names refer to sibling services at the same level of the
              service tree.
            '';
          };

          wants = mkOption {
            type = types.listOf types.str;
            default = [ ];
            example = [ "logging" ];
            description = ''
              Services that are started together with this service, but whose
              failure does not affect this service.
              The names refer to sibling services at the same level of the
              service tree.
            '';
          };
        };
      };
      default = { };
      description = ''
        Dependency and ordering relations to sibling services.
        This is the init-system-independent way to express which services a
        service needs, so that service managers that build a dependency graph
        (e.g. dinit or runit) can start dependencies before the service itself.
      '';
    };

    runtime = mkOption {
      type = types.submodule {
        options = {
          user = mkOption {
            type = types.str;
            default = "root";
            description = "User to run the service process as.";
          };

          group = mkOption {
            type = types.str;
            default = config.runtime.user;
            description = "Group to run the service process as. Defaults to the runtime user.";
          };

          workingDirectory = mkOption {
            type = types.nullOr pathOrStr;
            default = null;
            description = ''
              Working directory for the service process. When null, the
              service manager's default (usually `/`) is used.
            '';
          };
        };
      };
      default = { };
      description = "Runtime context (user, group, working directory) of the service process.";
    };

    environment = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = { FOO = "bar"; };
      description = ''
        Environment variables set for the service process.
        Each service manager maps these to its own mechanism (e.g. systemd
        `Environment=`, an exported variable in a run script).
      '';
    };

    restart = mkOption {
      type = types.submodule {
        options = {
          policy = mkOption {
            type = types.enum [
              "always"
              "on-failure"
              "never"
            ];
            default = "always";
            description = ''
              When to (re)start the service process.

              - `always`: restart whenever the process exits, regardless of exit status.
              - `on-failure`: restart only when the process exits unsuccessfully.
              - `never`: do not restart the process.
            '';
          };

          delay = mkOption {
            type = types.ints.unsigned;
            default = 5;
            description = "Delay in seconds between restart attempts.";
          };
        };
      };
      default = { };
      description = "Restart policy for the service process.";
    };

    process = {
      argv = mkOption {
        type = types.listOf pathOrStr;
        example = lib.literalExpression ''[ (lib.getExe config.package) "--nobackground" ]'';
        description = ''
          Command filename and arguments for starting this service.
          This is a raw command-line that should not contain any shell escaping.
          If expansion of environmental variables is required then use
          a shell script or `importas` from `pkgs.execline`.

          When `flags` are set, the arguments rendered from them are merged into
          `argv`. See `flags` for how the two are ordered against each other.
        '';
      };

      flagFormat = mkOption {
        type = types.functionTo (types.attrsOf types.anything);
        default = name: {
          option = name;
          sep = null;
          explicitBool = false;
        };
        description = ''
          Function mapping flag names to option format specs
          for `lib.cli.toCommandLine`.

          Receives the flag name and returns `{ option, sep, explicitBool, formatArg? }`.
        '';
        example = lib.literalExpression ''
          name: {
            option = name;
            sep = "=";
            explicitBool = false;
          }
        '';
      };

      flags = mkOption {
        type = types.attrListWith {
          elemType = types.nullOr (
            types.oneOf [
              types.bool
              types.int
              # `pathOrStr`, not `types.path`: `lib.cli.toCommandLine` renders
              # values with `lib.generators.mkValueStringDefault`, which has no
              # case for paths and would abort.
              pathOrStr
            ]
          );
          asAttrs = true;
        };
        default = { };
        description = ''
          Flags to pass to the service process.
          The key is the flag name (e.g. `"--port"`), the value is the flag value.

          Each `name = value` pair is rendered via `lib.cli.toCommandLine`
          using `flagFormat`.

          - `null`: the flag is omitted (regardless of `flagFormat`)
          - bool: rendered per `flagFormat.explicitBool`
            - `explicitBool = false` (default): `true` emits the bare flag,
              `false` is omitted
            - `explicitBool = true`: both `true` and `false` are rendered as
              explicit arguments via `flagFormat.formatArg`
          - string / path / int: rendered as the option's argument, joined to the
            option name per `flagFormat.sep` and stringified by
            `flagFormat.formatArg`

          To pass the same flag multiple times, use the list form with
          repeated keys, e.g.
          `[ { "--host" = "a"; } { "--host" = "b"; } ]`.

          The rendered arguments are merged into `argv`, so `argv` and `flags`
          share a single `lib.mkOrder` space:

          - A flag with no ordering property of its own is placed at priority
            1250, between `lib.modules.defaultOrderPriority` (1000, which is
            what an unadorned `argv` definition gets) and `lib.mkAfter` (1500).
            Plain flags therefore follow the command name and any other plain
            `argv` arguments.
          - `lib.mkAfter` on `argv` still lands after the flags, which is how
            trailing positional arguments are expressed.
          - `lib.mkOrder` on a flag is honoured verbatim against `argv`, so a
            sub-command can be placed between two groups of flags.

          Because 1250 is substituted for flags that carry no ordering property,
          `lib.mkOrder 1000` on a flag is indistinguishable from leaving that
          flag unadorned. To order a flag around plain `argv` entries, pick a
          priority next to 1000, such as 999 or 1001.
        '';
        example = lib.literalExpression ''
          {
            "--port" = "8080";
            "--verbose" = true;
            # ordered ahead of the unadorned flags above
            "--config" = lib.mkOrder 1100 "/etc/foo.conf";
          }
          # or, for repeated flags:
          [
            { "--host" = "localhost"; }
            { "--host" = "0.0.0.0"; }
          ]
        '';
      };

      reloadSignal = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "HUP";
        description = ''
          Configures the reload signal to send to the service manager.
        '';
      };

      reloadCommand = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = lib.literalExpression ''"''${pkgs.coreutils}/bin/kill -HUP $MAINPID"'';

        description = ''
          Command used for reloading in the underlying service manager to reload.
        '';
      };

      type = mkOption {
        type = types.enum [
          "simple"
          "oneshot"
          "forking"
          "notify"
        ];
        default = "simple";
        description = ''
          Lifecycle type of the service process.

          - `simple`: a long-running foreground process. The service is
            considered started as soon as the process is spawned.
          - `oneshot`: a process that runs to completion. The service is
            considered started when the process has exited successfully.
          - `forking`: the process forks and the parent exits. The service
            manager must track the daemonized child.
          - `notify`: the process signals readiness itself, via a service
            manager notification protocol (see `notificationProtocol`).
        '';
      };

      stopSignal = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "HUP";
        description = ''
          Signal used to stop the service process. When null, the service
          manager's default stop signal is used.
        '';
      };

      startTimeout = mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        example = 30;
        description = ''
          Maximum time in seconds the service is allowed to take to start.
          When null, the service manager's default is used.
        '';
      };

      stopTimeout = mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        example = 30;
        description = ''
          Maximum time in seconds the service is allowed to take to stop.
          When null, the service manager's default is used.
        '';
      };
    };

    notificationProtocol = mkOption {
      type = types.submodule {
        options = {
          systemd = mkEnableOption "Whether the service supports systemd-notify.";
          s6 = mkEnableOption "Whether the service supports s6-notify.";
        };
      };
      description = ''
        Notification protocol that this service supports with the underlying service manager.
      '';
    };
  };

  config = {
    assertions = [
      {
        # `reloadSignal` derives `reloadCommand` at `mkDefault` priority below, so a
        # conflict only exists when the user *also* set `reloadCommand` explicitly.
        # An explicit (non-`mkDefault`) definition has `defaultOverridePriority`.
        assertion =
          !(
            config.process.reloadSignal != null
            && options.process.reloadCommand.highestPrio <= lib.modules.defaultOverridePriority
          );
        message = "reloadSignal conflicts with reloadCommand. Please either use reloadSignal or reloadCommand.";
      }
      {
        assertion =
          !(
            config.process.type == "notify"
            && !config.notificationProtocol.systemd
            && !config.notificationProtocol.s6
          );
        message = ''
          process.type = "notify" requires a notification protocol.
          Enable notificationProtocol.systemd or notificationProtocol.s6.
        '';
      }
    ];

    process.reloadCommand = lib.mkIf (config.process.reloadSignal != null) (
      lib.mkDefault "${pkgs.coreutils}/bin/kill -${config.process.reloadSignal} $MAINPID"
    );

    process.argv = lib.modules.mapDefinitionValue (
      attr: lib.cli.toCommandLine config.process.flagFormat attr
    ) (lib.mkMerge (map atFlagPriority options.process.flags.valueMeta.definitions));
  };
}
